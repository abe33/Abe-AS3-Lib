/**
 * @license
 */
package abe.com.edia.text.fx.loop 
{
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.AbstractCharEffect;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	/**
	 * @author Cédric Néhémie
	 */
	public class CircularWaveEffect extends AbstractCharEffect
	{
		protected var amplitude : Number;
		protected var angle : Number;
		protected var speed : Number;
		protected var frequency : Number;

		public function CircularWaveEffect( amplitude : Number = 10, angleSpeed : Number = Math.PI, frequency : Number = 0.05 )
		{
			super();
			this.angle = 0;
			this.amplitude = amplitude;
			this.speed = angleSpeed;
			this.frequency = frequency;
			
		}
		override public function init () :void
		{
			super.init();
			
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				if( char.charContent )
				{
					char.charContent.x = Math.sin( angle + frequency * char.x ) * amplitude;
					char.charContent.y = Math.cos( angle + frequency * char.x ) * amplitude;
				}
			}
			
			Impulse.register( tick );
		}

		override public function dispose () : void
		{
			super.dispose();
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				if( char.charContent )
				{
					char.charContent.x = 0;
					char.charContent.y = 0;
				}
			}
			Impulse.unregister( tick );
		}

		override public function tick ( e : ImpulseEvent ) : void
		{
			var l : Number = chars.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				
				if( char.charContent )
				{
					char.charContent.x = Math.sin( angle + frequency * xs[ char ] ) * amplitude;
					char.charContent.y = Math.cos( angle + frequency * xs[ char ] ) * amplitude;
				}
			}
			angle += speed * e.biasInSeconds;	
		}
	}
}
