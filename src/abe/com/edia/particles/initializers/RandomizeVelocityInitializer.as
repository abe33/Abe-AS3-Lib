package abe.com.edia.particles.initializers
{
    import abe.com.mon.utils.PointUtils;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.RandomUtils;

    /**
     * @author cedric
     */
    public class RandomizeVelocityInitializer extends AbstractInitializer
    {
        protected var _randAngle : Number;
        protected var _randLength : Number;
        public function RandomizeVelocityInitializer ( randAngle : Number = 1, randLength : Number = 10 )
        {
            _randAngle = randAngle;
            _randLength = randLength;
        }
        override public function initialize ( particle : Particle ) : void
        {
            var l : Number = particle.velocity.length;
            l += RandomUtils.balance(_randLength);
            
            particle.velocity = PointUtils.rotate( particle.velocity, RandomUtils.balance(_randAngle));
            particle.velocity.normalize(l);
        }
        override protected function getSourceArguments () : String
        {
            return [_randAngle, _randLength].join(",");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [_randAngle, _randLength].join(",");
        }
    }
}
