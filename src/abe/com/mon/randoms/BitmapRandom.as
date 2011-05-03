package abe.com.mon.randoms 
{
	import flash.display.BitmapData;
	/**
	 * @author cedric
	 */
	public class BitmapRandom implements RandomGenerator 
	{
		protected var _bmp : BitmapData;
		protected var _x : uint;
		protected var _y : uint;
		
		public function BitmapRandom ( bmp : BitmapData ) 
		{
			_bmp = bmp;
			_x = 0;
			_y = 0;
		}
		public function random () : Number
		{
			var n : int;
			if( _bmp.transparent )
				n = _bmp.getPixel32(_x, _y);
			else
				n = _bmp.getPixel(_x, _y);
			
			_x++;
			if( _x > _bmp.width )
			{
				_x = 0;
				_y++;
				if( _y > _bmp.height )
					_y = 0;
			}
			
			return _bmp.transparent ? n / 0xffffffff : n / 0xffffff;
		}
		public function get isSeeded () : Boolean { return false; }
	}
}
