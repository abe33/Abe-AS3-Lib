package abe.com.ponents.builder.dialogs 
{
    import abe.com.patibility.lang._;
    import abe.com.ponents.containers.WarningDialog;
    import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class PreventRenameStyle extends WarningDialog 
	{
		public function PreventRenameStyle ()
		{
			super( 	new Label( _( "Renaming a style can lead some components to lose\ntheir styles if it was part of their direct style hierarchy.\nDo you want to continue ?" ) ) );
		}
	}
}
