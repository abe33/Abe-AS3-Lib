package abe.com.ponents.events 
{

	/**
	 * @author cedric
	 */
	public class WindowEvent extends ComponentEvent 
	{
		static public const MINIMIZE : String = "minimize";
		
		public function WindowEvent ( type : String, 
									  bubbles : Boolean = false, 
									  cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}