package aesia.com.ponents.events 
{
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	
	public class AutoCompletionEvent extends Event
	{
		static public const ENTRIES_FOUND : String = "entriesFound";
		static public const ENTRIES_LOADED : String = "entriesLoaded";
		
		public function AutoCompletionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
