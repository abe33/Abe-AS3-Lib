package aesia.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class PopupEvent extends ComponentEvent 
	{
		static public const CLOSE_ON_ACTION : String = "closeOnAction";		static public const CLOSE_ON_CANCEL : String = "closeOnCancel";
		
		public function PopupEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
