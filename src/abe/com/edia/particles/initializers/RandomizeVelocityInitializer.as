package abe.com.edia.particles.initializers
{
    import abe.com.mon.utils.RandomUtils;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.PointUtils;

    /**
     * @author cedric
     */
    public class RandomizeVelocityInitializer extends AbstractInitializer implements Randomizable
    {
        protected var _randAngle : Number;
        protected var _randLength : Number;
        protected var _randomSource : Random;
        
        public function RandomizeVelocityInitializer ( randAngle : Number = 1, randLength : Number = 10 )
        {
            _randAngle = randAngle;
            _randLength = randLength;
            
            _randomSource = RandomUtils;
        }
        
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
        override public function initialize ( particle : Particle ) : void
        {
            var l : Number = particle.velocity.length;
            l += _randomSource.balance(_randLength);
            
            particle.velocity = PointUtils.rotate( particle.velocity, _randomSource.balance(_randAngle));
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
