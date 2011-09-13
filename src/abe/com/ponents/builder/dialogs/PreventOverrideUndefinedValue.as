package abe.com.ponents.builder.dialogs 
{
    import abe.com.patibility.lang._;
    import abe.com.ponents.containers.WarningDialog;
    import abe.com.ponents.text.Label;
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
