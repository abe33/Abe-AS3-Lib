package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import flash.geom.ColorTransform;

    /**
     * @author cedric
     */
    public class ColorTransformLifeTweenActionStrategy extends AbstractLifeTweenActionStrategy
    {
        private var _transform : ColorTransform;
        public function ColorTransformLifeTweenActionStrategy ( transform : ColorTransform, 
        														easing : Function = null, 
                                                                startValue : Number = 1, 
                                                                endValue : Number = 0 )
        {
            super ( easing, startValue, endValue );
            _transform = transform;
        }

        override protected function _process ( particle : Particle, value : Number ) : void
        {
            var ivalue : Number = 1 - value;
            var t : ColorTransform = new ColorTransform(
            	1 * value + _transform.redMultiplier * ivalue,
            	1 * value + _transform.greenMultiplier * ivalue,
            	1 * value + _transform.blueMultiplier * ivalue,
            	1
            );
            (particle as DisplayObjectParticle ).displayObject.transform.colorTransform = t;
            super._process ( particle, value );
        }
    }
}
