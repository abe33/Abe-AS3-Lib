package abe.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class ListEvent extends ComponentEvent 
	{
		static public const ADD : uint = 0;
		public var values : Array;
		public var indices : Array;
		public var action : uint;
		
		public function ListEvent ( type : String, 
									action : uint = 0,
									indices : Array = null, 
									values : Array = null, 
									bubbles : Boolean = false, 
									cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.action = action;
			this.values = values;
			this.indices = indices;
		}
	}
}