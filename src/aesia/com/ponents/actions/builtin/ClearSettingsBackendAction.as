package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.patibility.settings.events.SettingsBackendEvent;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class ClearSettingsBackendAction extends AbstractAction 
	{
		public function ClearSettingsBackendAction (name : String = "", icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
		}
		override public function execute (e : Event = null) : void 
		{
			if( SettingsManagerInstance.backend )
			{
				SettingsManagerInstance.backend.addEventListener(SettingsBackendEvent.CLEAR, onClear );
				SettingsManagerInstance.backend.clear();
			}
			else
				super.execute( e );
		}
		protected function onClear (event : SettingsBackendEvent) : void 
		{
			super.execute(event);
		}
	}
}
