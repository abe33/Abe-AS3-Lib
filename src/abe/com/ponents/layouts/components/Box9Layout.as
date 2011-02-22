package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.containers.Viewport;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.scrollbars.ScrollBar;
	import abe.com.ponents.scrollbars.Scrollable;
	import abe.com.ponents.utils.Insets;
	import abe.com.ponents.utils.ScrollPolicies;

	/**
	 * @author Cédric Néhémie
	 */
	public class Box9Layout extends AbstractComponentLayout 
	{
		protected var _upper : Component;
		protected var _left : Component;
		protected var _lowerLeft : Component;
		protected var _lowerRight : Component;
		protected var _upperLeft : Component;
		protected var _upperRight : Component;
		protected var _right : Component;
		protected var _lower : Component;
		protected var _center : Component;
		
		public function Box9Layout ( container : Container = null )
		{
			super( container );
		}

		public function get upper () : Component { return _upper; }	
		public function set upper (upper : Component) : void { _upper = upper; }
		
		public function get left () : Component { return _left; }		
		public function set left (left : Component) : void { _left = left; }
		
		public function get lowerLeft () : Component { return _lowerLeft; }		
		public function set lowerLeft (lowerLeft : Component) : void { _lowerLeft = lowerLeft; }
		
		public function get lowerRight () : Component { return _lowerRight;	}		
		public function set lowerRight (lowerRight : Component) : void { _lowerRight = lowerRight; }
				
		public function get upperLeft () : Component { return _upperLeft; }		
		public function set upperLeft (upperLeft : Component) : void { _upperLeft = upperLeft; }
		
		public function get upperRight () : Component {	return _upperRight; }		
		public function set upperRight (upperRight : Component) : void { _upperRight = upperRight; }
		
		public function get right () : Component { return _right; }		
		public function set right (right : Component) : void { _right = right; }
		
		public function get lower () : Component { return _lower; }		
		public function set lower (lower : Component) : void { _lower = lower;	}
		
		public function get center () : Component { return _center; }	
		public function set center (center : Component) : void { _center = center; }

		override public function get preferredSize () : Dimension { return estimatedContentSize(); }

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedContentSize();
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			
			var innerWidth : Number = prefDim.width;
			var innerHeight : Number = prefDim.height;
			var innerX : Number = 0;
			var innerY : Number = 0;
			
			if( _upper )
			{
				innerHeight -= _upper.preferredSize.height;
				innerY += _upper.preferredSize.height;
			}
			if( _left )
			{
				innerWidth -= _left.preferredSize.width;
				innerX += _left.preferredSize.width;
			}
			if( _right )
			{
				innerWidth -= _right.preferredSize.width;
			}
			if( _lower )
			{
				innerHeight -= _lower.preferredSize.height;
			}
			
						
			if( _upper )
			{
				_upper.x = insets.left + innerX;
				_upper.y = insets.top;
				_upper.size = new Dimension( innerWidth , innerY );
				
				if( _right && _upperRight )
				{
					_upperRight.visible = true;
					_upperRight.x = insets.left + innerX + innerWidth;
					_upperRight.y = insets.top;
					_upperRight.size = new Dimension( _right.width, innerY );
				}
				else if( _upperRight )
					_upperRight.visible = false;
					
				
				if( _left && _upperLeft )
				{
					_upperLeft.visible = true;
					_upperLeft.x = insets.left;
					_upperLeft.y = insets.top;
					_upperLeft.size = new Dimension( innerX, innerY );
				}
				else if( _upperLeft )
					_upperLeft.visible = false;
				
			}
			if( _left )
			{
				_left.y = insets.top + innerY;
				_left.x = insets.left;
				_left.size = new Dimension( innerX, innerHeight );
				
				if( _lower && _lowerLeft )
				{
					_lowerLeft.visible = true;
					_lowerLeft.y = insets.top + innerY + innerHeight;
					_lowerLeft.x = insets.left;
					_lowerLeft.size = new Dimension( innerX, _lower.height );
				}
				else if( _lowerLeft )
					_lowerLeft.visible = false;
			}
			
			if( _lower && _right && _lowerRight )
			{
				_lowerRight.visible = true;
				_lowerRight.x = insets.left + innerX + innerWidth;
				_lowerRight.y = insets.top + innerY + innerHeight;
				_lowerRight.size = new Dimension( _right.width, _lower.height );
			}
			else if( _lowerRight )
				_lowerRight.visible = false;
			
			_center.x = insets.left + innerX;
			_center.y = insets.top + innerY;
			_center.size = new Dimension( innerWidth, innerHeight );
			
			super.layout( preferredSize, insets );
		}

		protected function estimatedContentSize () : Dimension
		{
			var w : Number = 0;			var h : Number = 0;
			
			if( _upper )
				h += _upper.preferredHeight;
			if( _lower )
				h += _lower.preferredHeight;
			
			if( _left )
				w += _left.preferredWidth;
			if( _right )
				w += _right.preferredWidth;
				
			if( _center )
			{
				w += _center.preferredWidth;
				h += _center.preferredHeight;
			}
			
			return  new Dimension(w,h);
		}
	}
}
