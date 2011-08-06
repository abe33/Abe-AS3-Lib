package abe.com.edia.particles.initializers
{
    import abe.com.mon.utils.RandomUtils;
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.initializers.AbstractInitializer;

    /**
     * @author cedric
     */
    public class RandomizePositionInitializer extends AbstractInitializer
    {
        protected var _randX : Number;
        protected var _randY : Number;
        public function RandomizePositionInitializer ( randX : Number = 5, randY : Number = 5)
        {
            _randX = randX;
            _randY = randY;
        }

        override public function initialize ( particle : Particle ) : void
        {
            particle.position.x += RandomUtils.balance( _randX );
            particle.position.y += RandomUtils.balance( _randY );
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
