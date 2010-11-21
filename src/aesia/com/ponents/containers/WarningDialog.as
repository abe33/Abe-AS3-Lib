package aesia.com.ponents.containers 
{
	import aesia.com.mon.utils.Cookie;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.buttons.CheckBox;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.InlineLayout;

	/**
	 * @author cedric
	 */
	public class WarningDialog extends Dialog 
	{
		
		
		public function WarningDialog ( content : Component = null, memoryKey : String = "warning", memoryChannel : String = "dialogs", buttons : uint = 12, selectedButton : uint = 4 )
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout( p, 3, "left", "center", "topToBottom" );
			
			p.addComponent( content );
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			_rememberCheckBox = new CheckBox(_("Don't warn me again") );
			
			_channel = memoryChannel;
			_key = memoryKey;
			
			_rememberCheckBox.addEventListener(ComponentEvent.DATA_CHANGE, rememberDataChange );		
			p.addComponent( _rememberCheckBox );	
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			super( _( "Warning" ), buttons, p, selectedButton );
		}
		
		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
		protected var _rememberCheckBox : CheckBox;
		protected var _channel : String;		protected var _key : String;
		
		protected function rememberDataChange (event : ComponentEvent) : void
		{
			var c : Cookie = new Cookie( _channel );
			c[_key] = _rememberCheckBox.value;
		}			
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
