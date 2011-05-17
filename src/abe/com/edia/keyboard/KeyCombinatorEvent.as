package abe.com.edia.keyboard
{
	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class KeyCombinatorEvent extends Event 
	{
		static public const NEW_KEYS_SEQUENCE : String = "newKeysSequence";
		static public const KEY_RELEASE : String = "keyRelease";
		static public const KEY_PRESS : String = "keyPress";
		
		public var sequence : String;
		public var key : String;

		public function KeyCombinatorEvent (	type : String, 
												 	sequence : String, 
												 	key : String = null, 
												 	bubbles : Boolean = false, 
												 	cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.sequence = sequence;
			this.key = key;
		}
	}
}
