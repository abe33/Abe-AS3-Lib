package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.actions.ActionStrategy;
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.SubParticleSystem;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="initializer,action,emissionFactory,particlesDeathSubSystem")]
    public class SubSystemInitializer extends AbstractInitializer
    {
        protected var _subSystem : SubParticleSystem;
        public function SubSystemInitializer ( 	initializer : Initializer = null, 
	        									action : ActionStrategy = null,
	                                            emissionFactory : Function = null,
                                            	particlesDeathSubSystem : SubParticleSystem = null )
        {
            _subSystem = new SubParticleSystem( initializer, action, emissionFactory, particlesDeathSubSystem );
        }
        public function get subSystem () : SubParticleSystem { return _subSystem; }
        public function set subSystem ( subSystem : SubParticleSystem ) : void { _subSystem = subSystem; }
        
        public function get initializer () : Initializer { return _subSystem.initializer; }
        public function get action () : ActionStrategy { return _subSystem.action; }
        public function get emissionFactory () : Function { return _subSystem.emissionFactory; }
        public function get particlesDeathSubSystem () : SubParticleSystem { return _subSystem.particlesDeathSubSystem; }

        override public function initialize ( particle : Particle ) : void
        {
            if( _subSystem )
            	_subSystem.emitFor(particle);
        }

    }
}
