package abe.com.edia.commands
{
    import abe.com.mands.AbstractCommand;
    import abe.com.mon.colors.Gradient;
    import abe.com.mon.core.Suspendable;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.motion.easing.Linear;

    import flash.display.DisplayObject;

    /**
     * @author cedric
     */
    public class GradientTween extends AbstractCommand implements Suspendable, ImpulseListener
    {
        public var target : DisplayObject;
        public var gradient : Gradient;
        public var duration : Number;
        public var loop : Boolean;
        public var startPos : Number;
        public var endPos : Number;
        public var easing : Function;
        private var t : int;
        public var blend : Number;
        
        public function GradientTween ( target : DisplayObject, 
        								gradient : Gradient, 
                                        duration : Number = 1000, 
                                        loop : Boolean = false, 
									 	easing : Function = null,
                                        blend : Number = .5,
                                        start : Number = 0, 
                                        end : Number = 1
                                         )
        {
            super ();
            this.target = target;
            this.gradient = gradient;
            this.duration = duration;
            this.loop = loop;
            this.easing = easing != null ? easing : Linear.easeNone;
            this.startPos = start;
            this.endPos = end;
            this.blend = blend;
        }
		
        override public function execute ( ...args ) : void
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
		public function tick ( bias : Number, biasInSeconds : Number, current : Number ) : void
		{
			t += bias;
			var end : Boolean;
			if( t >= duration )
			{
                if( !loop )
                {
					t = duration;	
					end = true;		
                }
                else
                	t %= duration;
			}
			var pos : Number = easing( t, startPos, endPos - startPos, duration );
			
			target.transform.colorTransform = gradient.getColor( pos ).toColorTransform( blend );
			
			if( end )
			{
				stop();
				_commandEnded.dispatch( this );		
			}
		}
    }
}
