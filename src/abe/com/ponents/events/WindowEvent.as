package abe.com.ponents.events 
{

	/**
	 * @author cedric
	 */
	public class WindowEvent extends ComponentEvent 
	{
		static public const MINIMIZE : String = "minimize";		static public const MAXIMIZE : String = "maximize";		static public const RESTORE : String = "restore";		static public const OPEN : String = "open";		static public const CLOSE : String = "close";
		
		public function WindowEvent ( type : String, 
									  bubbles : Boolean = false, 
									  cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}
