/**
 * @license
 */
package abe.com.edia.text.fx.hide 
{
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.AbstractCharEffect;
	import abe.com.mands.Timeout;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;

	import flash.events.Event;

	[Event(name="complete", type="flash.events.Event")]
	/**
	 * @author Cédric Néhémie
	 */
	public class AlphaFadeOut extends AbstractCharEffect 
	{
		protected var duration : Number;		
		protected var timeout : Timeout;
		protected var time : Number;

		public function AlphaFadeOut ( duration : Number = 100, timeout : Number = 0, autoStart : Boolean = true )
		{
			super( autoStart );
			this.duration = duration;
			this.timeout = new Timeout( _start, timeout );
		}
		

		override public function addChar (l : Char) : void
		{
			super.addChar( l );
			l.alpha = 1;
		}
		protected function _start () : void
		{
			super.start();
			time = 0;
		}
		override public function init () : void
		{
			if( autoStart )
				start();
		}
		override public function start () : void
		{
			timeout.execute();
		}
		public function hideAll() : void
		{
			if( timeout.isRunning() )
			{
				timeout.stop();
				timeout.reset();
				_start();
			}
			else
			{
				_start();
			}
		}

		override public function tick ( e : ImpulseEvent ) : void
		{
			time += e.bias;
			
			for each (var i : Char in chars)
			{
				i.alpha = 1 - Math.min( 1, time / duration );
			}
			
			if( time > duration )
			{
				Impulse.unregister( tick );		
				dispatchEvent( new Event( Event.COMPLETE ) );	
			}
		}
		override public function dispose () : void
		{
			Impulse.unregister( tick );
			for each (var i : Char in chars)
			{
				i.alpha = 1;
			}
			super.dispose();
		}
	}
}
