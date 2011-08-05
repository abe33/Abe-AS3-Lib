package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.patibility.lang._$;
    import flash.utils.getQualifiedClassName;


    /**
     * @author cedric
     */
    public class AbstractInitializer implements Initializer
    {
        protected var _system : ParticleSystem;
        
        public function initialize ( particle : Particle ) : void {}

		public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void { _system = s; }

        public function toSource () : String
        {
            return _$ ( "new $0($1)", getQualifiedClassName ( this ).replace("::","."), getSourceArguments() );
        }
        public function toReflectionSource () : String { 
            return _$ ( "new $0($2)", getQualifiedClassName ( this ), getReflectionSourceArguments() );
        }
        protected function getSourceArguments () : String
        {
            return "";
        }
        protected function getReflectionSourceArguments () : String
        {
            return "";
        }
    }
}
