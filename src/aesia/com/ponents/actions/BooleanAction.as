package aesia.com.ponents.actions 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.utils.ContextMenuItemUtils;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
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
			dispatchEvent( new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, "value", _value ) ); 
		}
		override public function execute (e : Event = null) : void 
		{
			_value = !_value;
			dispatchEvent( new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, "value", _value ) );
			super.execute( e );
		}
		
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		public function get contextMenuItem () : ContextMenuItem
		{
			var cmadd : ContextMenuItem = new ContextMenuItem( ContextMenuItemUtils.getBooleanContextMenuItemCaption( _name, _value ) );
			cmadd.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
			addEventListener(PropertyEvent.PROPERTY_CHANGE, 
			function( e : PropertyEvent ) : void
			{
				switch( e.propertyName ) 
				{
					case "value" : 
						cmadd.caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption( _name, e.propertyValue );
						break;
					case "actionEnabled" : 
						cmadd.enabled = e.propertyValue;
						break;
					default : break;
				}
			});
			return cmadd;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
