package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="randX,randY,randomSource")]
    public class RandomizePositionInitializer extends AbstractInitializer implements Randomizable
    {
        protected var _randX : Number;
        protected var _randY : Number;
        protected var _randomSource : Random;
        
        public function RandomizePositionInitializer ( randX : Number = 5, randY : Number = 5, random : Random = null)
        {
            _randX = randX;
            _randY = randY;
            
            _randomSource = random ? random : RandomUtils;
        }

        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }

        override public function initialize ( particle : Particle ) : void
        {
            particle.position.x += _randomSource.balance( _randX );
            particle.position.y += _randomSource.balance ( _randY );
        }

        public function get randX () : Number {
            return _randX;
        }

        public function set randX ( randX : Number ) : void {
            _randX = randX;
        }

        public function get randY () : Number {
            return _randY;
        }

        public function set randY ( randY : Number ) : void {
            _randY = randY;
        }
    }
}
