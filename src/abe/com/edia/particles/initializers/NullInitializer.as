package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.patibility.lang._$;
    import flash.utils.getQualifiedClassName;


    /**
     * @author cedric
     */
    public class NullInitializer implements Initializer
    {
        public function initialize ( particle : Particle ) : void {}
        public function toSource () : String
        {
            return _$ ( "new $0()", getQualifiedClassName ( this ).replace("::",".") );
        }
        public function toReflectionSource () : String { 
            return _$ ( "new $0()", getQualifiedClassName ( this ) ); 
        }

        public function get system () : ParticleSystem {
            return null;
        }

        public function set system ( s : ParticleSystem ) : void {
        }
    }
}
