/**
 * @license
 */
package abe.com.edia.text.fx.loop 
{
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.AbstractCharEffect;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	/**
	 * @author Cédric Néhémie
	 */
	public class TrembleEffect extends AbstractCharEffect 
	{
		protected var amplitude : Number;
		
		public function TrembleEffect ( amplitude : Number = 1 )
		{
			super();
			this.amplitude = amplitude;
		}
		override public function tick ( e : ImpulseEvent ) : void
		{
			var l : Number = chars.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				
				if( char.charContent )
				{
					char.charContent.x = RandomUtils.balance( amplitude * 2 );
					char.charContent.y = RandomUtils.balance( amplitude * 2 );
				}
			}
		}

		override public function dispose () : void
		{
			super.dispose();
			
			var l : Number = chars.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				if( char.charContent )
					char.charContent.x = char.charContent.y = 0;
			}
			
			Impulse.unregister( tick );
		}
	}
}
