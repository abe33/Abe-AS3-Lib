package abe.com.ponents.actions.builtin 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.patibility.settings.SettingsManagerInstance;
    import abe.com.patibility.settings.backends.SettingsBackend;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class ClearSettingsBackendAction extends AbstractAction 
	{
		public function ClearSettingsBackendAction (name : String = "", icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
		}
		override public function execute( ... args ) : void 
		{
			if( SettingsManagerInstance.backend )
			{
				SettingsManagerInstance.backend.cleared.addOnce( backendCleared );
				SettingsManagerInstance.backend.clear();
			}
			else
				super.execute.apply( this, args );
		}
		protected function backendCleared ( backend : SettingsBackend ) : void 
		{
			super.execute();
		}
	}
}
