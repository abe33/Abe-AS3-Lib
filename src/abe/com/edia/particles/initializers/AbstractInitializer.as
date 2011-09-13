package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;


    /**
     * @author cedric
     */
    public class AbstractInitializer implements Initializer
    {
        protected var _system : ParticleSystem;
        
        public function initialize ( particle : Particle ) : void {}

		public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void { _system = s; }
    }
}
