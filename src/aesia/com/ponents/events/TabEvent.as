package aesia.com.ponents.events 
{
	import aesia.com.ponents.tabs.Tab;
	/**
	 * @author cedric
	 */
	public class TabEvent extends ComponentEvent 
	{
		static public const TAB_CHANGE : String = "tabChange";		static public const TAB_ADD : String = "tabAdd";		static public const TAB_REMOVE : String = "tabRemove";
		
		public var tab : Tab;

		public function TabEvent (type : String, tab : Tab = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.tab = tab;
		}
	}
}
