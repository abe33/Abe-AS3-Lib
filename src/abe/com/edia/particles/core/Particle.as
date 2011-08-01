package abe.com.edia.particles.core
{
    import org.osflash.signals.Signal;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.utils.StringUtils;
    import flash.geom.Point;

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
         * The last position of the particle.
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
        
        public var died : Signal;

        /**
         * Creates a new particle.
         * 
         * <p>A particle constructor won't accept any arguments.
         * To initialize a particle you should create an <code>InitializeStrategy</code>.
         */
        public function Particle () {
            died = new Signal();
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

        public function init () : void 
        {
            life = 0;
            maxLife = 0;
            velocity = new Point ();
            position = new Point ();
            lastPosition = new Point ();
        }

        public function dispose () : void {
            velocity = null;
            position = null;
            lastPosition = null;
        }

        public function isDead () : Boolean
        {
            return life >= maxLife;
        }
    }
}