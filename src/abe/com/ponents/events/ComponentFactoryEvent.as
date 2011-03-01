package abe.com.ponents.events 
{
	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class ComponentFactoryEvent extends Event 
	{
		static public const PROCEED_BUILD : String = "proceedBuild";
		
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