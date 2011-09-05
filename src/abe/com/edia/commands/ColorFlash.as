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
    import flash.geom.ColorTransform;
	/**
	 * @author Cédric Néhémie
	 */
	public class ColorFlash extends AbstractCommand implements Suspendable, Command, Runnable
	{
		private var t : Number;
		
        public var duration : Number;
		public var easing : Function;
		public var target : DisplayObject;
		public var color : Color;
        public var looping : Boolean;
        public var add : Boolean;
        public var colorRatio : Number;

		public function ColorFlash ( target : DisplayObject, 
        							 color : Color, 
                                     add : Boolean = false, 
                                     duration : Number = 400, 
                                     easing : Function = null, 
                                     looping : Boolean = false,
                                     colorRatio : Number = 1 )
		{
			this.target = target;
			this.color = color;
            this.add = add;
			this.duration = duration;
			this.easing = easing != null ? easing : Linear.easeNone;
			this.looping = looping;
            this.colorRatio = colorRatio;
		}
		override public function execute ( ... args ) : void
		{
			this.t = 0;
			start();
		}
		public function reset () : void
		{
			target.transform.colorTransform = new ColorTransform ();
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
			
			var a : Number = 1 - Math.abs( 1 - ( t / duration ) * 2 );
			var amount : Number = easing( a, 0, 1, 1 ) * colorRatio;
			var mult : Number = 1 - amount;
			
            if( add )
            	target.transform.colorTransform = new ColorTransform ( 1, 1, 1, 1, 
																	   color.red * amount, 
																	   color.green * amount, 
																	   color.blue * amount,
																	   0 );
            else
				target.transform.colorTransform = new ColorTransform ( mult, mult, mult, 1, 
																	   color.red * amount, 
																	   color.green * amount, 
																	   color.blue * amount,
																	   0 );
			
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
