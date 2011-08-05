package abe.com.edia.particles.core
{
    import abe.com.mon.core.Allocable;

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.geom.Point;

    /**
     * <code>DisplayObjectParticle</code> extends habilities of particles to deal
     * with <code>DisplayObject</code>. It uses composition to work on <code>DisplayObject</code>.
     * 
     * <p>When dealing with <code>DisplayObjectParticles</code> you should use DisplayObject 
     * specific strategies located in <code>com.atomos.strategy.initialize.display</code> and
     * <code>com.atomos.strategy.action.display</code> packages.
     * 
     * @author 	Cédric Néhémie
     * @see		com.atomos.particle.Particle
     */
    public class DisplayObjectParticle extends Particle implements Allocable
    {
        /**
         * The composed <code>DisplayObject</code> to manipulate.
         */
        protected var _displayObject : DisplayObject;
        /**
         * The scale of the <code>DisplayObject</code> specified as a <code>Point</code>
         */
        public var scale : Point;
        /**
         * The alpha transparency of the <code>DisplayObject</code>.
         */
        public var alpha : Number;
        /**
         * The rotation of the <code>DisplayObject</code>.
         */
        public var rotation : Number;

        /**
         * Constructs a new <code>DisplayObjectParticle</code>.
         * 
         * <p>The constructor don't accept any arguments, to define the target <code>DisplayObject</code>
         * for a particle you should use the <code>DisplayObjectInitalizer</code>
         * strategy.</p>
         * 
         * <p>By default scale, rotation and alpha values are set on the DisplayObject default values,
         * respectively 1, 0 and 1.</p>
         */
        public function DisplayObjectParticle () {}

        public function get displayObject () : DisplayObject { return _displayObject; }
        public function set displayObject ( displayObject : DisplayObject ) : void 
        {
            if( _displayObject )
            	_displayObject.removeEventListener(Event.EXIT_FRAME, exitFrame );
            
            _displayObject = displayObject;
            
            if( _displayObject )
            	_displayObject.addEventListener( Event.EXIT_FRAME, exitFrame );
        }

        private function exitFrame ( event : Event ) : void
        {
            _displayObject.x = position.x;
            _displayObject.y = position.y;
            _displayObject.rotation = rotation;
            _displayObject.alpha = alpha;
            _displayObject.scaleX = scale.x;
            _displayObject.scaleY = scale.y;
        }
        override public function init () : void
        {
            super.init ();
            scale = new Point ( 1, 1 );
            rotation = 0;
            alpha = 1;
        }
        override public function dispose () : void
        {
            super.dispose();
            scale = null;
            if( _displayObject )
            {
	            _displayObject.removeEventListener(Event.EXIT_FRAME, exitFrame );
                if( _displayObject.parent )
	            	_displayObject.parent.removeChild(_displayObject);
                _displayObject = null;
            }
        }
    }
}