package abe.com.ponents.events
{

	/**
	 * @author Cédric Néhémie
	 */
	public class DebugEvent extends ComponentEvent
	{
		static public const NOTIFY_WARNING : String = "notifyWarning";

		public function DebugEvent ( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super ( type, bubbles, cancelable );
		}
	}
}