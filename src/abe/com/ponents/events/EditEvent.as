package abe.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class EditEvent extends ComponentEvent 
	{
		static public const EDIT_START : String = "editStart";
		
		public function EditEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}