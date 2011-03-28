/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;

	import flash.display.Shape;
	import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	public class Inspire extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable, Randomizable
	{
		protected var _isRunning : Boolean;
		protected var halfLife : Number;
		protected var step : Number;
		protected var rays : Vector.<Ray>;
		protected var icolor : uint;
		protected var time : Number;
		
		public var color : Color;
		public var radius : Number;
		public var numRays : Number;
		public var speed : Number;
		public var duration : Number;
		public var raysSize : Number;
		public var timed : Boolean;

		public function Inspire ( color : Color = null, 
								  timed : Boolean = true,
								  numRays : Number = 12, 
								  raysSize : Number = 1,
								  duration : Number = 2000, 
								  radius : Number = 40, 
								  speed : Number = 4 ) 
		{
			this.radius = radius;
			this.speed = speed;
			this.numRays = numRays;
			this.raysSize = raysSize;
			this.timed = timed;
			this.duration = duration;
			this.color = color ? color : Color.White;
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
			this.graphics.clear();
			//var l : Number = 1 - ( Math.abs( time - halfLife ) / halfLife );
			var l : Number = time / duration;
			
			if( timed )
			{
				if( time < halfLife )
				{
					if( duration - time > rays.length * step )
						rays.push( new Ray( _randomSource.random() * Math.PI * 2, _randomSource.random(), .7 + _randomSource.random() * .6 ) );
				}
				else
				{
					if( duration - time < rays.length * step )
						rays.pop();
				}				
			}
			
			for each( var r : Ray in rays )
			{
				var x : Number = Math.sin( r.angle ) * this.radius * r.ratio;
				var y : Number = Math.cos( r.angle ) * this.radius * r.ratio;
				this.graphics.lineStyle( raysSize, icolor, 1.3-r.time );
				this.graphics.moveTo( x * r.time, 
									  y * r.time );
											  
				this.graphics.lineTo( x * Math.min(1, r.time + 0.5 ), 
									  y * Math.min(1, r.time + 0.5 ) );
				
				r.time -= e.biasInSeconds * speed;
				if( r.time < 0 )
				{
					r.angle = _randomSource.random() * Math.PI * 2;
					r.ratio = .7 + _randomSource.random() * .6;
					r.time += 1;
				}
			}
			time += e.bias;
			
			if( timed && time >= duration && rays.length == 0 )
			{
				if( parent )
				{
					if( parent.contains( this ) )
						parent.removeChild( this );
				}
				stop();
				dispatchEvent( new Event( Event.REMOVED ) );
				AllocatorInstance.release( this );
			}
		}
		
		public function init () : void
		{
			time = 0;
			rays = new Vector.<Ray>();
			icolor = color.hexa;
			
			if( timed )
			{
				this.halfLife = duration / 2;
				this.step = halfLife / numRays;
			}
			else
			{
				this.halfLife = duration / 2;
				this.step = duration / 2 / numRays;
				for( var i : uint = 0; i<numRays;i++)
				{
					rays.push(  new Ray( _randomSource.random() * Math.PI * 2, _randomSource.random(), .7 + _randomSource.random() * .6 ) );
				}
			}
			
			start();
		}
		
		public function dispose () : void
		{
			this.graphics.clear();
			rays = null;
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
	}
}
internal class Ray 
{
	public var angle : Number; 
	public var time : Number;
	public var ratio : Number;
	
	public function Ray ( angle : Number = 0, time : Number = 0, ratio : Number = 1 )
	{
		this.angle = angle;
		this.time = time;
		this.ratio = ratio;
	}
}