package abe.com.ponents.containers 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.AbstractComponent;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.scrollbars.Scrollable;
	import abe.com.ponents.utils.ScrollUtils;

	import flash.geom.Rectangle;
	/**
	 * @author cedric
	 */
	public class ScrollablePanel extends Panel implements Scrollable 
	{
		public function ScrollablePanel () {}
		
		public function get preferredViewportSize () : Dimension { return preferredSize; }
		public function get tracksViewportH () : Boolean { return true;	}
		public function get tracksViewportV () : Boolean { return !ScrollUtils.isContentHeightExceedContainerHeight( this ); }
		
		public function getScrollableUnitIncrementV (r : Rectangle = null, direction : Number = 1) : Number	{ return direction * 10; }
		public function getScrollableUnitIncrementH (r : Rectangle = null, direction : Number = 1) : Number { return direction * 10; }
		public function getScrollableBlockIncrementV (r : Rectangle = null, direction : Number = 1) : Number { return direction * 50; }
		public function getScrollableBlockIncrementH (r : Rectangle = null, direction : Number = 1) : Number { return direction * 50; }
		
		override protected function setupChildren (c : Component) : void 
		{
			super.setupChildren( c );
			c.addEventListener(ComponentEvent.COMPONENT_RESIZE, componentResize );		}
		override protected function teardownChildren (c : Component) : void 
		{
			super.teardownChildren( c );
			c.removeEventListener(ComponentEvent.COMPONENT_RESIZE, componentResize );
		}
		protected function componentResize (event : ComponentEvent) : void 
		{
			invalidatePreferredSizeCache();
			fireResizeEvent();
		}
		private var _childrenInvalidationSetProgramatically : Boolean;
		override public function invalidatePreferredSizeCache () : void 
		{
			if( !_childrenInvalidationSetProgramatically )
			{
				_childrenInvalidationSetProgramatically = true;
				for each ( var c : AbstractComponent in _children )
					c.invalidatePreferredSizeCache();
				_childrenInvalidationSetProgramatically = false;
			}
			super.invalidatePreferredSizeCache();
		}
	}
}
