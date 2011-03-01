package abe.com.ponents.events 
{
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class UndoManagerEvent extends Event 
	{
		static public const UNDO_DONE : String = "undoDone";
		
		public function UndoManagerEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}