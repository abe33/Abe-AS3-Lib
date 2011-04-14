/**
 * @license
 */
package abe.com.edia.bitmaps
{
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.pt;
	import abe.com.mon.geom.rect;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 *
	 */
	public class BitmapGrid implements Randomizable
	{
		protected var _cellCache : Object;
		
		protected var _grid : BitmapData;
		protected var _cellSize : Dimension;
		protected var _rows : uint;		protected var _cols : uint;
		
		public var cellCenter : Point;
		protected var _randomSource : Random;

		public function BitmapGrid ( grid : BitmapData, cellSize : Dimension )
		{
			_grid = grid;
			_cellSize = cellSize;
			_cellCache = {};
			_cols = Math.floor( _grid.width / _cellSize.width );			_rows = Math.floor( _grid.height / _cellSize.height );
			cellCenter = new Point( );
			_randomSource = RandomUtils.RANDOM;
		}
		public function get rows () : uint { return _rows; }
		public function get cols () : uint { return _cols; }
		
		public function get cellSize () : Dimension { return _cellSize; }
		public function set cellSize (cellSize : Dimension) : void { _cellSize = cellSize; }
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void { _randomSource = randomSource;	}
		
		public function getBitmapAt ( at : Point ) : BitmapSprite
		{
			if( _cellCache.hasOwnProperty( at ) )
				return _cellCache[ at ].clone();
			else
			{
				var r : Rectangle = rect( at.x * _cellSize.width, 
										  at.y * _cellSize.height, 
										  _cellSize.width,
										  _cellSize.height );
				var bmp : BitmapData = new BitmapData(_cellSize.width, _cellSize.height, true, 0 );
				bmp.copyPixels( _grid, r, pt());
				var b : BitmapSprite = new BitmapSprite( bmp );
				b.center = cellCenter.clone();
				
				_cellCache[ at ] = b;
				
				return b.clone();
			}
		}
		public function getRandomBitmap() : BitmapSprite
		{
			return getBitmapAt( _randomSource.ipointInRange(0, 0, _cols, _rows ) );
		}
	}
}
