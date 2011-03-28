/**
 * @license
 */
package abe.com.edia.commands 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.colors.Color;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.motion.easing.Linear;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.ColorTransform;

	/**
	 * @author Cédric Néhémie
	 */
	public class ColorTween extends AbstractCommand implements Suspendable, Command, Runnable, ImpulseListener
	{
		private var target : DisplayObject;
		private var color : Color;
		private var duration : Number;
		private var t : Number;
		private var _start : Number;
		private var _end : Number;
		private var easing : Function;

		public function ColorTween ( target : DisplayObject, 
									 color : Color, 
									 duration : Number = 400, 
									 start : Number = 0, 
									 end : Number = 1, 
									 easing : Function = null )
		{
			this.target = target;
			this.color = color;
			this.duration = duration;
			this._start = start;
			this._end = end;
			this.easing = easing != null ? easing : Linear.easeNone;
		}

		override public function execute (e : Event = null) : void
		{
			this.t = 0;
			start();
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
		public function tick ( e : ImpulseEvent ) : void
		{
			t += e.bias;
			var end : Boolean;
			if( t >= duration )
			{
				t = duration;	
				end = true;		
			}
			var amount : Number;
			
			amount = easing( t, _start, _end - _start, duration );
				
			var mult : Number = 1 - amount;
			
			target.transform.colorTransform = new ColorTransform ( mult, mult, mult, 1, 
																   color.red * amount, 
																   color.green * amount, 
																   color.blue * amount,
																   0 );
			
			if( end )
			{
				stop();
				fireCommandEnd();				
			}
		}
	}
}
