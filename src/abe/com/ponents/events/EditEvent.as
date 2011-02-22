package abe.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class EditEvent extends ComponentEvent 
	{
		static public const EDIT_START : String = "editStart";		static public const EDIT_CONFIRM : String = "editConfirmed";		static public const EDIT_CANCEL : String = "editCancelled";
		
		public function EditEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
