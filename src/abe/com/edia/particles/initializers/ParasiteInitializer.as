 package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.initializers.AbstractInitializer;

    /**
     * @author cedric
     */
    public class ParasiteInitializer extends AbstractInitializer
    {
        private var _key : *;
        private var _data : *;
        public function ParasiteInitializer ( key  : *, data : * )
        {
            _key = key;
            _data = data;
        }

        override public function initialize ( particle : Particle ) : void
        {
            particle.setParasite(_key, _data);
        }
    }
}
