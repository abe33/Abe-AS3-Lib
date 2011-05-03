package abe.com.mon.randoms 
{
	import abe.com.mon.core.Randomizable;

	import flash.display.BitmapData;
	/**
	 * @author cedric
	 */
	public class NoiseRandom extends BitmapRandom implements RandomGenerator 
	{
		static public function init( o : Randomizable ) : Randomizable
		{
			o.randomSource = new Random( new NoiseRandom() );
			return o;
		}
		override public function get isSeeded () : Boolean { return true; }	
		public function NoiseRandom ( seed : int = 0, 
									  width : int = 64,
									  height : int = 64, 
									  transparent : Boolean = false, 
									  channelOptions : uint = 7, 
									  grayScale : Boolean = false ) 
		{
			var bmp : BitmapData = new BitmapData(width, height, transparent, 0 );
			bmp.noise( seed, 0, 255, channelOptions, grayScale);
			
			super( bmp );
		}
	}
}
