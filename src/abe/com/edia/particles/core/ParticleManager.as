package abe.com.edia.particles.core
{
    import abe.com.mon.geom.Surface;
    import abe.com.mon.utils.StringUtils;

    import flash.geom.Point;

	/**
	 * The <code>ParticleManager</code> singleton  manages particles and systems
	 * storage.
	 * 
	 * <p>Basically the <code>ParticleManager</code> is the only class which should
	 * contains hard references to particles and systems. All other objects, even
	 * if they creates new objects will stores them as weak references and register
	 * them in the <code>ParticleManager</code>.</p>
	 * 
	 * @author Cédric Néhémie 
	 */
	final public class ParticleManager
	{
		private var _allParticleSystems : Array;
		private var _allParticles : Array;
		
		/**
		 * Constructs a new <code>ParticleManager</code> instance.
		 */
		public function ParticleManager ()
		{
			init();
		}
		
		/**
		 * Adds a <code>ParticleSystem</code> into the <code>ParticleManager</code>.
		 * 
		 * <p>A <code>ParticleSystem</code> can only be inserted one time in the set.
		 * If you try to insert a system already contained in the set, the function don't
		 * do anything.</p>
		 * 
		 * @param e <code>ParticleSystem</code> to add in the <code>ParticleManager</code>
		 */
		public function addParticleSystem ( e : ParticleSystem ) : void
		{
            if( !containsParticleSystem(e) )
				_allParticleSystems.push( e );
		}
		
		/**
		 * Removes the passed-in <code>ParticleSystem</code> from the <code>ParticleManager</code>.
		 * 
		 * <p>If the passed-in <code>ParticleSystem</code> isn't already contained in the
		 * <code>ParticleManager</code> the function don't do anything.</p>
		 * 
		 * @param e <code>ParticleSystem</code> to remove from the manager
		 */
		public function removeParticleSystem ( e : ParticleSystem ) : void
		{
            if( containsParticleSystem(e) )
				_allParticleSystems.splice( _allParticleSystems.indexOf(e),1 );
		}
        public function containsParticleSystem( e : ParticleSystem ) : Boolean
        {
            return _allParticleSystems.indexOf( e ) != -1;
        }
        
		
		/**
		 * Returns a collection of all <code>ParticleSystem</code> objects stored
		 * by the <code>ParticleManager</code>. The returned collection is a
		 * <code>WeakCollection</code> by the way all references are weaks. 
		 * 
		 * @return <code>WeakCollection</code> of <code>ParticleSystems</code>
		 */
		public function get particleSystems () : Array { return _allParticleSystems; }
		
		/**
		 * Returns the number of <code>EmissionStrategy</code> objects currently
		 * running in systems contained by the <code>ParticleManager</code>.
		 * 
		 * @return <code>Number</code> of <code>EmissionStrategy</code> objects currently
		 * 		   running in systems contained by the <code>ParticleManager</code>.
		 */
		public function get emissionsCount () : uint
		{
            var n : uint = 0;
            for each( var e : ParticleSystem in _allParticleSystems )
			{
				n += e.emissions.length;
			}
			return n;
		}
		
		/**
		 * Adds a <code>Particle</code> object in the <code>ParticleManager</code>
		 * 
		 * <p>A <code>Particle</code> can only be inserted one time in the set.
		 * If you try to insert a particle already contained in the set, the
		 * function don't do anything.</p>
		 * 
		 * @param p <code>Particle</code> to add in the <code>ParticleManager</code>
		 */
		public function addParticle ( p : Particle ) : void
		{
            if( !containsParticle(p) )
				_allParticles.push( p );
		}
		
		/**
		 * Removes the passed-in <code>Particle</code> from the <code>ParticleManager</code>.
		 * 
		 * <p>If the passed-in <code>Particle</code> isn't already contained in the
		 * <code>ParticleManager</code> the function don't do anything.</p>
		 * 
		 * @param p <code>Particle</code> to remove from the manager
		 */
		public function removeParticle ( p : Particle ) : void
		{
            if( containsParticle(p) )
				_allParticles.splice( _allParticles.indexOf(p), 1 );
		} 
        public function containsParticle( p : Particle ) : Boolean
        {
            return _allParticles.indexOf( p ) != -1;
        }
		
		/**
		 * Returns a collection of all <code>Particle</code> objects stored
		 * by the <code>ParticleManager</code>. The returned collection is a
		 * <code>WeakCollection</code> by the way all references are weaks. 
		 * 
		 * @return <code>WeakCollection</code> of <code>Particle</code>
		 */
		public function get particles () : Array { return _allParticles; }
		
		/**
		 * Returns a collection of all <code>Particle<code> objects stored
		 * in the <code>ParticleManager<code> of whom type is the same than
		 * the passed-in one.
		 * 
		 * @param type <code>Class</code> to compare with the particles in
		 * 			   <code>ParticleManager</code>
		 * @return <code>WeakCollection</code> of <code>Particle</code> of the
		 * 		   the type in argument
		 */
		public function getParticlesByType ( type : Class ) : Array
		{
			var c : Array = [];
			
            for each( var p: Particle in _allParticles )
			{
				if( p is type )
					c.push( p );
			}
			return c;
		}
        		
		/**
		 * Returns a collection of all <code>Particle<code> objects stored
		 * in the <code>ParticleManager<code> of whom type is the same than
		 * the passed-in one.
		 * 
		 * @param type <code>Class</code> to compare with the particles in
		 * 			   <code>ParticleManager</code>
		 * @return <code>WeakCollection</code> of <code>Particle</code> of the
		 * 		   the type in argument
		 */
		public function getParticlesByArea ( area : Surface ) : Array
		{
			var c : Array = [];
				
			for each( var p : Particle in _allParticles )
			{
				if(	area.contains(p.position.x, p.position.y) )
					c.push( p );
			}
			return c;
		}
		
		/**
		 * 
		 * @param p
		 * @return 
		 */
		public function getParticlesByDistanceFrom ( point : Point, distance : Number ) : Array
		{
			var c : Array = [];
			
			for each( var p : Particle in _allParticles )
			{
				var dist : Number = Point.distance ( p.position, point );
				if(	dist <= distance )
					c.push( p );
			}
			return c;
		}
		
		/**
		 * 
		 * 
		 */
		public function startAllParticleSystems () : void
		{
			for each( var e : ParticleSystem in _allParticleSystems )
				e.start();
		}
		
		/**
		 * 
		 * 
		 */
		public function stopAllParticleSystems () : void
		{
			for each( var e : ParticleSystem in _allParticleSystems )
				e.stop();
		}
		
		/**
		 * 
		 * 
		 */
		public function clear () : void
		{
			stopAllParticleSystems();
			init();
		}
		
		/**
		 * 
		 * 
		 */
		public function init () : void
		{
			_allParticleSystems = [];
			_allParticles = [];
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function toString () : String
		{
			return StringUtils.stringify( this );
		}
	}
}