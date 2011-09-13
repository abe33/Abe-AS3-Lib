package abe.com.ponents.events 
{
    import abe.com.ponents.core.Dockable;

    import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class DockEvent extends Event 
	{
		static public const DOCK_ADD : String = "dockAdd";
		static public const DOCK_REMOVE : String = "dockRemove";
		
		public var dock : Dockable;

		public function DockEvent (type : String, dock : Dockable, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.dock = dock;
		}
	}
}
