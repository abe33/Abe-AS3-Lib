package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;

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
	}
}