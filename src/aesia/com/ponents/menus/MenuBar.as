package aesia.com.ponents.menus 
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.PopupEvent;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.scrollbars.Scrollable;
	import aesia.com.ponents.utils.Directions;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="MenuBar")]
	[Skin(define="MenuBar",
		  inherit="DefaultComponent",
		  
		  state__all__foreground="skin.noDecoration",		  state__all__background="new deco::SimpleFill(skin.RulerBlue)"
	)]
	public class MenuBar extends AbstractContainer implements MenuContainer, Scrollable
	{
		protected var _selectedIndex : int;
		
		public function MenuBar ()
		{
			super();
			_selectedIndex = -1;
			_allowFocus = false;
			childrenLayout = new InlineLayout(this, 0, "left");
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.LEFT ) ] = new ProxyCommand( navigateToLeft );
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.RIGHT ) ] = new ProxyCommand( navigateToRight );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		public function get selectedIndex () : Number { return _selectedIndex; }		
		public function set selectedIndex ( selectedIndex : Number ) : void
		{
			if( _selectedIndex > -1 )
				getMenu( _selectedIndex ).itemSelected = false;
			
			_selectedIndex = selectedIndex;
			
			if( _selectedIndex > -1 )
				getMenu( _selectedIndex ).itemSelected = true;
		}
		public function get selectedMenu ( ) : Menu { return getMenu( _selectedIndex );	}
		public function set selectedMenu ( m : Menu ) : void
		{
			selectedIndex = _children.indexOf( m );
		}
		
		public function getMenu ( i : uint ) : Menu
		{ 
			if( i < _children.length && i >= 0 )
				return _children[ i ] as Menu;
			else
				return null;
		}
		
		public function addMenuItem (m : MenuItem) : void 
		{
			if( m is Menu )
				addMenu( m as Menu );
		}	
		public function addMenu ( menu : Menu ) : void
		{
			menu.columnsSizes = [0,0,0,0];
			menu.showSubMenuIcon = false;
			
			addComponent( menu );
			
			menu.addWeakEventListener( MouseEvent.MOUSE_OVER, overMenu );			menu.addWeakEventListener( MouseEvent.CLICK, clickMenu );
			//menu.popupMenu.addWeakEventListener( PopupEvent.POPUP_HIDDEN_ON_CANCEL, popupHiddenOnCancel );			menu.menuContainer = this;
		}
		public function addMenus ( ... args ) : void
		{
			for each( var m : Menu in args )
				addMenu( m );
		}
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function addMenusVector ( v : Array ) : void { for each( var m : Menu in v ) addMenu( m ); }
		TARGET::FLASH_10
		public function addMenusVector ( v : Vector.<Menu> ) : void { for each( var m : Menu in v ) addMenu( m ); }
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function addMenusVector ( v : Vector.<Menu> ) : void { for each( var m : Menu in v ) addMenu( m ); }
		
		public function removeMenuItem (m : MenuItem) : void 
		{
			if( m is Menu )
				removeMenu( m as Menu );
		}
		public function removeMenu ( menu : Menu ) : void
		{
			removeComponent( menu );
			
			menu.removeEventListener( MouseEvent.MOUSE_OVER, overMenu );
			menu.removeEventListener( MouseEvent.CLICK, clickMenu );
			menu.menuContainer = null;
		}
		public function removeMenus ( ... args ) : void
		{
			for each( var m : Menu in args )
				removeMenu( m );
		}
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function removeMenusVector ( v : Array ) : void { for each( var m : Menu in v ) removeMenu( m ); }
		TARGET::FLASH_10
		public function removeMenusVector ( v : Vector.<Menu> ) : void { for each( var m : Menu in v ) removeMenu( m ); }
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function removeMenusVector ( v : Vector.<Menu> ) : void { for each( var m : Menu in v ) removeMenu( m ); }
		
		public function isMenuDescendant (c : Component) : Boolean
		{
			for each( var m : MenuItem in _children )
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
		
		public function itemContentChange (item : MenuItem) : void
		{
			size = null;
			invalidatePreferredSizeCache();
		}
		
		public function done () : void
		{
			selectedIndex = -1;
		}
		
		public function down () : void
		{
			if( _selectedIndex != -1 )
			{
				selectedMenu.popupMenu.down();
				StageUtils.stage.focus = selectedMenu.popupMenu;
			}
		}
		public function up () : void
		{
			/*
			if( _selectedIndex != -1 )
				selectedMenu.popupMenu.selectedIndex = selectedMenu.popupMenu.;*/
		}
		public function navigateToLeft () : void
		{
			if( _selectedIndex != -1 )
				selectedIndex = ( _children.length + _selectedIndex - 1) % _children.length;
			else
				selectedIndex = _children.length - 1;
		}

		public function navigateToRight () : void
		{
			if( _selectedIndex != -1 )
				selectedIndex = (_selectedIndex + 1) % _children.length;
			else
				selectedIndex = 0;		
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
					
			return new Point( bb.left, bb.bottom ); 
		}
		
		public function popupHiddenOnCancel (event : PopupEvent) : void
		{
			done();
		}
		public function overMenu ( event : MouseEvent ) : void
		{
			if( !_interactive )
				return;
			
			var m : Menu = event.target as Menu;
			if( m.enabled && selectedMenu )
			{
				selectedMenu = m;
				/*
				if( !_focus )
					StageUtils.stage.focus = this;*/
			}
		}
		protected function clickMenu (event : MouseEvent) : void
		{
			var m : Menu = event.target as Menu;			
			if( !_interactive )
				return;
			
			if( _selectedIndex != -1 )
			{
				
				if( selectedMenu.popupMenu )
					selectedMenu.popupMenu.hide();
				
				selectedIndex = -1;
			}
			else
			{
				selectedMenu = event.target as Menu;
				//selectedMenu.click();
			}
		}
		override public function addedToStage (e : Event) : void
		{
			super.addedToStage( e );
			stage.addEventListener( MouseEvent.CLICK, stageClick );
		}

		override public function removeFromStage (e : Event) : void
		{
			super.removeFromStage( e );
			stage.removeEventListener( MouseEvent.CLICK, stageClick );
		}
		public function stageClick (event : MouseEvent) : void
		{
			if( !this.hitTestPoint( event.stageX, event.stageY ) )
				selectedIndex = -1;
		}
		override public function focusOut (e : FocusEvent) : void
		{
			super.focusOut( e );
			
			var t : InteractiveObject = e.relatedObject as InteractiveObject;
			
			if( t && t is PopupMenu )
			{
				if( isDescendant( ( t as PopupMenu).invoker as Component ) )
					return;
			}
			
			selectedIndex = -1;
		}
		
		public function getScrollableUnitIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 10;
		}

		public function getScrollableUnitIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 10;
		}
		
		public function getScrollableBlockIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 50;
		}
		
		public function getScrollableBlockIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 50;
		}
		
		public function get preferredViewportSize () : Dimension 
		{ 
			return preferredSize; 
		}		
		public function get tracksViewportH () : Boolean
		{
			var l : InlineLayout = ( _childrenLayout as InlineLayout );
			switch( l.direction )
			{
				case  Directions.TOP_TO_BOTTOM : 
				case  Directions.BOTTOM_TO_TOP : 
					return true;
				case  Directions.LEFT_TO_RIGHT : 
				case  Directions.RIGHT_TO_LEFT :
				default:
					return preferredWidth < parentContainer.parentContainer.width;
			}
		}
		
		public function get tracksViewportV () : Boolean
		{
			var l : InlineLayout = ( _childrenLayout as InlineLayout );
			switch( l.direction )
			{
				case  Directions.TOP_TO_BOTTOM : 
				case  Directions.BOTTOM_TO_TOP : 
					return preferredHeight < parentContainer.parentContainer.height;
				case  Directions.LEFT_TO_RIGHT : 
				case  Directions.RIGHT_TO_LEFT :
				default:
					return true;
			}
		}
		
		/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
		override public function get keyboardContext () : Dictionary
		{
			var d : Dictionary = new Dictionary( true );
			for ( var k : * in _keyboardContext )
				d[k] = _keyboardContext[k];
			
			for each( var m : Menu in _children )
			{
				if( m.mnemonic )
					d[ m.mnemonic ] = new ProxyCommand( selectExecute, false, m );
			}
			return d;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		protected function selectExecute ( m : Menu ) : void
		{
			selectedMenu = m;
			if( m.hasSubItems )
			{
				StageUtils.stage.focus = m.popupMenu;
				m.popupMenu.down();
			}
		}
	}
}
