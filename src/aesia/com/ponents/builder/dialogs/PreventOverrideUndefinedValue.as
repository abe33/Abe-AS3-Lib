package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventOverrideUndefinedValue extends WarningDialog 
	{
		public function PreventOverrideUndefinedValue ()
		{
			super( 	new Label( _( "The selected object(s) property isn't defined.\nAre you sure you want to set it up now ?" ) ) );
		}
	}
}
