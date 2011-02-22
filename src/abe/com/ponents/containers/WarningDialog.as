package abe.com.ponents.containers 
{
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.buttons.CheckBox;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.InlineLayout;
	/**
	 * @author cedric
	 */
	public class WarningDialog extends Dialog 
	{
		public function WarningDialog ( content : Component = null, buttons : uint = 12, selectedButton : uint = 4 )
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout( p, 3, "left", "center", "topToBottom" );
			
			p.addComponent( content );
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			_rememberCheckBox = new CheckBox(_("Don't warn me again") );
			_rememberCheckBox.addEventListener(ComponentEvent.DATA_CHANGE, rememberDataChange );		
			p.addComponent( _rememberCheckBox );	
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			super( _( "Warning" ), buttons, p, selectedButton );
		}
		
		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
		protected var _rememberCheckBox : CheckBox;
		
		protected function rememberDataChange (event : ComponentEvent) : void
		{
			SettingsManagerInstance.set( this, "ignoreWarning", _rememberCheckBox.value );
		}			
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
