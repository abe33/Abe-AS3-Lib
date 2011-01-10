package aesia.com.ponents.nodes.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class PreventDeleteSelectionDialog extends WarningDialog 
	{
		public function PreventDeleteSelectionDialog ()
		{
			super( 	new Label( _( "Are you sure you want to delete the current selection ?" ) ), 
					YES_BUTTON + NO_BUTTON, 
					YES_BUTTON );
		}
	}
}
