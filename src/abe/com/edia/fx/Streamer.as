/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;

	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public class Streamer extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable, Randomizable
	{
		static private const FRICTION : Number = .95;
		
		public var gravity : Number;
		public var length : Number;
		public var color : Color;
		public var vel : Point;
		public var dots : Vector.<Point>;
		public var dotsVel : Vector.<Point>;
		public var dotsVelFactor : Vector.<Number>;
		public var head : Point;
		public var _isRunning : Boolean;

		public function Streamer ( color : Color = null,  
								   x : Number = 0, 
								   y : Number = 0, 
								   vel : Point = null, 
								   length : Number = 1 )
		{
			this.x = x;
			this.y = y;
			this.vel = vel;
			this.color = color;
			this.length = length;
			_randomSource = RandomUtils.RANDOM;
		}

		protected var _randomSource : Random;
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}
		
		public function init () : void
		{
			gravity = 120 + _randomSource.random(30);
			dots = new Vector.<Point>();
			dotsVel = new Vector.<Point>();
			dotsVelFactor = new Vector.<Number>();
			head = new Point();
			
			start();
		}
		
		public function dispose () : void
		{
			if( isRunning() )
				stop();
			
			this.graphics.clear();
			
			dots = null;
			dotsVel = null;
			dotsVelFactor = null;
			head = null;
		}
		public function isRunning () : Boolean { return _isRunning; }
		public function start() : void
		{
			_isRunning = true;
			Impulse.register( tick );
		}
		public function stop() : void
		{
			_isRunning = false;
			Impulse.unregister( tick );
		}
		public function tick ( e : ImpulseEvent ) : void
		{
			
			head = head.add( new Point( vel.x * e.biasInSeconds, vel.y * e.biasInSeconds ) );
			dots.push( head );
			dotsVel.push( new Point( vel.x*.5, vel.y*.5 + _randomSource.random() * 5 ) );
			dotsVelFactor.push( .9 + _randomSource.random()*.1 );
			vel.y += gravity * e.biasInSeconds;
			if( dots.length > length )
			{
				dots.shift();
			}
			
			var n : Number = 0;
			var l : Number = dots.length;
			
			var miny : Number;
			
			miny = dots[0].y;
			
			this.graphics.clear();
			this.graphics.lineStyle( 2, color.hexa );
			for( n = 0; n < l; n++ )
			{
				var pt : Point = dots[n];
				dotsVel[n].y += gravity * e.biasInSeconds;
				dotsVel[n].y *= FRICTION;
				dotsVel[n].x *= FRICTION;
				
				pt.y += dotsVel[n].y * e.biasInSeconds;
				pt.x += dotsVel[n].x * e.biasInSeconds;
				
				miny = Math.min( pt.y, miny );
				
				if( n == 0 )
					this.graphics.moveTo( pt.x, pt.y );
				else
					this.graphics.lineTo( pt.x, pt.y );	
			}
			
			if( miny > StageUtils.stage.stageHeight )
			{
				stop();
				this.parent.removeChild( this );
				AllocatorInstance.release( this );
			}
		}
	}
}
