package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	public class PreventOverrideSharedInstance extends WarningDialog 
	{
		public function PreventOverrideSharedInstance ( properties : *, memoryKey : String = "warning", memoryChannel : String = "dialogs" )
		{
			super( 	new Label( 
					_$(_( "The values in the following properties was shared by others\ninstances which aren't currently under edit : \n$0\nA copy of theses properties' values will be created\nif you attempt to modify it." ),
					properties ) ), 
					memoryKey, 
					memoryChannel,
					CLOSE_BUTTON );
		}
	}
}
