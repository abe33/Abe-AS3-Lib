/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseListener;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	/**
	 * @author Cédric Néhémie
	 */
	public class AngularRay extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable
	{
		public var length : uint;
		public var angularSize : Number;
		public var angularSpeed : Number;
		public var color : Color;
		public var decay : uint;
		
		protected var _isRunning : Boolean;

		public function AngularRay ( length : uint = 100,
									 angularSize : Number = .1,
									 angularSpeed : Number = .15,
									 rotation : Number = 0,
									 color : Color = null,
									 decay : uint = 70
									)
		{
			this.length = length;
			this.angularSize = angularSize;
			this.angularSpeed = angularSpeed;
			this.rotation = rotation;
			this.color = color ? color : Color.White;
			this.decay = decay;
		}

		protected function draw () : void 
		{
			var m : Matrix = new Matrix();
			m.createGradientBox( length, length, Math.PI/2, 0, 0 );
			
			var a1 : Number = angularSize / 2 * -1;
			var a2 : Number = angularSize / 2;
						
			this.graphics.beginGradientFill( GradientType.LINEAR, 
													[ color.hexa, color.hexa ],
													[ .4,0 ],
													[ decay/length * 250, 250 ], 
													m,
													SpreadMethod.PAD );
			this.graphics.moveTo(0, 0);
			
			this.graphics.lineTo( Math.sin(a1) * length, 
								  Math.cos(a1) * length );
			this.graphics.lineTo( Math.sin(a2) * length, 
								  Math.cos(a2) * length );
			this.graphics.lineTo(0, 0);
			
			this.graphics.endFill();
		}

		public function tick ( bias : Number, biasInSeconds : Number, current : Number ) : void
		{
			rotation += angularSpeed * biasInSeconds;
		}

		public function init () : void
		{
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
