package aesia.com.patibility.settings.events 
{
	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class SettingsBackendEvent extends Event 
	{
		static public const INIT : String = "init";
		static public const SYNC : String = "sync";
		static public const RESET : String = "reset";
		public static const PROGRESS : String = "progress";
		public static const CLEAR : String = "clear";

		public function SettingsBackendEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
