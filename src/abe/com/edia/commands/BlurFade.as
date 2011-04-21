/**
 * @license
 */
package abe.com.edia.commands 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.motion.easing.Linear;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.BlurFilter;

	/**
	 * @author Cédric Néhémie
	 */
	public class BlurFade extends AbstractCommand implements Command, Runnable, Suspendable, ImpulseListener
	{
		private var blurAmount : Number;
		private var target : DisplayObject;
		private var duration : Number;
		private var t : Number;
		private var _start : Number;
		private var _end : Number;
		private var easing : Function;
		
		public function BlurFade ( target : DisplayObject, 
								   blurAmount : Number = 4,
								   duration : Number = 400, 
								   start : Number = 0, 
								   end : Number = 1,
								   easing : Function = null  )
		{
			super( );
			this.target = target;
			this.duration = duration;
			this._start = start;
			this._end = end;
			this.blurAmount = blurAmount;
			this.easing = easing != null ? easing : Linear.easeNone;
		}
		public function start () : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register(tick);
			}
		}
		public function stop () : void
		{
			if( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister(tick);
			}
		}	
		override public function execute (e : Event = null) : void
		{
			this.t = 0;			
			start();
		}
		public function tick ( e : ImpulseEvent ) : void
		{
			t += e.bias;
			
			var amount : Number = easing( t, _start, _end - _start, duration );
			
			target.filters = [ new BlurFilter( blurAmount * amount, blurAmount * amount, 2 ) ];
			
			if( t >= duration )
			{
				stop();
				fireCommandEnd(); 				
			}
		}
	}
}
