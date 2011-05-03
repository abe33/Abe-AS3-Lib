package abe.com.edia.fx.sky 
{
	import abe.com.mon.geom.ColorMatrix;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.Range;
	import abe.com.mon.colors.Color;
	import abe.com.mon.randoms.MTRandom;
	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.RandomUtils;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class Sky extends Sprite 
	{
		public var starsRate : Number = 5;
		public var starColors : Array = [ Color.LightBlue, Color.OrangeRed, Color.Yellow, Color.White ];		public var starColorsRate : Array = [ 1, 2, 10, 6 ];
		
		public var nebulaColors : Number = 5;
		
		protected var random : Random;
		protected var skySeed : Number;
		protected var skySize : Dimension;
		protected var skyBitmap : BitmapData;

		public function Sky ( size : Dimension, seed : Number = 0, nebulaColors : Number = 5 )
		{
			skySeed = seed;
			skySize = size;
			this.nebulaColors = nebulaColors;
			cacheAsBitmap = true;
			draw( );
		}
		
		public function clearStars () : void
		{
			var l : uint = numChildren;
			while( l-- )
				removeChildAt(l);	
		}

		public function draw () : void
		{
			random = new Random( new MTRandom( skySeed ) );
			clearStars();
			drawNebula();
			drawStars();
		}
		public function drawNebula () : void
		{
			graphics.clear();
			
			if( skyBitmap )
				skyBitmap.dispose();
			
			skyBitmap = new BitmapData( skySize.width, skySize.height, true, 0x00000000 );			//var bmp2 : BitmapData = new BitmapData( skySize.width, skySize.height, true, 0x00000000 );
			var r : Rectangle = new Rectangle(0,0, skySize.width, skySize.height );
			var o : Point = new Point();
			
			skyBitmap.perlinNoise( skySize.height, skySize.height, 5, skySeed, true, true, 8 + nebulaColors, false );
			
			var cm : ColorMatrix = new ColorMatrix();
			cm.adjustBrightness(-70);
			
			skyBitmap.applyFilter( skyBitmap, r, o, new ColorMatrixFilter( cm.toArray() ) );				skyBitmap.applyFilter( skyBitmap, r, o, new ColorMatrixFilter( cm.toArray() ) );	
					
			var m : Matrix = new Matrix();
			m.createBox(1, 1, random.irandom(0xffffffff), 0, 0);
			
			graphics.beginBitmapFill( skyBitmap, m, true, true );
			graphics.drawRect(0, 0, skySize.width, skySize.height);
			graphics.endFill();
			
			//bmp1.dispose();			//bmp2.dispose();
		}

		public function drawStars () : void
		{
			var i : Number;
			var star : Star;
			var size : Number;
			var b1 : Boolean;			var b2 : Boolean;
			starsRate = 5 + random.random(10);
			var l : Number = starsRate * ( ( skySize.width / 100 ) * ( skySize.height / 100 ) );
			
			for( i = 0; i < l; i++ )
			{
				b1 = random.random() > .95;				b2 = random.random() > .1;
				size = random.range( new Range (0.5, 2) );
				star = new Star( RandomUtils.inArrayWithRatios( starColors, starColorsRate, false ), size, b1, !b1 && b2 );
				
				star.x = random.random( skySize.width );				star.y = random.random( skySize.height );
				
				addChild( star );
			}
		}
		public function update () : void
		{
		}
		
		public function get size () : Dimension
		{
			return skySize;
		}
		
		public function set size (skySize : Dimension) : void
		{
			this.skySize = skySize;
		}
	}
}
