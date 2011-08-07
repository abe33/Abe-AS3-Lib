/**
 * @license
 */
package abe.com.edia.commands 
{
    import abe.com.mands.AbstractCommand;
    import abe.com.mands.Command;
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.core.Suspendable;
    import abe.com.motion.Impulse;
    import abe.com.motion.easing.Linear;

    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
	/**
	 * @author Cédric Néhémie
     */
    public class GlowFlash extends AbstractCommand implements Suspendable, Command, Runnable
	{
		private var target : DisplayObject;
		private var color : Color;
		private var duration : Number;
		private var t : Number;
		private var easing : Function;
        private var looping : Boolean;
        private var maxGlowSize : Number;

        public function GlowFlash ( target : DisplayObject, 
        							color : Color, 
                                    maxGlowSize : Number = 6,
                                    duration : Number = 400, 
                                    easing : Function = null, 
                                    looping : Boolean = false )
		{
			this.target = target;
			this.color = color;
			this.duration = duration;
			this.easing = easing != null ? easing : Linear.easeNone;
			this.looping = looping;
            this.maxGlowSize = maxGlowSize;
		}
		override public function execute ( ... args ) : void
		{
			this.t = 0;
			start();
		}
		public function reset () : void
		{
			target.filters = [];
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
		public function tick ( bias : Number, biasInSeconds : Number, current : Number ) : void
		{
			t += bias;
			
			var a : Number = Math.abs( 1 - ( t / duration ) * 2 );
			var amount : Number = easing( a, 0, 1, 1 );
			var mult : Number = 1 - amount;
			
			target.filters = [ new GlowFilter(color.hexa, color.alpha/255, maxGlowSize*mult, maxGlowSize*mult, 1, 2 ) ];
			
			if( t >= duration)
			{
				if( looping )
				{
					t -= duration;
				}
				else
				{
					reset();
					stop();				
					_commandEnded.dispatch( this );				
				}
			}
		}
	}
}
