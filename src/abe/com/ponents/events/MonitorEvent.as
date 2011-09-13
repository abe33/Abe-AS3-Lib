package abe.com.ponents.events 
{
    import abe.com.ponents.monitors.recorders.Recorder;

    import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class MonitorEvent extends Event 
	{
		static public const RECORDER_ADD : String = "recorderAdd";		static public const RECORDER_REMOVE : String = "recorderAdd";
		
		public var recorder : Recorder;
		
		public function MonitorEvent (type : String, rec : Recorder, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			recorder = rec;
		}
	}
}
