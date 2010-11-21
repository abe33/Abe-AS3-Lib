package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventRenameSkin extends WarningDialog 
	{
		public function PreventRenameSkin ( memoryKey : String = "warning", memoryChannel : String = "dialogs" )
		{
			super( 	new Label( _( "Renaming a skin can lead some components to lose\ntheir styles if they point to that specific skin,\nor if their direct style don't exist in the default skin.\nDo you want to continue ?" ) ), 
					memoryKey, 
					memoryChannel );
		}
	}
}
