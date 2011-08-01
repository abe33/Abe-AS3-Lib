package abe.com.edia.particles.strategy.actions
{
    import abe.com.motion.AbstractTween;
    import abe.com.mon.logs.Log;
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;

    public class AlphaLifeTweenActionStrategy extends AbstractLifeTweenActionStrategy
	{
        public function AlphaLifeTweenActionStrategy ( easing : Function = null,
        											   startValue : Number = 1, 
                                                       endValue : Number = 0 )
		{
			super( easing, startValue, endValue );
		}
		
		override protected function _process( particle : Particle, value : Number ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
			p.alpha = value;
        }

        override protected function getSourceArguments () : String
        {
            return [ getSource( _fEasing, "${easingFunction}" ), _nStartValue, _nEndValue ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ getReflectionSource( _fEasing, "${easingFunction}" ), _nStartValue, _nEndValue ].join(", ");
        }
		
	}
}