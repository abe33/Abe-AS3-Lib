package aesia.com.ponents.containers 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.scrollbars.Scrollable;

	import flash.geom.Rectangle;

	/**
	 * @author cedric
	 */
	public class ScrollablePanel extends Panel implements Scrollable 
	{
		public function ScrollablePanel ()
		{
		}
		
		public function getScrollableUnitIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 10;
		}

		public function getScrollableUnitIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 10;
		}
		
		public function getScrollableBlockIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 50;
		}
		
		public function getScrollableBlockIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 50;
		}
		
		public function get preferredViewportSize () : Dimension {
			return preferredSize;
		}
		
		public function get tracksViewportH () : Boolean {
			return true;
		}
		
		public function get tracksViewportV () : Boolean {
			return false;
		}
	}
}
