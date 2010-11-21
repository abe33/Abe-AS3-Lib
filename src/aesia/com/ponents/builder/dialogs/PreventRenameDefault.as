package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventRenameDefault extends WarningDialog 
	{
		public function PreventRenameDefault ( memoryKey : String = "warning", memoryChannel : String = "dialogs" )
		{
			super( 	new Label( _( "You can't rename neither the default skin\nnor one of its styles." ) ), 
					memoryKey, 
					memoryChannel,
					OK_BUTTON, OK_BUTTON );
		}
	}
}
