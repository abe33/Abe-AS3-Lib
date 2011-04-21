/**
 * @license
 */
package abe.com.edia.text.core 
{
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class CharEvent extends Event 
	{
		
		static public const CHARS_CREATED 	: String = "charsCreated";
		static public const CHARS_REMOVED 	: String = "charsRemoved";
		public var chars : Object;
		
		public function CharEvent(type:String, chars : Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.chars = chars;
		}
	}
}