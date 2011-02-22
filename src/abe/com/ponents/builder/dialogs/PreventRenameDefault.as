package abe.com.ponents.builder.dialogs 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.WarningDialog;
	import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class PreventRenameDefault extends WarningDialog 
	{
		public function PreventRenameDefault ()
		{
			super( 	new Label( _( "You can't rename neither the default skin\nnor one of its styles." ) ), 
					OK_BUTTON, OK_BUTTON );
		}
	}
}
