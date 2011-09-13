package abe.com.ponents.events 
{
    import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class ComponentFactoryEvent extends Event 
	{
		static public const PROCEED_BUILD : String = "proceedBuild";		static public const BUILD_START : String = "buildStart";		static public const BUILD_COMPLETE : String = "buildComplete";		static public const BUILD_PROGRESS : String = "buildProgress";
		
		public var total : uint;
		public var current : uint;
		
		public function ComponentFactoryEvent ( type : String,
												current : uint = 0,
												total : uint = 0,
												bubbles : Boolean = false, 
												cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.current = current;
			this.total = total;
		}
	}
}
