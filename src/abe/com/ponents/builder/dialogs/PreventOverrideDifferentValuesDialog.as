package abe.com.ponents.builder.dialogs 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.WarningDialog;
	import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class PreventOverrideDifferentValuesDialog extends WarningDialog 
	{
		public function PreventOverrideDifferentValuesDialog ()
		{
			super( 	new Label( _( "The selected objects have different values across them.\nAre you sure you want to override these values ?" ) ) );
		}
	}
}
