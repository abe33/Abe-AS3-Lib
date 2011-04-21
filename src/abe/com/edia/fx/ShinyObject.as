/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.motion.easing.Cubic;
	import abe.com.motion.easing.Quad;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	/**
	 * @author Cédric Néhémie
	 */
	public class ShinyObject implements ImpulseListener, Runnable, Suspendable, Allocable
	{
		protected var _isRunning : Boolean;
		protected var _rays : Array;
		protected var _time : int;
		
		public var target : LayeredSprite;
		
		public var glowColor : Color;
		public var glowSize : Number;
		public var glowBurst : Shape;
		public var glowBurstCycleDuration : Number;
		
		public var numRays : uint;
		public var raysLength : Number;
		public var raysAngularSpeedMin : Number;
		public var raysAngularSpeedMax : Number;
		public var raysAngularSizeMin : Number;
		public var raysAngularSizeMax : Number;

		public var starRate : Number;
		public var starColor1 : Color;				public var starColor2 : Color;		
		public var starRadiusMin : Number;
		public var starRadiusMax : Number;
		public var starVelocityMin : Number;
		public var starVelocityMax : Number;
		public var starLifeMin : Number;
		public var starLifeMax : Number;
		public var raysColor : Color;
		public var blured : Boolean;

		public function ShinyObject ( target : LayeredSprite = null,
		 
									  glowColor : Color = null,									  glowSize : Number = 8,
									  glowBurstCycleDuration : Number = 1500,
									  
									  numRays : uint = 10,									  raysColor : Color = null,
									  raysLength : Number = 60,
									  raysAngularSizeMin : Number = .1,									  raysAngularSizeMax : Number = .4,									  raysAngularSpeedMin : Number = -40,									  raysAngularSpeedMax : Number = 40,
									  
									  starColor1 : Color = null,									  starColor2 : Color = null,
									  starRate : Number = 500,
									  starRadiusMin : Number = 10,
									  starRadiusMax : Number = 13,									  starVelocityMin : Number = 5,									  starVelocityMax : Number = 10,
									  starLifeMin : Number = 1000,
									  starLifeMax : Number = 1500,
									  
									  blured : Boolean = false
									  
									 ) 
		{
			this.target = target;
			
			this.glowColor = glowColor ? glowColor : Color.White;			this.glowSize = glowSize;
			this.glowBurstCycleDuration = glowBurstCycleDuration;
			
			this.numRays = numRays;
			this.raysColor = raysColor ? raysColor : Color.White;
			this.raysLength = raysLength;
			this.raysAngularSizeMin = raysAngularSizeMin;						this.raysAngularSizeMax = raysAngularSizeMax;						this.raysAngularSpeedMin = raysAngularSpeedMin;			this.raysAngularSpeedMax = raysAngularSpeedMax;

			this.starColor1 = starColor1 ? starColor1 : Color.White;			this.starColor2 = starColor2 ? starColor2 : Color.Gold;
			this.starRate = starRate;
			this.starRadiusMin = starRadiusMin;			this.starRadiusMax = starRadiusMax;
			this.starVelocityMin = starVelocityMin;			this.starVelocityMax = starVelocityMax;
			this.starLifeMin = starLifeMin;
			this.starLifeMax = starLifeMax;
			
			this.blured = blured;
			
			this.glowBurst = new Shape();
			_randomSource = RandomUtils.RANDOM;
		}

		protected var _randomSource : Random;
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}

		public function tick (e : ImpulseEvent) : void
		{
			glowBurst.scaleX = glowBurst.scaleY = .1+Cubic.easeIn( e.time % glowBurstCycleDuration, 0, 1, glowBurstCycleDuration );
			glowBurst.alpha = Quad.easeIn( e.time % glowBurstCycleDuration, 1, -1, glowBurstCycleDuration );
			
			_time += e.bias;
			
			if( _time > starRate )	
			{
				_time -= starRate;
				
				var star : ShinyStar = AllocatorInstance.get( ShinyStar, 
															 {
															 	color1 : starColor1,															 	color2 : starColor2,
																radius : _randomSource.rangeAB(starRadiusMin,starRadiusMax),
																velocity : _randomSource.velocity(0, MathUtils.PI2, starVelocityMin, starVelocityMax ), 
																life : _randomSource.rangeAB( starLifeMin, starLifeMax ),
																x:_randomSource.balance( raysLength/1.5 ), 
																y:_randomSource.balance( raysLength/1.5 ),
																rotation:45
															 });
				target.foreground.addChild(star);
			}
		}
		
		public function init () : void
		{
			if( !target )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.warn( "A ShinyObject object must have a valid target.");
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				return;
			}
			_time = 0;
			_rays = [];
			
			drawBurst();
			
			for(var i:uint =0;i<numRays;i++)
			{
				var ray : AngularRay = AllocatorInstance.get( AngularRay ,
									{ length : raysLength + _randomSource.balance(raysLength/5),
									 angularSize : _randomSource.rangeAB( raysAngularSizeMin, raysAngularSizeMax ), 
									 angularSpeed : _randomSource.rangeAB( raysAngularSpeedMin, raysAngularSpeedMax ), 
									 rotation : _randomSource.irandom(360),
									 color : raysColor, 
									 decay : raysLength *.5 + _randomSource.balance(raysLength/5)
									 } );
				target.background.addChild(ray);
				_rays.push(ray);
			}
			if( blured )
				target.background.filters = [new BlurFilter(3, 3, 2)];
			
			target.middle.filters = [ new GlowFilter(glowColor.hexa, 1, glowSize, glowSize, 1, 2 ),
									  new GlowFilter(glowColor.hexa, 1, glowSize, glowSize, 1, 2, true ) ]; 
			start();
		}

		public function dispose () : void
		{
			target.background.removeChild(glowBurst);
			for each ( var ray : AngularRay in _rays)
			{
				target.background.removeChild(ray );
				AllocatorInstance.release( ray );
			}
			glowBurst.graphics.clear();
			
			target.background.filters = [];
			target.middle.filters = [];
			stop();
		}
		
		public function isRunning () : Boolean
		{
			return _isRunning;
		}
		
		public function start () : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}

		public function stop () : void
		{
			if( _isRunning )
			{
				Impulse.unregister( tick );
				_isRunning = false;
			}
		}
		
		protected function drawBurst () : void 
		{
			glowBurst.graphics.clear();
						
			var m : Matrix = new Matrix();
			var d : Number = raysLength * 2;
			m.createGradientBox( d, d, 0, -raysLength, -raysLength );
						
			glowBurst.graphics.clear();
			glowBurst.graphics.beginGradientFill( GradientType.RADIAL, [ glowColor.hexa, glowColor.hexa ], 
													[ 0, .5 ],
													[ 100, 255 ], 
													m );
			glowBurst.graphics.drawCircle( 0, 0, raysLength );
			glowBurst.graphics.endFill();	
					
			target.background.addChild(glowBurst);
		}
	}
}
