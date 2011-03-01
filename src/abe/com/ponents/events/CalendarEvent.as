package abe.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class CalendarEvent extends ComponentEvent 
	{
		static public const DATE_CHANGE : String = "dateChange";
		
		public function CalendarEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}