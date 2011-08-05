package abe.com.edia.particles.core
{
    import abe.com.edia.particles.actions.ActionStrategy;
    import abe.com.edia.particles.initializers.Initializer;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.mon.utils.magicToReflectionSource;
    import abe.com.mon.utils.magicToSource;

    /**
     * @author cedric
     */
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
        
        override protected function getSourceArguments () : String
        {
            return "\n\t" + [ _initializer.toSource().replace( /\n/g, "\n\t" ), 
            		 _action.toSource().replace( /\n/g, "\n\t" ), 
                     getSource( _emissionFactory, "${emissionFactory}" ).replace( /\n/g, "\n\t" ),
                     magicToSource( _particlesDeathSubSystem ).replace( /\n/g, "\n\t" ) ].join(",\n\t");
        }
		override protected function getReflectionSourceArguments () : String
        {
            return "\n\t" + [ _initializer.toReflectionSource().replace( /\n/g, "\n\t" ), 
            		 _action.toReflectionSource().replace( /\n/g, "\n\t" ), 
                     getReflectionSource( _emissionFactory, "${emissionFactory}" ).replace( /\n/g, "\n\t" ),
                     magicToReflectionSource( _particlesDeathSubSystem ).replace( /\n/g, "\n\t" ) ].join(",\n\t");
        }
    }
}
