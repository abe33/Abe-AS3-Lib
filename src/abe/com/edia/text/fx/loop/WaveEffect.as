/**
 * @license
 */
package abe.com.edia.text.fx.loop 
{
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.AbstractCharEffect;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;

	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class WaveEffect extends AbstractCharEffect
	{
		protected var amplitude : Number;
		protected var angle : Number;
		protected var speed : Number;
		protected var frequency : Number;

		protected var ys : Dictionary;
		
		public function WaveEffect( amplitude : Number = 10, angleSpeed : Number = Math.PI, frequency : Number = 0.05 )
		{
			super();
			this.angle = 0;
			this.amplitude = amplitude;
			this.speed = angleSpeed;
			this.frequency = frequency;
			
			this.ys = new Dictionary( true );
			
		}
		override public function init () :void
		{
			super.init();
			
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				ys[ char ] = char.y;
				
				char.y += char.y + Math.cos( angle + frequency * char.x ) * amplitude;
			}
			
			Impulse.register( tick );
		}

		override public function dispose () : void
		{
			super.dispose();
			
			this.ys = new Dictionary( true );
			
			Impulse.unregister( tick );
		}

		override public function tick ( e : ImpulseEvent ) : void
		{
			var l : Number = chars.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				
				if( char != null )
				{
					
					char.y = ys[ char ] + Math.cos( angle + frequency * char.x ) * amplitude;
				}
			}
			
			angle += speed * e.biasInSeconds;	
		}
	}
}
