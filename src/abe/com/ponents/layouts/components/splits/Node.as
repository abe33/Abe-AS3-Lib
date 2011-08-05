package abe.com.ponents.layouts.components.splits 
{
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class Node
	{
		public var parent : Split;
		public var weight : Number;
		
		protected var _bounds : Rectangle;
		
		public function Node ()
		{
			parent = null;
			weight = 1;
		}

		public function siblingAtOffset ( offset : int ) : Node
		{
		    if (parent == null) 
		    	return null;
		    
		    var siblings : Object = parent.children;
		    var index : int = siblings.indexOf(this);
		    if (index == -1) 
		    	return null;
		    
		    index += offset;
		    return ( index > -1  && 
		    		 index < siblings.length ) ? 
			    		 siblings[index] : 
			    		 null;
		}

		public function nextSiblings () : Node
		{
			return siblingAtOffset(1);
		}
		public function previousSiblings () : Node
		{
			return siblingAtOffset(-1 );
		}
		
		public function get bounds () : Rectangle { return _bounds; }		
		public function set bounds (bounds : Rectangle) : void
		{
			_bounds = bounds;
		}
	}
}
