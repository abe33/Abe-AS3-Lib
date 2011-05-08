package abe.com.ponents.events 
{
	import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	public class DialogEvent extends Event 
	{
		static public const DIALOG_RESULT : String = "dialogResult";
		
		public var result : uint;
		public function DialogEvent (type : String, result : uint, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.result = result;
		}
	}
}
