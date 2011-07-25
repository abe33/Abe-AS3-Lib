/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseListener;

	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public class Confetti extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable
	{
		static private const GRAVITY : Number = 150;
		static private const FRICTION : Number = .95;
		
		public var color : Color;
		public var vel : Point;
		public var velrot : Number;
		
		protected var _isRunning : Boolean;

		public function Confetti ( 	color : Color = null, 
								 	x : Number = 0, 
								 	y : Number = 0, 
								 	vel : Point = null, 
								 	velrot : Number = 0 )
		{
			this.x = x;
			this.y = y;
			this.vel = vel;
			this.color = color;
			this.velrot = velrot;
		}
		public function init () : void
		{
			this.graphics.beginFill( color.hexa );
			this.graphics.drawRect( 0, 0, 10, 5);
			this.graphics.endFill();
			
			start();
		}
		
		public function dispose () : void
		{
			if( isRunning() )
				stop();
			this.graphics.clear();
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
		public function tick ( bias : Number, biasInSeconds : Number, current : Number ) : void
		{
			y += vel.y * biasInSeconds;
			x += vel.x * biasInSeconds;
			
			vel.x *= FRICTION;
			vel.y += GRAVITY * biasInSeconds;
			vel.y *= FRICTION;
			
			rotation += velrot;
			scaleX = Math.sin( rotation / 30 );
			scaleY = Math.cos( rotation / 30 );
			
			if( y > StageUtils.stage.stageHeight )
			{
				stop();
				this.parent.removeChild( this );
				AllocatorInstance.release(this);
			}
		}
	}
}
