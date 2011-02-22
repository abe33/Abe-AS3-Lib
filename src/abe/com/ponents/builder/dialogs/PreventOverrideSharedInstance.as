package abe.com.ponents.builder.dialogs 
{
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.containers.WarningDialog;
	import abe.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventOverrideSharedInstance extends WarningDialog 
	{
		public function PreventOverrideSharedInstance ( properties : * )
		{
			super( 	new Label( 
					_$(_( "The values in the following properties was shared by others\ninstances which aren't currently under edit : \n$0\nA copy of theses properties' values will be created\nif you attempt to modify it." ),
					properties ) ), 
					CLOSE_BUTTON );
		}
	}
}
