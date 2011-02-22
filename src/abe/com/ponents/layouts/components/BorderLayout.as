package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.utils.Insets;

	/**
	 * @author Cédric Néhémie
	 */
	public class BorderLayout extends AbstractComponentLayout 
	{
		protected var _north : Component;		protected var _south : Component;		protected var _east : Component;		protected var _west : Component;		protected var _center : Component;
		protected var _forceStretch : Boolean;
		protected var _gap : uint;

		public function BorderLayout (container : Container = null, forceStretch : Boolean = true, gap : uint = 0 )
		{
			super( container );
			_forceStretch = forceStretch;
			_gap = gap;
		}

		public function get north () : Component { return _north; }		
		public function set north (north : Component) : void
		{
			_north = north;
		}
		
		public function get south () : Component { return _south; }		
		public function set south (south : Component) : void
		{
			_south = south;
		}
		
		public function get east () : Component { return _east; }		
		public function set east (east : Component) : void
		{
			_east = east;
		}
		
		public function get west () : Component { return _west;	}		
		public function set west (west : Component) : void
		{
			_west = west;
		}
		
		public function get center () : Component { return _center;	}		
		public function set center (center : Component) : void
		{
			_center = center;
		}
		public function get gap () : uint { return _gap; }
		public function set gap (gap : uint) : void
		{
			_gap = gap;
		}
		
		public function addComponent( component : Component, constraint : String = "center" ) : void
		{
			switch ( constraint )
			{
				case "north" : 
					_north = component;
					break;
				case "south" : 
					_south = component;
					break;
				case "east" : 
					_east = component;
					break;
				case "west" :
					_west = component; 
					break;
				case "center" : 
					_center = component;
					break;
				default : 
					break;
			}
		}
		public function removeComponentAt( constraint : String = "center" ) : void
		{
			switch ( constraint )
			{
				case "north" : 
					_north = null;
					break;
				case "south" : 
					_south = null;
					break;
				case "east" : 
					_east = null;
					break;
				case "west" :
					_west = null; 
					break;
				case "center" : 
					_center = null;
					break;
				default : 
					break;
			}
		}
		
		override public function get preferredSize () : Dimension { return estimatedSize (); }
		
		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : estimatedSize();
			
			_lastMaximumContentSize = prefDim.clone();
			
			var centerWidth : Number = prefDim.width;
			var centerHeight : Number = prefDim.height;
			var centerX : Number = insets.left;
			var centerY : Number = insets.top;
			
			if( _north && _north.visible )
			{
				if( _forceStretch )
					_north.size = new Dimension( prefDim.width, _north.preferredSize.height );
				_north.x = centerX;				_north.y = centerY;

				centerHeight -= _north.preferredHeight + _gap;
				centerY += _north.preferredHeight + _gap;
			}
			if( _south && _south.visible )
			{
				if( _forceStretch )
					_south.size = new Dimension( prefDim.width, _south.preferredSize.height );
				_south.x = centerX;
				_south.y = insets.top + prefDim.height - _south.height;

				centerHeight -= _south.preferredHeight+_gap;
			}
			if( _west && _west.visible )
			{
				if( _forceStretch )
					_west.size = new Dimension( _west.preferredSize.width, centerHeight );
				_west.x = centerX;
				_west.y = centerY;

				centerWidth -= _west.preferredWidth+_gap;
				centerX += _west.preferredWidth+_gap;
			}
			if( _east && _east.visible )
			{
				if( _forceStretch )
					_east.size = new Dimension( _east.preferredSize.width, centerHeight );
				_east.x = insets.left + prefDim.width - _east.width;
				_east.y = centerY;				
				centerWidth -= _east.preferredWidth+_gap;
			}
			if( _center && _center.visible )
			{
				_center.size = new Dimension( centerWidth, centerHeight );
				_center.x = centerX;
				_center.y = centerY;
			}
			super.layout( preferredSize, insets );
		}

		protected function estimatedSize() : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
			
			// calculate width
			if( _east && _east.visible )
				w += _east.preferredSize.width;
			
			if( _center && _center.visible )
				w += _center.preferredSize.width;
				
			if( _west && _west.visible )
				w += _west.preferredSize.width;
				
			if( _north && _north.visible )
				w = Math.max( w, _north.preferredSize.width );
				
			if( _south && _south.visible )
				w = Math.max( w, _south.preferredSize.width );
				
			// calculate height
			if( _north && _north.visible )
				h += _north.preferredSize.height;
			
			if( _center && _center.visible )
				h += _center.preferredSize.height;
				
			if( _south && _south.visible  )
				h += _south.preferredSize.height;
				
			if( _east && _east.visible )
				h = Math.max( h, _east.preferredSize.height );
				
			if( _west && _west.visible )
				h = Math.max( h, _west.preferredSize.height );
				
			return new Dimension( w, h );
		}
	}
}
