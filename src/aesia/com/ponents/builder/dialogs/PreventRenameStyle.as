package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventRenameStyle extends WarningDialog 
	{
		public function PreventRenameStyle ( memoryKey : String = "warning", memoryChannel : String = "dialogs" )
		{
			super( 	new Label( _( "Renaming a style can lead some components to lose\ntheir styles if it was part of their direct style hierarchy.\nDo you want to continue ?" ) ), 
					memoryKey, 
					memoryChannel );
		}
	}
}
