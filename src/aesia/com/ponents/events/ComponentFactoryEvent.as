package aesia.com.ponents.events 
{
	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class ComponentFactoryEvent extends Event 
	{
		static public const BUILD_START : String = "buildStart";		static public const BUILD_COMPLETE : String = "buildComplete";		static public const BUILD_PROGRESS : String = "buildProgress";
		
		public var total : uint;
		public var current : uint;
		
		public function ComponentFactoryEvent ( type : String,
												current : uint,
												total : uint,
												bubbles : Boolean = false, 
												cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.current = current;
			this.total = total;
		}
	}
}
