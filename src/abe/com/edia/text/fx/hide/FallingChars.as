/**
 * @license
 */
package abe.com.edia.text.fx.hide 
{
    import abe.com.edia.text.core.Char;
    import abe.com.edia.text.fx.show.DefaultTimedDisplayEffect;
    import abe.com.motion.Impulse;

    import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class FallingChars extends DefaultTimedDisplayEffect 
	{
		protected var activeChars : Vector.<Char>;
		protected var gravity : Number;
		protected var xs : Dictionary;
		protected var ys : Dictionary;		protected var speedY : Dictionary;
		
		public function FallingChars ( delay : Number = 50, gravity : Number = 50, start : Number = 0, autoStart : Boolean = true)
		{
			super( delay, start, autoStart );
			this.gravity = gravity;
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
				char.alpha = 1;
				char.visible = true;
			}
		}

		override public function addChar (l : Char) : void
		{
			super.addChar( l );
			l.visible = true;
		}

		override public function dispose () : void
		{
			stop();
			reset();
			activeChars = null;
			super.dispose();
		}

		override public function reset () : void
		{
			super.reset();
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				char.x = xs[ char ];
				char.y = ys[ char ];
				char.alpha = 1;
				char.visible = true;
			}
		}
		override public function start () : void
		{
			super.start();
			Impulse.register( tick );
		}
		override public function stop () : void
		{
			super.stop();
			Impulse.unregister( tick );
		}
		override protected function processChar () : Char
		{
			var char : Char = iterator.next() as Char;
			
			if( char != null )
			{
				activeChars.push( char );
				speedY[ char ] = 0;
			}
			
			if( !iterator.hasNext() )
			{
				interval.stop();
				fireComplete();
			}
			
			return char;
		}
		override public function showAll() : void
		{
			
		}
		override public function tick ( bias:Number, biasInSecond : Number, time : Number ) : void
		{
			if( activeChars.length > 0 )
			{
				for each( var char : Char in activeChars )
				{
					speedY[ char ] += biasInSecond * gravity;
					char.y += speedY[ char ];
					char.alpha -= biasInSecond;
					
					if( char.alpha <= 0 )
						activeChars.splice( activeChars.indexOf( char ), 1 );
				}
				if( activeChars.length == 0 )
				{
					stop();
					fireComplete();
				}
			}
		}
	}
}
