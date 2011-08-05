package abe.com.edia.particles.core
{
    import abe.com.edia.particles.emissions.ParticleEmission;
    import abe.com.mands.AbstractCommand;
    import abe.com.mon.utils.AllocatorInstance;
    import abe.com.motion.Impulse;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    import org.osflash.signals.Signal;



	/**
	 * <code>AbstractParticleSystem</code> provides a basic implementation for
	 * generic particle systems. It extends the <code>RTObject</code> and 
	 * implements real time behaviors for generation of particles. IT can store
	 * several <code>EmissionStrategy</code> but don't implements initializations
	 * and actions strategies storage.
	 * 
	 * <p>When extending the <code>AbstractParticleSystem</code> class you will
	 * override the <code>_initializeParticle</code>, <code>_prepareAction</code>
	 * and <code>_processParticle</code> protected methods in order to create the
	 * concret implementation of those behaviors.</p>
	 * 
	 * @author Cédric Néhémie
	 * @see	   ParticleSystem
	 * @see	   com.kairos.engine.RTObject
	 */
	public class AbstractParticleSystem extends AbstractCommand implements ParticleSystem
	{
        protected var _manager : ParticleManager;
        
		protected var _particles : Array;
        protected var _emissions : Array;
        
        public var particlesCreated : Signal;
        public var particleDied : Signal;
        
        public var emissionStarted : Signal;
        public var emissionFinished : Signal;
		
		public function AbstractParticleSystem ( manager : ParticleManager = null ) 
		{
            particlesCreated = new Signal();
            particleDied = new Signal();
            
            emissionStarted = new Signal();
            emissionFinished = new Signal();
            
			_manager = manager ? manager : ParticleManagerInstance;
			_particles = [];
			_emissions = [];
            
            init();
		}
		
		public function emit ( emission : ParticleEmission = null ) : void
		{
			if( emission == null )
				throw new Error( _$(_("$0.emit was called with a null emission"), this ) );

			_emissions.push( emission );	
            emission.system = this;
			_startEmission( emission );
			
			start();
		}
        public function stopEmission( emission : ParticleEmission ) : void
        {
            if( !emission.isFinish() )
            	_removeEmission(emission);
        }
		
		public function isEmitting() : Boolean
		{
			return _emissions.length != 0;
		}
		public function set particles(particles : Array) : void { _particles = particles; }
        public function get particles() : Array { return _particles; }
        public function get emissions() : Array { return _emissions; }
        
        public function tick(bias : Number, biasInSeconds : Number, currentTime : Number) : void 
        {
            _processParticles( bias, biasInSeconds, currentTime );
			
			if ( isEmitting() )
				_processEmissions( bias, biasInSeconds, currentTime );
        }

        override public function execute ( ...args ) : void
        {
            start();
        }
        public function start() : void 
        {
            if(!_isRunning)
            {
                Impulse.register(tick);
                _isRunning = true;
            }
        }
        public function stop() : void 
        {
            if(_isRunning )
            {
                Impulse.unregister(tick);
                _isRunning = false;
            }
        }
        public function init() : void 
        {
            _manager.addParticleSystem( this );
        }
        public function dispose() : void 
        {
            _manager.removeParticleSystem( this );
        }
		/*-------------------------------------------------------
				PROTECTED MEMBERS
		---------------------------------------------------------*/
		
		protected function _startEmission ( emission : ParticleEmission ) : void
		{
            emissionStarted.dispatch( this, emission );
            var a : Array = [];
            
            emission.prepare( 0, 0, getTimer() );
            
			while( emission.hasNext() )
			{
				var time : Number = emission.nextTime(); 
				var particle: Particle = emission.next() as Particle;
				a.push(particle);
				_registerParticle( particle );					
				_initializeParticle( particle, time );
			}
            particlesCreated.dispatch( this, a );
			
			if( emission.isFinish() ) 
			{
				_removeEmission( emission );
                emissionFinished.dispatch( this, emission );
			}
		}
		
		protected function _processEmissions ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
		{
			var l : Number = _emissions.length;
			var a : Array = [];
			while ( l-- )
			{
				var emission : ParticleEmission = _emissions[ l ] as ParticleEmission;
				
				emission.prepare( bias, biasInSeconds, currentTime );
                
				while( emission.hasNext() )
				{
					var time : Number = emission.nextTime(); 
					var particle : Particle = emission.next() as Particle;
					a.push(particle);
					_registerParticle( particle );
					_initializeParticle( particle, time );
				}
				if( emission.isFinish() ) 
				{
					_removeEmission( emission );
                    emissionFinished.dispatch( this, emission );
				}
			}
            particlesCreated.dispatch(this,a);
		}
		
		protected function _removeEmission ( emission : ParticleEmission ) : void
		{
			var i : Number = _emissions.indexOf( emission );
            if( i != -1)
				_emissions.splice( i, 1 );
		}
		
		protected function _processParticles ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
		{
			_prepareAction ( bias, biasInSeconds, currentTime );
			for each( var particle : Particle in _particles )
			{
				_processParticle( particle );
				
				if( particle.isDead() )
					_unregisterParticle( particle );
			}
		}
				
		protected function _initializeParticle ( particle : Particle, time : Number ) : void	{}
		protected function _prepareAction ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void {}		
		protected function _processParticle ( particle : Particle ) : void {}
        protected function _handleParticleDeath ( particle : Particle ) : void {}
	
		protected function _registerParticle ( particle : Particle ) : void
		{			
			_manager.addParticle( particle );
			_particles.push( particle );
		}
		protected function _unregisterParticle ( particle : Particle ) : void
		{	
            _handleParticleDeath( particle );
            particleDied.dispatch( this, particle );
            
			_manager.removeParticle( particle );
			_particles.splice( _particles.indexOf(particle), 1 );
            
            AllocatorInstance.release( particle );
        }

        public function toSource () : String
        {
            return _$ ( "new $0($1)", getQualifiedClassName ( this ).replace("::","."), getSourceArguments () );
        }
        
        public function toReflectionSource () : String { 
            return _$ ( "new $0($1)", getQualifiedClassName ( this ), getReflectionSourceArguments () ); 
        }
       
        protected function getSourceArguments () : String
        {
            return "";
        }
        protected function getReflectionSourceArguments () : String
        {
            return "";
        }

        public function clone () : *
        {
            return null;
        }

	}
}