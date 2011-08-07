/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
    import abe.com.edia.text.core.Char;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.core.Suspendable;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;

    import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class FallAndBounce extends DefaultTimedDisplayEffect implements Runnable, Suspendable, ImpulseListener
	{
		protected var activeChars : Vector.<Char>;
		protected var gravity : Number;
		protected var xs : Dictionary;
		protected var ys : Dictionary;
		protected var speedY : Dictionary;
		protected var height : Number;
		
		public function FallAndBounce (delay : Number = 50, height : Number = 200, gravity : Number = 50, start : Number = 0, autoStart : Boolean = true)
		{
			super( delay, start, autoStart );
			this.gravity = gravity;
			this.height = height;
		}

		override public function init () : void
		{
			activeChars = new Vector.<Char>();
			xs = new Dictionary( true );
			ys = new Dictionary( true );
			speedY = new Dictionary( true );
			super.init();
			
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				xs[ char ] = char.x;
				ys[ char ] = char.y;
				speedY[char] = 0;
				char.visible = false;
			}
		}
		override public function dispose () : void
		{
			stop();
			reset();
			activeChars = null;
			super.dispose();
		}

		override protected function charProcessingComplete () : void
		{
			interval.stop();
		}

		override protected function showChar (char : Char) : void
		{
			super.showChar( char );
			/*
			if( char.y != ys[char] )
				ys[char] = char.y;
			*/
			char.y = ys[char] - height;
			activeChars.push( char );
			
			if( activeChars.length == 1 )
				Impulse.register( tick );
		}

		override public function reset () : void
		{
			super.reset();
			if( chars )
			{
				var l : Number = chars.length;
				for(var i : Number = 0; i < l; i++ )
				{
					var char : Char = chars[ i ];
					if( char )
					{
						char.x = xs[ char ];
						char.y = ys[ char ];
						char.visible = false;
					}
				}
			}
		}
		override public function stop () : void
		{
			super.stop();
			Impulse.unregister( tick );
		}
		override public function tick (bias:Number, biasInSecond : Number, time : Number) : void
		{
			if( activeChars.length > 0 )
			{
				for each( var char : Char in activeChars )
				{
					speedY[ char ] += biasInSecond * gravity;					speedY[ char ] *= 0.9;
					char.y += speedY[ char ];
					if( char.y >= ys[char] )
					{
						speedY[ char ] *= -0.9;
						char.y = ys[char];
						
						if( Math.abs(speedY[ char ]) > 0.1 )
							bounceOccured( char );
					}
					
					if( Math.abs(speedY[ char ]) <= 0.1 &&
						Math.abs(char.y - ys[char]) <= 2 )
					{
						activeChars.splice( activeChars.indexOf( char ), 1 );
						char.y = ys[char];
					}
				}
				if( activeChars.length == 0 )
				{
					stop();
					fireComplete();
				}
			}
		}
		protected function bounceOccured (char : Char) : void {}
	}
}
