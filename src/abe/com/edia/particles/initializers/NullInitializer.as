package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;


    /**
     * @author cedric
     */
    public class NullInitializer implements Initializer
    {
        public function initialize ( particle : Particle ) : void {}
        
        public function get system () : ParticleSystem {
            return null;
        }

        public function set system ( s : ParticleSystem ) : void {
        }
    }
}
