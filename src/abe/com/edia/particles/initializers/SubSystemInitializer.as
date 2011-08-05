package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.actions.ActionStrategy;
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.SubParticleSystem;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.mon.utils.magicToReflectionSource;
    import abe.com.mon.utils.magicToSource;

    /**
     * @author cedric
     */
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

        override public function initialize ( particle : Particle ) : void
        {
            if( _subSystem )
            	_subSystem.emitFor(particle);
        }

        override protected function getSourceArguments () : String
        {
            return "\n\t"+[ _subSystem.initializer.toSource().replace( /\n/g, "\n\t" ), 
            		 _subSystem.action.toSource().replace( /\n/g, "\n\t" ),
                     getSource( _subSystem.emissionFactory, "${emissionFactory}" ).replace( /\n/g, "\n\t" ),
            		 magicToSource( _subSystem.particlesDeathSubSystem ).replace( /\n/g, "\n\t" )
                   ].join(",\n\t");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return "\n\t"+[ _subSystem.initializer.toReflectionSource().replace( /\n/g, "\n\t" ), 
            		 _subSystem.action.toReflectionSource().replace( /\n/g, "\n\t" ), 
                     getReflectionSource( _subSystem.emissionFactory, "${emissionFactory}" ).replace( /\n/g, "\n\t" ), 
            		 magicToReflectionSource( _subSystem.particlesDeathSubSystem ).replace( /\n/g, "\n\t" )
                   ].join(",\n\t");
        }
    }
}
