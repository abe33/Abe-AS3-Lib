package abe.com.edia.particles.core
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.utils.StringUtils;

    import org.osflash.signals.Signal;

    import flash.geom.Point;
    import flash.utils.Dictionary;

    /**
     * The <code>Particle</code> class is the base class for all particles used in Atomos. It contains
     * only the mimimum properties required to work with basic strategies of Atomos.
     * 
     * <p>You can extend it to create your own custom particles (see <code>DisplayObjectParticles</code>
     * for a concret example of inheritance from particle).
     * 
     * @author Cédric Néhémie
     */
    public class Particle implements Allocable
    {
        /**
         * The position of the particle.
         */
        public var position : Point;
        /**
         * The last position of the particle for verlet based engine.
         * 
         * <p>Updated at the end of the animation process, before modifying
         * the particle's position.</p>
         */
        public var lastPosition : Point;
        /**
         * The speed of the particles represented by a vector.
         */
        public var velocity : Point;
        /**
         * The current life time of the particle, generally specified in milliseconds.
         */
        public var life : Number;
        /**
         * The maximum life time of the particle, generally specified in milliseconds.
         */
        public var maxLife : Number;

        private var _dead : Boolean;
        private var _parasites : Dictionary;

        public var died : Signal;
        public var revived : Signal;

        /**
         * Creates a new particle.
         * 
         * <p>A particle constructor won't accept any arguments.
         * To initialize a particle you should create an <code>InitializeStrategy</code>.
         */
        public function Particle () 
        {
            died = new Signal();
        }
        
        public function isDead () : Boolean { return _dead; }
        public function die():void
        {
            _dead = true;
            
			life = maxLife;
        	died.dispatch( this );   
        }
        public function revive():void
        {
            _dead = false;
            
            life = 0;
            revived.dispatch( this );
        }

        public function init () : void 
        {
            _dead = false;
            _parasites = new Dictionary(true);
            
            life = 0;
            maxLife = 0;
            velocity = new Point ();
            position = new Point ();
            lastPosition = new Point ();
        }
        public function dispose () : void 
        {
            _parasites = null;
            
            velocity = null;
            position = null;
            lastPosition = null;
        }
        
        public function setParasite( key : *, data : * ):void
        {
            _parasites[key] = data;
        }
        public function removeParasite( key : * ):void
        {
            delete _parasites[key];
        }
        public function getParasite( key : * ) : * 
        {
            return _parasites[key];
        }
        public function hasParasite( key : * ) : Boolean
        {
            return _parasites[key] != undefined;
        }

        /**
         * Returns the <code>String</code> representation of this object.
         * 
         * @return <code>String</code> representation of this object.
         */
        public function toString () : String
        {
            return StringUtils.stringify( this, {'life':life} );
        }

    }
}