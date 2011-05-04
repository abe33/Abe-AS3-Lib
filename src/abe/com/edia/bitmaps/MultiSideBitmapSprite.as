package abe.com.edia.bitmaps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class MultiSideBitmapSprite extends BitmapSprite
	{
		protected var _sides : Object;
		protected var _sidesCount : int;

		public function MultiSideBitmapSprite (data : BitmapData = null)
		{
			super( data );
			_sidesCount = 0;
			_sides = {};
		}
		public function get sidesCount () : int { return _sidesCount; }

		public function get sides () : Object { return _sides; }
		public function set sides (sides : Object) : void
		{
			_sides = sides;

			var n : int = 0;
			for( var i:String in _sides )
				n++;

			_sidesCount = n;
		}

		override public function clone () : *
		{
			var ms : MultiSideBitmapSprite = new MultiSideBitmapSprite(data);
			ms.position = position.clone();
			ms.area = area.clone();
			ms.center = center.clone();
			ms.visible = visible;
			var o : Object = {};
			for( var i : String in _sides )
				o[ i ] = { center:_sides[i].center.clone(),
						   reversed:_sides[i].reversed,
						   bitmap:_sides[i].bitmap };
			ms.sides = o;
			return ms;
		}

		public function hasSideSettings ( sideName : String ) : Boolean
		{
			return _sides.hasOwnProperty( sideName );
		}

		public function setSideSettings ( sideName : String, center : Point, reversed : Boolean, bmp : Bitmap = null ) : void
		{
			if( !hasSideSettings( sideName ) )
				_sidesCount++;

			_sides[ sideName ] = {
								   center:center,
								   reversed:reversed,
								   bitmap:bmp ? bmp : data
								 };
		}
		public function deleteSideSettings ( sideName : String ) : void
		{
			if( hasSideSettings(sideName) )
			{
				delete _sides[sideName];
				_sidesCount--;
			}
		}
	}
}
