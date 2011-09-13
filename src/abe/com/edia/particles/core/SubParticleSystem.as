package abe.com.edia.particles.core
{
    import abe.com.edia.particles.actions.ActionStrategy;
    import abe.com.edia.particles.initializers.Initializer;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="initializer,action,emissionFactory,particlesDeathSubSystem")]
    public class SubParticleSystem extends BaseParticleSystem
    {
        protected var _emissionFactory : Function;
        
        public function SubParticleSystem ( initializer : Initializer = null, 
        									action : ActionStrategy = null,
                                            emissionFactory : Function = null,
                                            particlesDeathSubSystem : SubParticleSystem = null )
        {
            super ( initializer, action, particlesDeathSubSystem );
            _emissionFactory = emissionFactory;
        }
        
        public function get emissionFactory () : Function { return _emissionFactory; }
        public function set emissionFactory ( emissionFactory : Function ) : void { _emissionFactory = emissionFactory; }
        
        public function emitFor( particle : Particle ) : void
        {
            if( _emissionFactory != null )
            	emit( _emissionFactory( particle ) );
        }
        override public function clone () : *
        {
            return new SubParticleSystem(_initializer, _action, _emissionFactory, particlesDeathSubSystem.clone() );
        }
        
    }
}
