package abe.com.edia.particles.initializers
{
    import abe.com.mon.utils.RandomUtils;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;

    /**
     * @author cedric
     */
    public class RandomizePositionInitializer extends AbstractInitializer implements Randomizable
    {
        protected var _randX : Number;
        protected var _randY : Number;
        protected var _randomSource : Random;
        
        public function RandomizePositionInitializer ( randX : Number = 5, randY : Number = 5)
        {
            _randX = randX;
            _randY = randY;
            
            _randomSource = RandomUtils;
        }

        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }

        override public function initialize ( particle : Particle ) : void
        {
            particle.position.x += _randomSource.balance( _randX );
            particle.position.y += _randomSource.balance( _randY );
        }

        override protected function getSourceArguments () : String
        {
            return [_randX, _randY].join(",");
        }

        override protected function getReflectionSourceArguments () : String
        {
            return [_randX, _randY].join(",");
        }

    }
}
