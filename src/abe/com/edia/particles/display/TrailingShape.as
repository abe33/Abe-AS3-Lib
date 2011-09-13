package abe.com.edia.particles.display
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.AllocatorInstance;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;

    import flash.display.Shape;
    import flash.events.Event;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class TrailingShape extends Shape implements ImpulseListener, Allocable
    {
        public var target : Object;
        public var trailColor : Color;
        public var trailThickness : Number; 
        public var trailLength : Number;
        
        private var _coords : Array;
        
        public function TrailingShape ( target : Object = null, 
        								trailColor : Color = null,
        								trailThickness : Number = 2, 
                                        trailLength : Number = 10 )
        {
            this.target = target;
            this.trailColor = trailColor;
            this.trailThickness = trailThickness;
            this.trailLength = trailLength;
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            _coords.push( pt( target.x, target.y ) );
            if( _coords.length > trailLength )
            	_coords.shift();
            
            var l : uint = _coords.length;
            graphics.clear();
            for ( var i : int = 1;i<l;i++)
            {
                var p1 : Point = _coords[i-1];
                var p2 : Point = _coords[i];
	            graphics.lineStyle(trailThickness, trailColor.hexa, Math.max( 0, trailColor.alpha - (1-i/(l-1))*trailColor.alpha ) / 255);
                graphics.moveTo(p1.x, p1.y);
                graphics.lineTo(p2.x, p2.y);
            }
        }

        public function init () : void
        {
            _coords = [];
            addEventListener(Event.ADDED_TO_STAGE, addedToStage );
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage );
        }
        
        public function dispose () : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStage );
            removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage );
        }
        
        
        override public function set x ( value : Number ) : void {
//            super.x = value;
        }

        override public function set y ( value : Number ) : void {
      //      super.y = value;
        }

        private function removedFromStage ( event : Event ) : void
        {
            Impulse.unregister( tick );
            AllocatorInstance.release(this);
        }
        private function addedToStage ( event : Event ) : void
        { 
            Impulse.register( tick );
        }

    }
}
