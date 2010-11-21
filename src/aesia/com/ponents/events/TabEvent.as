package aesia.com.ponents.events 
{

	/**
	 * @author cedric
	 */
	public class TabEvent extends ComponentEvent 
	{
		static public const TAB_CHANGE : String = "tabChange";
		
		public function TabEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
