package abe.com.mon.randoms 
{
	import abe.com.mon.core.Randomizable;

	import flash.display.BitmapData;
	/**
	 * @author cedric
	 */
	public class PerlinRandom extends BitmapRandom implements RandomGenerator 
	{
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
			bmp.perlinNoise(baseX, baseY, numOctaves, seed, stitch, fractalNoise, channelOptions, grayScale, offsets);
			super( bmp );
		}		
		override public function get isSeeded () : Boolean { return true; }
	}
}
