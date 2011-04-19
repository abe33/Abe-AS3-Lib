/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.logs.Log;
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.motion.easing.Linear;

	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class Dust extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable
	{
		public var size : Number;
		public var dist : Number;
		public var life : Number;
		public var initlife : Number;
		public var shadow : Boolean;
		public var easing : Function;
		protected var t : Number;
		
		protected var _isRunning : Boolean;

		public function Dust ( x : Number = 0, 
							   y : Number = 0, 
							   size : Number = 10, 
							   dist : Number = 50, 
							   life : Number = 1000, 
							   shadow : Boolean = true,
							   easing : Function = null )
		{
			this.x = x;
			this.y = y;
			this.size = size;
			this.dist = dist;
			this.life = life;	
			this.initlife = life;
			this.shadow = shadow;
			this.easing = easing != null ? easing : Linear.easeNone;
		}
		
		public function init () : void
		{
			t = 0;
			start();
		}
		
		public function dispose () : void
		{
			stop();
			this.graphics.clear();
		}
		
		public function isRunning () : Boolean { return _isRunning; }
		public function start() : void
		{
			if(!_isRunning)
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}
		public function stop() : void
		{
			if(_isRunning)
			{
				_isRunning = false;
				Impulse.unregister( tick );
			}
		}
		public function draw () : void
		{
			this.graphics.clear();
			
			var r : Number = 1 - Math.abs( ( easing( t, 0, 1, life ) - 0.65 ) * 1.35 );
			//var r : Number = easing( life, 0, 1, initlife );
			var s : Number = size * r;
			var d : Number = ( dist ) * (t / life);
			
			if( shadow )
			{
				// draw ground shadow
				this.graphics.beginFill( Color.SaddleBrown.hexa, .4 );
				this.graphics.drawEllipse( -s, 0, s * 2, s );
				this.graphics.endFill();
			}
			// draw cloud shadow
			this.graphics.beginFill( Color.Tan.hexa );
			//this.graphics.drawCircle( 0, -d, s );
			this.graphics.drawEllipse( -s, -( d + 2 )-s, s*2, s*1.5 );
			this.graphics.endFill();
			// draw cloud 
			this.graphics.beginFill( Color.Ivory.hexa );
			this.graphics.drawEllipse( -s*0.9, -( d + 2 )-s, s*1.8,  s*1 );
			this.graphics.endFill();
		}

		public function tick ( e : ImpulseEvent ) : void
		{
			t += e.bias;
			
			this.x -= e.biasInSeconds;
			this.draw();
			
			if( t > life )
			{ 
				if( parent )
				{
					if( parent.contains( this ) )
						parent.removeChild( this );
				}
				stop();
				this.graphics.clear();
				dispatchEvent( new Event( Event.REMOVED ) );
				AllocatorInstance.release( this );
			}
		}
	}
}
