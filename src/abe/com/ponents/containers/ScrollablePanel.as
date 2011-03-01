package abe.com.ponents.containers 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.AbstractComponent;
	import abe.com.ponents.scrollbars.Scrollable;

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
		override public function invalidatePreferredSizeCache () : void 
		{
			for each ( var c : AbstractComponent in _children )
				c.invalidatePreferredSizeCache();

			super.invalidatePreferredSizeCache();
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