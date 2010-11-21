package aesia.com.ponents.layouts.components.splits 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class Divider extends Node 
	{
		public var location : Number;
		
		public function isVertical () : Boolean
		{
			return parent ? !parent.rowLayout : false;
		}
		public function disableFloating() : void
		{
			if( isVertical() )
				location = bounds.y;
			else
				location = bounds.x;
		}
	}
}