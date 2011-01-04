package aesia.com.ponents.tools 
{
	/**
	 * @author cedric
	 */
	public class DebugCommandDescriptor 
	{
		public var name : String;
		public var usage : *;
		public var description : *;
		public var options : Array;
		public var fn : Function;

		public function DebugCommandDescriptor ( name : String, 
												 description : * = null, 
												 usage : * = null, 
												 options : Array = null,
												 fn : Function = null )
		{
			this.name = name;
			this.fn = fn;
			this.usage = usage;
			this.description = description;
			this.options = options;
		}
	}
}
