package abe.com.mon.iterators 
{
	import abe.com.mon.core.Iterator;

	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class Vector2DIterator implements Iterator 
	{

		protected var _width : uint;
		protected var _height : uint;
		protected var _x : int;
		protected var _y : int;
		protected var _xStart : int;
		protected var _yStart : int;
		protected var _vec : Vector.<*>;
		protected var _bounds : Rectangle;
		protected var _n : uint;
		protected var _l : uint;

		public function Vector2DIterator ( width : uint, height : uint, a : Vector.<*>, x : int = 0, y : int = 0 )
		{
			_vec = a;
			_width = width;
			_height = height;
			_l = _width * _height;
			_xStart = x-1;
			_yStart = y;
			reset();
		}
		
		public function hasNext () : Boolean
		{
			return _n < _l;
		}

		public function next () : *
		{
			var v : *
			
			if( _x - _xStart >= _width )
			{
				_x = _xStart;
				++_y;
			}
			
			if( hasNext() )
				v = _vec[++_x][_y];
			else
				v =  null;
				
			_n++;
			
			return v;
		}
		
		public function remove () : void
		{
			_vec[_x][_y] = null;
		}
		
		public function reset () : void
		{
			_x = _xStart;
			_y = _yStart;
			_n = 0;
		}
		
		public function get x () : int
		{
			return _x;
		}
		
		public function get y () : int
		{
			return _y;
		}
		
		public function get width () : uint
		{
			return _width;
		}
		
		public function get height () : uint
		{
			return _height;
		}
	}
}
