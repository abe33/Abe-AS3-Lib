package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.patibility.lang._$;
    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class NullActionStrategy implements ActionStrategy
    {
        public function prepare ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void {}
        public function process ( particle : Particle ) : void {}
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
