package abe.com.ponents.menus 
{
    import abe.com.mands.ProxyCommand;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Keys;
    import abe.com.mon.utils.StageUtils;
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.Action;
    import abe.com.ponents.containers.AbstractScrollContainer;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.containers.SlidePane;
    import abe.com.ponents.core.*;
    import abe.com.ponents.layouts.components.GridLayout;
    import abe.com.ponents.layouts.components.MenuListLayout;
    import abe.com.ponents.models.DefaultListModel;
    import abe.com.ponents.utils.ToolKit;

    import org.osflash.signals.Signal;

    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
     * @author Cédric Néhémie
     */
    [Skinable(skin="PopupMenu")]
    [Skin(define="PopupMenu",
          inherit="DefaultComponent",
          preview="abe.com.ponents.menus::PopupMenu.defaultPopupMenuPreview",
          
          state__all__insets="new cutils::Insets(2)",
          state__all__outerFilters="abe.com.ponents.menus::PopupMenu.popupShadow()"
    )]
    public class PopupMenu extends AbstractContainer implements MenuContainer
    {
        FEATURES::BUILDER { 
            static public function defaultPopupMenuPreview () : PopupMenu
            {
                var pm : PopupMenu = new PopupMenu();
                pm.invoker = StageUtils.root;
                var m : Menu = new Menu( _("Sample Menu"));
                
                pm.addMenuItem( new MenuItem( _("Sample MenuItem 1") ) );
                pm.addMenuItem( new MenuItem( _("Sample MenuItem 2") ) );
                pm.addMenuItem( new MenuItem( _("Sample MenuItem 3") ) );
                pm.addSeparator();
                pm.addMenuItem( m );
                m.addMenuItem( new MenuItem( _("Sample SubMenuItem 1") ) );
                m.addMenuItem( new MenuItem( _("Sample SubMenuItem 2") ) );
                m.addMenuItem( new MenuItem( _("Sample SubMenuItem 3") ) );
                
                return pm;
            }
        } 
        
        static public function popupShadow () : Array
        {
            return [new DropShadowFilter(2,45,0,.5,2,2)];
        }
        
        static public const SCROLLBAR_SCROLL_LAYOUT : uint = 0;
        static public const SLIDER_SCROLL_LAYOUT : uint = 1;
        
        protected var _menuList : MenuList;
        protected var _invoker : InteractiveObject;
        
        protected var _scrollContainer : AbstractScrollContainer;
        protected var _scrollLayout : uint;
        
        protected var _maximumVisibleItems : int;
        
        public var popupClosedOnCancel : Signal;
        public var popupClosedOnAction : Signal;
        
        public function PopupMenu ()
        {
            super();
            
            popupClosedOnAction = new Signal();
            popupClosedOnCancel = new Signal();
            
            _allowOver = false;
            _allowPressed = false;
            _allowChildrenFocus = false;
            //_allowFocus = false;
            _childrenLayout = new GridLayout( this, 1, 1, 0, 0 );
            _maximumVisibleItems = -1;
            
            _menuList = new MenuList( new DefaultListModel() );
            _menuList.model.dataChanged.add( dataChanged );
            _menuList.allowMultiSelection = false;
            
            scrollLayout = SLIDER_SCROLL_LAYOUT;
            FEATURES::KEYBOARD_CONTEXT { 
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN   ) ] = new ProxyCommand( down            );
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.UP     ) ] = new ProxyCommand( up              );
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.LEFT   ) ] = new ProxyCommand( navigateToLeft  );
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.RIGHT  ) ] = new ProxyCommand( navigateToRight );
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER  ) ] = new ProxyCommand( enter           );
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.SPACE  ) ] = new ProxyCommand( enter           );
	            _keyboardContext[ KeyStroke.getKeyStroke( Keys.ESCAPE ) ] = new ProxyCommand( escape          );
            } 
        }
        public function get maximumVisibleItems():int { return _maximumVisibleItems; }
        public function set maximumVisibleItems( n:int ):void { _maximumVisibleItems = n; invalidatePreferredSizeCache(); }

        protected function dataChanged ( a : int = 0, i : Array = null, v : Array = null ) : void 
        {
            var m : MenuItem;
            switch( a )
            {
                case DefaultListModel.ADD : 
                    for each( m in v )
                        registerToMenuItemEvent( m );
                    break;
                case DefaultListModel.REMOVE : 
                    for each( m in v )
                        unregisterFromMenuItemEvent( m );
                    break;
                default :     
                    break;
            }
        }
        
        protected function registerToMenuItemEvent (m : MenuItem) : void 
        {
            m.actionChanged.add( actionChanged );
        }
        protected function unregisterFromMenuItemEvent (m : MenuItem) : void 
        {
            m.actionChanged.remove( actionChanged );
        }
        protected function actionChanged ( mi : MenuItem, a : Action ) : void 
        {
            var l : MenuListLayout = ( menuList.childrenLayout as MenuListLayout );
            l.harmonizeBoxesSize();
            size = null;
            menuList.size = null;
            invalidate();
        }

        public function get scrollLayout () : uint { return _scrollLayout; }        
        public function set scrollLayout (scrollLayout : uint) : void
        {
            if( _scrollLayout != scrollLayout )
            {
                if( _scrollContainer )
                {
                    removeComponent( _scrollContainer );
                    _scrollContainer.view = null;
                }
                
                _scrollLayout = scrollLayout;
                
                switch( _scrollLayout )
                {
                    case SCROLLBAR_SCROLL_LAYOUT : 
                        _scrollContainer = new ScrollPane();
                        break;
                    case SLIDER_SCROLL_LAYOUT : 
                    default : 
                        _scrollContainer = new SlidePane( "auto", 250 );
                        break;                        
                }
                _scrollContainer.viewport.styleKey = "EmptyComponent";
                _scrollContainer.styleKey = "EmptyComponent";
                _scrollContainer.view = _menuList;
                _scrollContainer.isAlwaysValidateRoot = false;
                addComponent( _scrollContainer );
            }
            invalidatePreferredSizeCache();
        }
        
        public function get menuList () : MenuList { return _menuList; }        
        public function get scrollContainer () : AbstractScrollContainer { return _scrollContainer; }
        public function get selectedIndex () : int { return _menuList.selectedIndex; }
        public function set selectedIndex ( i : int ) : void { _menuList.selectedIndex = i; }
        
        public function get selectedValue () : * { return _menuList.selectedValue; }
        
        public function get numMenuItems () : int { return _menuList.model.size; }

        public function get invoker () : InteractiveObject { return _invoker; }    
        public function set invoker (invoker : InteractiveObject) : void
        {
            _invoker = invoker;
        }
        
        FEATURES::KEYBOARD_CONTEXT
        override public function get keyboardContext () : Dictionary
        {
            var d : Dictionary = new Dictionary( true );
            for ( var k : * in _keyboardContext )
                d[k] = _keyboardContext[k];
            
            for each( var m : MenuItem in _menuList.children )
            {
                if( m.mnemonic )
                    d[ m.mnemonic ] = new ProxyCommand( selectExecute, false, m );
            }
            return d;
        }

        public function enter () : void
        {
            if( !isNaN( _menuList.selectedIndex ) )
                execute( _menuList.selectedValue );
        }
        public function getPopupCoordinates (menu : Menu) : Point 
        { 
            var bb : Rectangle = menu.getBounds( ToolKit.popupLevel );
            
            var d : Dimension = menu.popupMenu.preferredSize;
            var x : Number;
            if( bb.right + d.width > StageUtils.stage.stageWidth )
                if( bb.left - d.width < 0 )
                    x = 0;
                else 
                    x = bb.left - d.width;
            else
                x = bb.right;
                    
            return new Point( x, bb.top ); 
        }
        public function hide ( notifyInvoker : Boolean = true ) : void
        {
            if( this.stage )
            {
                var c : Container = parentContainer;
                
                if( c )
                    c.removeComponent( this );
                else                
                    this.parent.removeChild( this );
                    
                _menuList.clearSelection();
                
                if( _invoker && notifyInvoker )
                    StageUtils.stage.focus = _invoker as InteractiveObject;
                else 
                    popupClosedOnCancel.dispatch( this );
            }
        }
        public function done () : void
        {
            hide();
            popupClosedOnAction.dispatch( this );
        }

        public function escape () : void
        {
            hide();
            popupClosedOnCancel.dispatch( this );
        }
        
        public function navigateToLeft () : void
        {
            _menuList.clearSelection();
            if( _invoker )
            {
                if( _invoker is MenuItem && ( !(_invoker is Menu) || !( ( _invoker as MenuItem ).menuContainer is PopupMenu ) )  )
                  ( _invoker as MenuItem ).menuContainer.navigateToLeft();
                else
                    StageUtils.stage.focus = _invoker as InteractiveObject;
            }
        }
        public function navigateToRight () : void
        {
            if( !isNaN(_menuList.selectedIndex ) )
            {
                var m : Menu = getItem( _menuList.selectedIndex ) as Menu;
                if( m && m.hasSubItems && _focus )
                {
                     StageUtils.stage.focus = m.popupMenu;
                     m.popupMenu.down();
                     return;
                }
            }
            if( _invoker && _invoker is MenuItem )
              ( _invoker as MenuItem ).menuContainer.navigateToRight();
        }
        public function down () : void
        {
            _menuList.selectNext();
            /*
            if( _menuList.selectedValue is Menu )
                execute( _menuList.selectedValue as MenuItem );*/
        }

        public function up () : void
        {
            _menuList.selectPrevious();
            if( _menuList.selectedValue is Menu )
                execute( _menuList.selectedValue as MenuItem );
        }
        
        public function ensureIndexIsVisible ( i : Number ) : void
        {
            var m : MenuItem = getItem( i );
            if( m )
                _scrollContainer.ensureRectIsVisible( new Rectangle(m.x, m.y, m.width, m.height) );
        }
        public function getItem ( i : uint ) : MenuItem
        { 
            if( i < _menuList.childrenCount )
                return _menuList.children[ i ] as MenuItem;
            else
                return null;
        }
        public function addMenuItem ( m : MenuItem ) : void
        {
            _menuList.model.addElement( m );
            m.mouseEntered.add( overMenuItem );
            m.menuContainer = this;
            m.index = _menuList.model.indexOf( m );
            invalidatePreferredSizeCache();
        }
        public function addMenuItems ( ... args ) : void
        {
            for each ( var m : MenuItem in args )
                if( m )
                    addMenuItem( m );
        }
        
        TARGET::FLASH_9
        public function addMenuItemsVector ( args : Array ) : void { for each ( var m : MenuItem in args ) addMenuItem( m ); }
        TARGET::FLASH_10
        public function addMenuItemsVector ( args : Vector.<MenuItem> ) : void { for each ( var m : MenuItem in args ) addMenuItem( m ); }
        TARGET::FLASH_10_1 
        public function addMenuItemsVector ( args : Vector.<MenuItem> ) : void
        {
            for each ( var m : MenuItem in args )
                addMenuItem( m );
        }
        
        public function addAction ( a : Action ) : void
        {
            addMenuItem( new MenuItem( a ) );
        }
        
        public function addSeparator () : void
        {
            addMenuItem( new MenuSeparator() );
        }

        public function removeMenuItem ( m : MenuItem ) : void
        {
            if( _menuList.selectedValue == m )
                _menuList.selectedIndex = NaN;
            
            m.menuContainer = null;
            m.removeEventListener( MouseEvent.MOUSE_OVER, overMenuItem );
            _menuList.model.removeElement( m );
            invalidatePreferredSizeCache();
        }

        public function removeAllItems () : void
        {
            var a : Array = _menuList.model.toArray();
            a.forEach(function( item : MenuItem, ... args ) : void 
            { 
                removeMenuItem( item );
            } );
        }
        public function itemContentChange (item : MenuItem) : void
        {
            _scrollContainer.size = null;
            _menuList.size = null;
            size = null;
            invalidatePreferredSizeCache();
        }
        public function overMenuItem ( mi : MenuItem ) : void
        {
            if( mi.enabled )
            {
                _menuList.selectedIndex = -1;
                _menuList.selectedIndex = _menuList.model.indexOf(mi);
                if( !_focus )
                    StageUtils.stage.focus = this;
            }
        }
        override public function addedToStage (e : Event) : void
        {
            super.addedToStage(e);
            stage.addEventListener( MouseEvent.CLICK, stageClick );
        }

        override public function removeFromStage (e : Event) : void
        {
            super.removeFromStage( e );
            stage.removeEventListener( MouseEvent.CLICK, stageClick );
        }

        private function stageClick (event : MouseEvent) : void
        {
            if( stage && 
                   ( !this.hitTestPoint( stage.mouseX, stage.mouseY ) && 
                   ( !invoker || 
                    !invoker.hitTestPoint( stage.mouseX, stage.mouseY ) ) )  )
                hide(false);
        }

        override public function invalidatePreferredSizeCache () : void
        {
            if( _menuList )
            {
                var w : Number = ( _scrollContainer.canScrollV ? 
                                     ( _scrollContainer is ScrollPane ? 
                                         (_scrollContainer as ScrollPane).vscrollbar.preferredWidth :
                                         0 ) :
                                     0 );
				var d : Dimension = _menuList.preferredSize;
                
                if( _maximumVisibleItems != -1 )                	
                	_preferredSizeCache = dm(d.width, ( _menuList.preferredHeight / numMenuItems ) * _maximumVisibleItems ).grow( _style.insets.horizontal + w, style.insets.vertical );
                else
                	_preferredSizeCache = d.grow( _style.insets.horizontal + w, style.insets.vertical );
            }
            else
                super.invalidatePreferredSizeCache();
        }

        override public function repaint () : void
        {
            checkSize();
            super.repaint();
        }
        
        public function checkSize () : void
        {
            var size : Dimension = _preferredSizeCache;
            if( size.height > StageUtils.stage.stageHeight )
            {
                height = StageUtils.stage.stageHeight;
                if( y != 0 )
                    y = 0;
            }
            else
            {
                height = size.height;
                _scrollContainer.invalidate();
                if( y + size.height > StageUtils.stage.stageHeight )
                    y = StageUtils.stage.stageHeight - size.height;
            }
            
            if( x < 0 )
                x = 0;
            else if( x + width > StageUtils.stage.stageWidth )
                x = StageUtils.stage.stageWidth-width;
                
        }

        private function execute ( m : MenuItem ) : void
        {
            m.click( new UserActionContext( m, UserActionContext.PROGRAM_ACTION ) );
        }

        protected function selectExecute ( m : MenuItem ) : void
        {
            _menuList.selectedIndex = _menuList.model.indexOf(m);
            if( m is Menu )
            {
                var menu : Menu = m as Menu;
                if( menu.hasSubItems )
                {
                      StageUtils.stage.focus = menu.popupMenu;
                    menu.popupMenu.clearSelection();
                }
            }
            else
            {
                m.click( new UserActionContext( m, UserActionContext.PROGRAM_ACTION ) );
            }
        }
        
        public function clearSelection () : void
        {
            _menuList.clearSelection();
        }

        public function isMenuDescendant (c : Component) : Boolean
        {
            for each( var m : MenuItem in _menuList.children )
            {
                if( m == c )
                    return true;
                else if( m is Menu )
                {
                    var me : Menu = m as Menu;
                    
                    if( me.popupMenu == c )
                        return true;
                    
                    var b : Boolean = me.popupMenu.isMenuDescendant( c );
                    if( b ) return b;
                }
            }
            return false;
        }
    }
}
