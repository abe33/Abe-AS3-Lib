package aesia.com.ponents.utils 
{
	import aesia.com.ponents.containers.Viewport;
	import aesia.com.ponents.containers.AbstractScrollContainer;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;

	/**
	 * @author cedric
	 */
	public class ScrollUtils 
	{
		static public function isContentWidthExceedContainerWidth ( c : Component ) : Boolean
		{
			var p : Container = c.parentContainer;
			if( p && p is Viewport )
			{
				var p2 : AbstractScrollContainer = p.parentContainer as AbstractScrollContainer;
				if( p2 )
					return c.preferredWidth > p2.contentSize.width;
			}
			return false;
		}
		static public function isContentHeightExceedContainerHeight ( c : Component ) : Boolean
		{
			var p : Container = c.parentContainer;
			if( p && p is Viewport )
			{
				var p2 : AbstractScrollContainer = p.parentContainer as AbstractScrollContainer;
				if( p2 )
					return c.preferredHeight > p2.contentSize.height;
			}
			return false;
		}
	}
}
