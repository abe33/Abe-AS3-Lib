package aesia.com.ponents.layouts.components.splits 
{
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class Split extends Node 
	{
		protected var _children : Vector.<Node>;
		public var rowLayout : Boolean;
		
		public function Split ( row : Boolean = true, weight : Number = 1 )
		{
			rowLayout = row;
			_children = new Vector.<Node>();
			this.weight = weight;
		}

		public function get children () : Vector.<Node> { return _children; }

		public function lastWeightedChild () : Node
		{
		    var weightedChild : Node = null;
		    for each (var child : Node in children) 
		    {
				if (child.weight > 0)
				    weightedChild = child;
		    }
		    return weightedChild;
		}

		public function fixBounds () : void
		{
			var r : Rectangle;
			
			for each( var child : Node in children )
				if( !r )
					r = child.bounds;
				else
					r = r.union( child.bounds );
			
			_bounds = r;
		}
	}
}
