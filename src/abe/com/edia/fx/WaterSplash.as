package abe.com.edia.fx 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.Gradient;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.motion.easing.Linear;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.geom.Matrix;

	/**
	 * @author Cédric Néhémie
	 */
	public class WaterSplash extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable 
	{
		protected var _isRunning : Boolean;
		
		public var size : Number;
		public var dist : Number;
		public var life : Number;
		public var shadow : Boolean;
		public var easing : Function;
		protected var t : Number;
		
		public var gradient : Gradient;

		public function WaterSplash ( x : Number = 0, 
									  y : Number = 0, 
									  gradient : Gradient = null,
									  size : Number = 10, 
									  dist : Number = 50,
									  life : Number = 1000, 
									  shadow : Boolean = true,
									  easing : Function = null )
		{
			this.x = x;
			this.y = y;
			this.gradient = gradient ? gradient : new Gradient( [ Color.CadetBlue, Color.CadetBlue ], [ 0,1 ] );
			this.size = size;
			this.dist = dist;
			this.life = life;	
			this.shadow = shadow;
			this.easing = easing != null ? easing : Linear.easeNone;
			start( );
			
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
				AllocatorInstance.release( this, WaterSplash );
			}
		}
		public function draw () : void
		{
			this.graphics.clear();
			
			var l : Number = easing( t, 1, -1, life );
			var ll : Number;
			if( l > 0.5 )
			{				
				ll = (1-l) * 2;
				var y : Number = Math.abs( Math.sin( ll * Math.PI ) ) * dist;
				
				var m : Matrix = new Matrix();
				m.createGradientBox( size*2, y*2, Math.PI / 2, -size*2, Math.min( -y*1.5, -size ) );
				
				this.graphics.clear();
				this.graphics.beginGradientFill( GradientType.LINEAR, 
											[ Color.White.hexa, Color.CadetBlue.hexa ],
											[ 1, .7 ],
											//[ Math.floor(ll*50), 1 + Math.floor(ll*254) ], 
											[ Math.max( y/dist , .1 ) *100, 255 ], 
											m, 
											SpreadMethod.PAD );
				//this.graphics.beginFill( Color.White.hexa );
				this.graphics.moveTo( -size, 0 );
				this.graphics.curveTo(-size, -y, 0, -y );
				this.graphics.curveTo(size, -y, size, 0 );
				this.graphics.curveTo(size, size/2, 0, size/2 );
				this.graphics.curveTo( -size, size/2, -size, 0 );
				this.graphics.endFill();
			}
			else
			{
				ll = ( 0.5 - l ) * 2;
				var lll : Number = 1 + ll;
				this.graphics.beginFill( gradient.getColor( ll ).hexa, ( 1 - ll ) / 2 );
				this.graphics.drawEllipse( -size*lll, -size/2*lll, size*2*lll, size*lll );
				this.graphics.endFill();
			}
		}
	}
}