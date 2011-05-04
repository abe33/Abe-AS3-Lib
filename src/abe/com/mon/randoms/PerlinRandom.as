package abe.com.mon.randoms 
{
	import abe.com.mon.core.Randomizable;

	import flash.display.BitmapData;
	/**
	 * @author cedric
	 */
	public class PerlinRandom extends BitmapRandom implements RandomGenerator, SeededRandomGenerator
	{
		protected var _baseX : Number;
		protected var _baseY : Number;
		protected var _numOctaves : uint;
		protected var _stitch : Boolean;
		protected var _fractalNoise : Boolean;
		protected var _channelOptions : uint;
		protected var _grayScale : Boolean;
		protected var _offsets : Array;

		static public function init( o : Randomizable ) : Randomizable
		{
			o.randomSource = new Random( new PerlinRandom() );
			return o;
		}
		public function PerlinRandom ( seed : int = 0,
									   baseX : Number = 16, 
									   baseY : Number = 16, 
									   fractalNoise : Boolean = false, 
									   numOctaves : uint = 2, 
									   width : int = 16, 
									   height : int = 16, 
									   stitch : Boolean = false, 
									   transparent : Boolean = false, 
									   channelOptions : uint = 7, 
									   grayScale : Boolean = false,
									   offsets : Array = null ) 
		{
			var bmp : BitmapData = new BitmapData(width, height, transparent, 0 );
			_baseX = baseX;			_baseY = baseY;
			_numOctaves = numOctaves;
			_stitch = stitch;
			_fractalNoise = fractalNoise;
			_channelOptions = channelOptions;
			_grayScale = grayScale;
			
			super( bmp );
			plantSeed(seed);
		}		
		public function plantSeed (seed : uint) : void
		{
			_bmp.perlinNoise( _baseX, 
							  _baseY, 
							  _numOctaves, 
							  seed, 
							  _stitch, 
							  _fractalNoise, 
							  _channelOptions, 
							  _grayScale,
							  _offsets);
		}
		override public function random () : Number 
		{
			return super.random() * 3;
		}
	}
}
