package abe.com.ponents.actions 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.utils.ContextMenuItemUtils;

    import flash.events.ContextMenuEvent;
    import flash.ui.ContextMenuItem;
    /**
     * @author cedric
     */
    public class BooleanAction extends AbstractAction 
    {
        protected var _value : Boolean;

        public function BooleanAction ( value : Boolean = false,
                                        name : String = "", 
                                        icon : Icon = null, 
                                        longDescription : String = null, 
                                        accelerator : KeyStroke = null )
        {
            _value = value;
            super( name, icon, longDescription, accelerator );
        }
        public function get value () : Boolean { return _value; }
        public function set value (value : Boolean) : void 
        { 
            _value = value; 
            propertyChanged.dispatch( "value", _value ); 
        }
        override public function execute( ... args ) : void 
        {
            _value = !_value;
            propertyChanged.dispatch( "value", _value );
            super.execute.apply(this, args);
        }
        
        FEATURES::MENU_CONTEXT {
            protected var _contextMenuItem : ContextMenuItem;
            public function get contextMenuItem () : ContextMenuItem
            {
                if(!_contextMenuItem)
                {
                    _contextMenuItem = new ContextMenuItem( ContextMenuItemUtils.getBooleanContextMenuItemCaption( _name, _value ) );
                    _contextMenuItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
                    propertyChanged.add( onPropertyChanged );
                }
                return _contextMenuItem;
            }
            protected function onPropertyChanged ( propertyName : String, propertyValue : * ) : void
            {
                switch( propertyName ) 
                {
                    case "value" : 
                        _contextMenuItem.caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption( _name, propertyValue );
                        break;
                    case "actionEnabled" : 
                        _contextMenuItem.enabled = propertyValue;
                        break;
                    default : break;
                }
            }
        }
    }
}
