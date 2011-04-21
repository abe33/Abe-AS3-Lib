/** * @license */package abe.com.edia.fx{	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Allocable;	import abe.com.mon.core.Runnable;	import abe.com.mon.core.Suspendable;	import abe.com.mon.geom.pt;	import abe.com.mon.colors.Color;	import abe.com.mon.utils.Random;	import abe.com.mon.utils.RandomUtils;	import abe.com.motion.Impulse;	import abe.com.motion.ImpulseEvent;	import abe.com.motion.ImpulseListener;	import flash.display.BitmapData;	import flash.display.BlendMode;	import flash.display.GradientType;	import flash.display.Shape;	import flash.filters.GlowFilter;	import flash.geom.Matrix;	import flash.geom.Point;	/**	 * @author Cédric Néhémie	 */	public class PerlinGlow extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable, Randomizable	{		static private var bmp : BitmapData;

		protected var _isRunning : Boolean;		public var radius : Number;		public var color1 : Color;		public var color2 : Color;		public var velocity : Point;
		public var rotationSpeed : Number;
		public function PerlinGlow  ( radius : Number = 24,									  color1 : Color = null,									  color2 : Color = null,									  velocity : Point = null,									  rotationSpeed : Number = 20									  ) 		{			this.radius = radius;			this.color1 = color1 ? color1 : Color.White;			this.color2 = color2 ? color2 : Color.DeepSkyBlue;			this.velocity = velocity ? velocity : pt();			this.rotationSpeed = rotationSpeed;			_randomSource = RandomUtils.RANDOM;		}		protected var _randomSource : Random;				public function get randomSource () : Random { return _randomSource; }		public function set randomSource (randomSource : Random) : void		{			_randomSource = randomSource;		}		static protected function getBitmap () : BitmapData 		{			if( !bmp )			{				var s : Shape = new Shape();				var radius : Number = 16;				var diameter : Number = 32;				var m : Matrix = new Matrix();				m.createGradientBox( diameter, diameter, 0, 0, 0 );											s.graphics.beginGradientFill( GradientType.RADIAL, 														[ 0xffffff, 0xffffff ],														[ 0, 1 ],														[ 0, 255 ], 														m );				s.graphics.drawRect( 0, 0, diameter, diameter );				s.graphics.endFill();								bmp = new BitmapData(diameter, diameter, true, 0 );				bmp.perlinNoise(radius, radius, 8, RandomUtils.irandom(), true, true, 8, true );				bmp.draw( s, null, null, BlendMode.ERASE );			}						return bmp;		}		public function tick (e : ImpulseEvent) : void		{			rotation += rotationSpeed * e.biasInSeconds;			x += velocity.x * e.biasInSeconds;			y += velocity.y * e.biasInSeconds;		}		public function init () : void		{			var bmp : BitmapData = getBitmap();									var m : Matrix = new Matrix();			m.createBox( (radius*2) / 32, (radius*2) / 32, 0, -radius, -radius );									this.graphics.beginBitmapFill( bmp, m );			this.graphics.drawCircle( 0, 0, radius );			this.graphics.endFill();						this.transform.colorTransform = color1.toColorTransform(.5);			this.filters = [new GlowFilter(color2.hexa, 1, radius, radius, 2, 1)];						start();		}		public function dispose () : void		{			this.graphics.clear();			stop();		}				public function isRunning () : Boolean		{			return _isRunning;		}				public function start () : void		{			if( !_isRunning )			{				_isRunning = true;				Impulse.register( tick );			}		}		public function stop () : void		{			if( _isRunning )			{				Impulse.unregister( tick );				_isRunning = false;			}		}	}}