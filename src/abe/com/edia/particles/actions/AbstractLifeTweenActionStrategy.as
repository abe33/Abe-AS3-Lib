package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.motion.AbstractTween;

    public class AbstractLifeTweenActionStrategy extends AbstractActionStrategy
	{
		protected var _fEasing : Function;
		protected var _nStartValue : Number;
		protected var _nEndValue : Number;

        public function AbstractLifeTweenActionStrategy ( 	easing : Function = null,
        											   		startValue : Number = 1, 
                                                       		endValue : Number = 0 )
		{
			_nStartValue = startValue;
			_nEndValue = endValue;
			_fEasing = ( easing != null ) ? easing : AbstractTween.noEasing;
		}
		
		override public function process( particle : Particle ) : void
		{
			var n : Number = _fEasing( particle.life, _nStartValue, _nEndValue - _nStartValue, particle.maxLife );
			_process( particle, n );
		}
		
		protected function _process ( particle : Particle, value : Number ) : void {}
	}
}