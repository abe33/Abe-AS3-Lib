package abe.com.edia.particles.core
{
    import abe.com.edia.particles.strategy.ActionStrategy;
    import abe.com.edia.particles.strategy.InitializeStrategy;
    import abe.com.edia.particles.strategy.actions.NullActionStrategy;
    import abe.com.edia.particles.strategy.initialize.NullInitializer;
    import abe.com.mon.utils.magicToReflectionSource;
    import abe.com.mon.utils.magicToSource;

    import flash.utils.getTimer;

	public class BaseParticleSystem extends AbstractParticleSystem
	{
		protected var _action : ActionStrategy;
		protected var _initializer : InitializeStrategy;
        protected var _particlesDeathSubSystem : SubParticleSystem;
		/*-----------------------------------------------------------------
				PUBLIC METHODS
		------------------------------------------------------------------*/
		public function BaseParticleSystem( initializer : InitializeStrategy = null, 
        									action : ActionStrategy = null, 
                                            particlesDeathSubSystem : SubParticleSystem = null )
		{
			super();
			this.initializer = initializer;
			this.action = action;
            this.particlesDeathSubSystem = particlesDeathSubSystem;
		}
        
        public function get particlesDeathSubSystem () : SubParticleSystem { return _particlesDeathSubSystem; }
        public function set particlesDeathSubSystem ( particlesDeathSubSystem : SubParticleSystem ) : void { _particlesDeathSubSystem = particlesDeathSubSystem; }

		public function get action () : ActionStrategy { return _action; }
		public function set action ( action : ActionStrategy ) : void 
        { 
            _action = action ? action : new NullActionStrategy(); 
            _action.system = this;
        }
		
		public function get initializer () : InitializeStrategy { return _initializer; }
		public function set initializer( initializer : InitializeStrategy ) : void 
        { 
            _initializer = initializer ? initializer : new NullInitializer();
            _initializer.system = this; 
        }
		/*-----------------------------------------------------------------
				PROTECTED METHODS
		------------------------------------------------------------------*/
		override protected function _initializeParticle( particle : Particle, time : Number) : void
		{
			_initializer.initialize( particle );
			_action.prepareAction( time, time / 1000, getTimer() );
			_action.process( particle );
		}
		override protected function _prepareAction( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
		{
			_action.prepareAction( bias, biasInSeconds, currentTime );
		}
		override protected function _processParticle( particle : Particle ) : void
		{
            _action.process ( particle );
        }
        override protected function _handleParticleDeath ( particle : Particle ) : void
        {
            if( _particlesDeathSubSystem )
            	_particlesDeathSubSystem.emitFor(particle);
            
            super._handleParticleDeath ( particle );
        }

        override public function clone () : *
        {
            return new BaseParticleSystem(_initializer, _action, particlesDeathSubSystem.clone() );
        }
        
        override protected function getSourceArguments () : String
        {
            return "\n\t" + [ _initializer.toSource().replace( /\n/g, "\n\t" ), 
            		 _action.toSource().replace( /\n/g, "\n\t" ), 
                     magicToSource( _particlesDeathSubSystem ).replace( /\n/g, "\n\t" ) ].join(",\n\t");
        }
		override protected function getReflectionSourceArguments () : String
        {
            return "\n\t" + [ _initializer.toReflectionSource().replace( /\n/g, "\n\t" ), 
            		 _action.toReflectionSource().replace( /\n/g, "\n\t" ), 
                     magicToReflectionSource( _particlesDeathSubSystem ).replace( /\n/g, "\n\t" ) ].join(",\n\t");
        }
	}
}