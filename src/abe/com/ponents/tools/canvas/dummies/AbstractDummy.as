package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.StageUtils;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.events.MouseEvent;
    import flash.ui.ContextMenuItem;
    import flash.utils.Dictionary;

    /**
     * @author cedric
     */
    public class AbstractDummy extends Sprite implements Dummy
    {
        static public const DEFAULT_COLOR : Color = Color.Gray;
        static public const SELECTED_COLOR : Color = Color.Black;
        
        protected var _defaultColor : Color;
        protected var _selectedColor : Color;
        
        protected var _selected : Boolean;
        
        public function AbstractDummy () 
        {
            _defaultColor = _defaultColor ? _defaultColor : DEFAULT_COLOR;
            _selectedColor = _selectedColor ? _selectedColor : SELECTED_COLOR; 
        }
        
        public function get color():Color { return  _selected ? _selectedColor : _defaultColor; } 
        
        public function get hasSubObjects () : Boolean { return false; }
        public function get isSelectable () : Boolean { return false; }
		public function get isMovable () : Boolean { return true; }
        
        public function get selected () : Boolean { return _selected; }
        public function set selected ( b : Boolean ) : void { _selected = b; draw(); }
        
        public function isSubObject( o : DisplayObject ) : Boolean { return false; }
        public function remove():void{}
        public function init () : void
        {
            draw();
            registerToOnStageEvents();
            FEATURES::MENU_CONTEXT { 
                _menuContextEnabled = true;
                _menuContextGroups = {};
                _menuContextOrder = [];
                _menuContextMap = {};
                _menuContextEnabledMap = new Dictionary(true);
            } 
        }

        public function dispose () : void
        {
            clear();
            unregisterFromOnStageEvents();
            FEATURES::MENU_CONTEXT { 
                _menuContextEnabled = false;
                _menuContextGroups = null;
                _menuContextOrder = null;
                _menuContextMap = null;
                _menuContextEnabledMap = null;
            } 
        }
        public function draw():void 
        {
            clear();
        }
        public function clear():void
        {
            graphics.clear();
        }
        
        protected function registerToOnStageEvents():void
        {
            addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
            addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
        }
		protected function unregisterFromOnStageEvents():void
        {
            removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
            removeEventListener( MouseEvent.MOUSE_OVER, mouseOver );
        }
        public function mouseOut ( e : MouseEvent ) : void
        {
            e.stopImmediatePropagation();
            FEATURES::MENU_CONTEXT { 
                unsetContextMenu();
            } 
        }
        public function mouseOver ( e : MouseEvent ) : void
        {
            e.stopImmediatePropagation();
            FEATURES::MENU_CONTEXT { 
                setContextMenu();
            }
        }
        
        FEATURES::MENU_CONTEXT { 
            protected var _menuContextGroups : Object;
            protected var _menuContextOrder : Array;
            protected var _menuContextMap : Object;
            protected var _menuContextEnabledMap : Dictionary;
            protected var _menuContextEnabled : Boolean;
            public function get menuContextGroups () : Object { return _menuContextGroups; }
            public function set menuContextGroups ( o : Object ): void
            {
                _menuContextGroups = o;
            }
            public function get menuContextOrder () : Array { return _menuContextOrder; }
            public function set menuContextOrder ( a : Array ) : void
            {
                _menuContextOrder = a;
            }
            TARGET::FLASH_9
            public function get menuContext () : Array { return prepareMenuContext() as Array; }
            
            TARGET::FLASH_10
            public function get menuContext () : Vector.<ContextMenuItem> { return prepareMenuContext() as Vector.<ContextMenuItem>; }
            
            TARGET::FLASH_10_1 
            public function get menuContext () : Vector.<ContextMenuItem> { return prepareMenuContext() as Vector.<ContextMenuItem>; }
            
            public function get menuContextEnabled () : Boolean { return _menuContextEnabled; }
            public function set menuContextEnabled ( b : Boolean ):void{ _menuContextEnabled = b; }
            
            private function prepareMenuContext():*
            {
                
                TARGET::FLASH_9 { var v : Array = []; }
                TARGET::FLASH_10 { var v : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem> (); }
                TARGET::FLASH_10_1 { var v : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem> (); } 
                
                if( _menuContextEnabled )
                {
                    var l : uint = _menuContextOrder.length;
                    for( var i:int=0;i < l;i++)
                    {
                        var contextGroup : Array = _menuContextGroups[ _menuContextOrder[i] ] as Array;
                        if( contextGroup )
                        {
                            var m : uint = contextGroup.length;
                            for(var j:int=0;j < m;j++)
                            {
                                var cmi : ContextMenuItem = contextGroup[j];
                                cmi.separatorBefore = i!=0 && j==0;
        
                                v.push( cmi );
                            }
                        }
                    }
                }
                return v;
            }
            protected function setContextMenu () : void
            {
                
                TARGET::FLASH_9 { var v : Array = menuContext; }
                TARGET::FLASH_10 { var v : Vector.<ContextMenuItem> = menuContext; }
                TARGET::FLASH_10_1 { var v : Vector.<ContextMenuItem> = menuContext; } 
                
                var l : Number = v.length;
                for( var i : Number = 0; i < l; i++ )
                {
                    var cmi : ContextMenuItem = v[ i ];
                    cmi.enabled = _menuContextEnabledMap[cmi];
                }
                StageUtils.setMenus( v );
            }
            protected function unsetContextMenu () : void
            {
                StageUtils.unsetMenus();
            }
            public function addNewContextMenuItemForGroup ( label : String,
                                                            id : String,
                                                            selectCallBack : Function = null,
                                                            group : String = "default",
                                                            groupOrder : int = -1,
                                                            disabled : Boolean = false ) : ContextMenuItem
            {


                var menu : ContextMenuItem = new ContextMenuItem( label, false, !disabled );

                if( selectCallBack != null )
                    menu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, selectCallBack, false, 0, true );

                _menuContextMap[id] = menu;
                _menuContextEnabledMap[ menu ] = !disabled;
                registerContextMenuItemForGroup( menu, group, groupOrder);

                return menu;
            }
            public function addContextMenuItemForGroup ( menu : ContextMenuItem,
                                                         id : String,
                                                         group : String = "default",
                                                         groupOrder : int = -1,
                                                         disabled : Boolean = false ) : void
            {
                _menuContextMap[id] = menu;
                _menuContextEnabledMap[ menu ] = !disabled;
                registerContextMenuItemForGroup( menu, group, groupOrder);
            }
            public function registerContextMenuItemForGroup ( menu : ContextMenuItem, group : String, groupOrder : int = -1 ) : void
            {
                var menuGroup : Array;
                if( !hasContextMenuItemGroup( group ) )
                {
                    menuGroup = [];
                    _menuContextGroups[ group ] = menuGroup;
                    if( groupOrder != -1 && groupOrder < _menuContextOrder.length )
                        _menuContextOrder.splice( groupOrder, 0, group );
                    else
                        _menuContextOrder.push( group );
                }
                else
                    menuGroup = _menuContextGroups[ group ];

                menuGroup.push( menu );
            }
            public function removeContextMenuItemFromGroup( id : String, group : String ) : void
            {
                var cmi : ContextMenuItem = getContextMenuItem( id );
                if( !cmi )
                    throw new Error (_$(_("Unable to delete a contextual menu that does not exist: $0." ), id));

                if( groupContainsContextMenuItem( id, group ) )
                    _menuContextGroups[group].splice( _menuContextGroups[group].indexOf( cmi ), 1 );
            }
            public function putContextMenuItemInGroup( id : String, group : String, forceMove : Boolean = true ) : void
            {
                if( !hasContextMenuItem(id) )
                    throw new Error(_$( _("Can not handle an undefined menu: $0."), id ));
                if( !menuContextGroups.hasOwnProperty( group ) )
                    throw new Error(_$(_("The target group '$0' does not exist."), group ));
                if( isContextMenuItemContainedInGroup(id) )
                {
                    if( !forceMove )
                        throw new Error(_$(_("Unable to move the menu '$0' because it is already contained in the group '$1'."),
                                        id, getContextMenuItemGroup(id) ));

                    removeContextMenuItemFromGroup( id, getContextMenuItemGroup(id) );
                }
                registerContextMenuItemForGroup( getContextMenuItem( id ), group );
            }
            public function removeContextMenuItem ( id : String ) : void
            {
                if( !hasContextMenuItem( id ) )
                    throw new Error (_$(_("Unable to delete a contextual menu that does not exist: $0." ), id));

                if( isContextMenuItemContainedInGroup(id) )
                    removeContextMenuItemFromGroup( id, getContextMenuItemGroup( id ) );

                delete _menuContextMap[id];
            }
            public function cleanContextMenuItemGroup ( group : String ) : void
            {
                if( hasContextMenuItemGroup( group ) )
                {
                    var l : uint = _menuContextGroups[group].length;
                    while(l--)
                        removeContextMenuItem( getContextMenuItemId( _menuContextGroups[group][l] ) );
                }
            }
            public function isContextMenuItemContainedInGroup ( id : String ) : Boolean
            {
                return getContextMenuItemGroup(id) != null;
            }
            public function getContextMenuItemGroup ( id : String ) : String
            {
                for( var i : String in _menuContextGroups )
                    if( groupContainsContextMenuItem( id, i ) )
                        return i;

                return null;
            }
            public function groupContainsContextMenuItem ( id : String, group : String ) : Boolean
            {
                if( !hasContextMenuItemGroup( group ) )
                    throw new Error ( _$(_("The group '$0' does not exist in the list of groups for this instance $1." ), group, this ) );

                return _menuContextGroups[group].indexOf( getContextMenuItem( id ) ) != -1;
            }
            public function getContextMenuItem ( id : String ) : ContextMenuItem
            {
                if( hasContextMenuItem( id ) )
                    return _menuContextMap[id];
                else
                    return null;
            }
            public function getContextMenuItemId ( menu : ContextMenuItem ) : String 
            {
                for( var i : String in _menuContextMap )
                    if( _menuContextMap[ i ] == menu )
                        return i;
                
                return null;
            }
            public function hasContextMenuItem ( id : String ) : Boolean
            {
                return _menuContextMap.hasOwnProperty( id );
            }
            public function hasContextMenuItemGroup ( group : String ) : Boolean
            {
                return _menuContextGroups.hasOwnProperty( group );
            }
            public function setContextMenuItemCaption ( id : String, newCaption : String ) : void
            {
                if( hasContextMenuItem( id ) )
                    getContextMenuItem( id ).caption = newCaption;
            }
            public function setContextMenuItemEnabled ( id : String, enabled : Boolean ) : void
            {
                if( hasContextMenuItem( id ) )
                    _menuContextEnabledMap[ getContextMenuItem( id ) ] = enabled;
            }
        }
    }
}
