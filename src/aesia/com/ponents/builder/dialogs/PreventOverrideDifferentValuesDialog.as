package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventOverrideDifferentValuesDialog extends WarningDialog 
	{
		public function PreventOverrideDifferentValuesDialog ( memoryKey : String = "warning", memoryChannel : String = "dialogs" )
		{
			super( 	new Label( _( "The selected objects have different values across them.\nAre you sure you want to override these values ?" ) ), 
					memoryKey, 
					memoryChannel );
		}
	}
}
