package aesia.com.ponents.menus 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.layouts.components.PopupMenuLayout;
	import aesia.com.ponents.scrollbars.Scrollable;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class PopupMenuPanel extends Panel implements Scrollable
	{
		public function PopupMenuPanel ()
		{
			super();
			childrenLayout = new PopupMenuLayout( this );
		}
		
		public function getScrollableUnitIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			var lc : Component;
			var increment : Number;
			
			lc = getComponentUnderPoint( new Point( r.x + 2, r.y + 2 ) );
			if( lc )
			{			
				if( direction > 0 )
					increment = y + lc.y + lc.height;
				else
				{
					var index : Number = _children.indexOf(lc) - 1;
					
					if( index >= 0 )
						increment = y + _children[index].y;
					else
						increment = y;
				}
			}
			else
				increment = direction;
			
			return increment; 
		}		
		public function getScrollableUnitIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return width / 100 * direction;
		}		
		public function getScrollableBlockIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			var lc : Component;
			var increment : Number;
			
			lc = getComponentUnderPoint( new Point( r.x + 2, r.y + 2 ) );
				
			if( lc )
			{
				var index : Number = _children.indexOf( lc );
				
				if( direction > 0 )
				{
					index += 3;
					if( index < _children.length )
					{
						lc = _children[index];
						increment = y + lc.y;
					}
					else
						increment = y + ( height - r.height );
				}
				else
				{
					index -= 3;
					if( index > -1 )
					{
						lc = _children[index];
						increment = y + lc.y;
					}
					else
						increment = y * -1;
				}	
			}
			else
				increment = direction*10;
			
			return increment;
		}		
		public function getScrollableBlockIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return width / 10 * direction;
		}

		public function get preferredViewportSize () : Dimension
		{
			return preferredSize;
		}
		
		public function get tracksViewportH () : Boolean
		{
			return true;
		}
		
		public function get tracksViewportV () : Boolean
		{
			return false;
		}
	}
}
