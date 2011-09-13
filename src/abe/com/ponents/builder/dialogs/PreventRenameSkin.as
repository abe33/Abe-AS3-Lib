package abe.com.ponents.builder.dialogs 
{
    import abe.com.patibility.lang._;
    import abe.com.ponents.containers.WarningDialog;
    import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class PreventRenameSkin extends WarningDialog 
	{
		public function PreventRenameSkin ()
		{
			super( 	new Label( _( "Renaming a skin can lead some components to lose\ntheir styles if they point to that specific skin,\nor if their direct style don't exist in the default skin.\nDo you want to continue ?" ) ) );
		}
	}
}
