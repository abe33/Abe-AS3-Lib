package abe.com.ponents.nodes.dialogs 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.WarningDialog;
	import abe.com.ponents.text.Label;
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
