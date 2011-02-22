package abe.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class CalendarEvent extends ComponentEvent 
	{
		static public const DATE_CHANGE : String = "dateChange";		static public const MONTH_CHANGE : String = "monthChange";		static public const YEAR_CHANGE : String = "yearChange";
		
		public function CalendarEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
