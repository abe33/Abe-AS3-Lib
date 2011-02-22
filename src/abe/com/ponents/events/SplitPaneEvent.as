package abe.com.ponents.events 
{
	/**
	 * @author cedric
	 */
	public class SplitPaneEvent extends ComponentEvent 
	{
		static public const OPTIMIZE : String = "optimize";		static public const WEIGHT_CHANGE : String = "weightChange";
		
		public function SplitPaneEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
