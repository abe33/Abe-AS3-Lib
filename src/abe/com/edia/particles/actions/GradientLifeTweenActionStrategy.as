package abe.com.edia.particles.actions
{
	import abe.com.edia.particles.core.DisplayObjectParticle;
	import abe.com.edia.particles.core.Particle;
	import abe.com.mon.colors.Gradient;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="gradient,easing,startValue,endValue")]
    public class GradientLifeTweenActionStrategy extends AbstractLifeTweenActionStrategy
    {
        public var gradient : Gradient;
        public function GradientLifeTweenActionStrategy ( gradient : Gradient = null, 
        												  easing : Function = null, 
                                                          startValue : Number = 1, 
                                                          endValue : Number = 0 )
        {
            super ( easing, startValue, endValue );
            this.gradient = gradient;
        }

        override protected function _process ( particle : Particle, value : Number ) : void
        {
            var g : Gradient = particle.hasParasite( "lifeGradient" ) ? particle.getParasite("lifeGradient") : gradient;
            super._process ( particle, value );
            if( g )
	            ( particle as DisplayObjectParticle ).displayObject.transform.colorTransform = g.getColor(1-value).toColorTransform(1);
        }
    }
}
