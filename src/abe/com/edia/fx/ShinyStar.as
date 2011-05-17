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
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;

	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public class ShinyStar extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable
	{
		protected var _isRunning : Boolean;
		
		public var color1 : Color;		public var color2 : Color;
		public var radius : Number;
		public var velocity : Point;
		public var life : Number;
		public var t : Number;

		public function ShinyStar ( 
									color1 : Color = null,									color2 : Color = null,
									radius : Number = 15,
									velocity : Point = null,
									life : Number = 500 )
		{
			this.color1 = color1;			this.color2 = color2;
			this.radius = radius;
			this.velocity = velocity;
			this.life = life;
			this.blendMode = BlendMode.ADD;
		}

		protected function draw () : void 
		{
			this.graphics.beginFill(color2.hexa, .5 );			this.graphics.drawCircle(0, 0, radius * .6 );
			this.graphics.drawCircle(0, 0, radius * .53 );			this.graphics.endFill();			
			this.graphics.beginFill(color2.hexa, .5 );
			this.graphics.drawEllipse(-1, -radius, 2, radius*2);
			this.graphics.endFill();
						this.graphics.beginFill(color2.hexa, .5 );
			this.graphics.drawEllipse(-radius, -1, radius*2, 2);
			this.graphics.endFill();
			
			var m : Matrix = new Matrix();
			var d : Number = radius / 3 * 2;
			m.createGradientBox( d, d, 0, -radius / 3, -radius / 3 );
						
			this.graphics.beginGradientFill( GradientType.RADIAL, 
													[ color1.hexa, color1.hexa ],
													[ .8, 0 ],
													[ 0, 200 ], 
													m );
			this.graphics.drawCircle( 0, 0, radius / 3 );
			this.graphics.endFill();
		}

		public function tick (e : ImpulseEvent) : void
		{
			x += velocity.x * e.biasInSeconds;
			y += velocity.y * e.biasInSeconds;
			t += e.bias;
			
			alpha = 1 - (t/life);
			scaleX = scaleY = 1 + (t/life);
			
			if( t > life )
			{
				if( parent )
				{
					if( parent.contains( this ) )
						parent.removeChild( this );
				}
				stop();
				this.graphics.clear();
				AllocatorInstance.release(this);
			}
		}

		public function init () : void
		{
			t = 0;
			draw();
			start();
		}
		
		public function dispose () : void
		{
			this.graphics.clear();
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
