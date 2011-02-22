package abe.com.ponents.layouts.components.splits 
{
	import abe.com.mon.utils.StringUtils;

	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class Split extends Node 
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _children : Array;		
		TARGET::FLASH_10		protected var _children : Vector.<Node>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _children : Vector.<Node>;
		
		public var rowLayout : Boolean;
		
		public function Split ( row : Boolean = true, weight : Number = 1 )
		{
			rowLayout = row;
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _children = []; }			TARGET::FLASH_10 { _children = new Vector.<Node>(); }			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_children = new Vector.<Node>(); /*FDT_IGNORE*/} /*FDT_IGNORE*/
			
			this.weight = weight;
		}
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get children () : Array { return _children; }
		
		TARGET::FLASH_10
		public function get children () : Vector.<Node> { return _children; }
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
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
		public function toString() : String {
			return StringUtils.stringify( this, { 'row':rowLayout } );
		}
	}
}
