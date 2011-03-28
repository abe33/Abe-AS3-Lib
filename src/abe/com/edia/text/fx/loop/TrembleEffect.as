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

	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class TrembleEffect extends AbstractCharEffect 
	{
		protected var xs : Dictionary;
		protected var ys : Dictionary;
		protected var amplitude : Number;
		
		public function TrembleEffect ( amplitude : Number = 1 )
		{
			super();
			this.amplitude = amplitude;
			xs = new Dictionary( true );
			ys = new Dictionary( true );
		}
		override public function tick ( e : ImpulseEvent ) : void
		{
			var l : Number = chars.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				var char : TextField = chars[ i ] as TextField;
				
				if( char != null )
				{
					char.x = xs[ char ] + RandomUtils.balance( amplitude * 2 );
					char.y = ys[ char ] + RandomUtils.balance( amplitude * 2 );
				}
			}
		}
		override public function init () : void
		{
			for each( var char : Char in chars )
			{
				xs[ char ] = char.x;
				ys[ char ] = char.y;
						
			}
			Impulse.register( tick );
		}

		override public function dispose () : void
		{
			super.dispose();
			
			this.xs = new Dictionary( true );
			this.ys = new Dictionary( true );
			
			Impulse.unregister( tick );
		}
	}
}
