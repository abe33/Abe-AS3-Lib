package aesia.com.ponents.events
{

	/**
	 * @author Cédric Néhémie
	 */
	public class DebugEvent extends ComponentEvent
	{
		static public const NOTIFY_WARNING : String = "notifyWarning";		static public const NOTIFY_ERROR : String = "notifyError";

		public function DebugEvent ( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super ( type, bubbles, cancelable );
		}
	}
}
