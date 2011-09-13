package abe.com.edia.particles.counters
{
    import abe.com.edia.particles.emitters.FixedCoordsEmitter;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="emitter")]
    public class EmitterBasedCounter implements Counter
    {
        protected var _count : int;
		protected var _emitter : FixedCoordsEmitter;
        
        public function EmitterBasedCounter ( emitter : FixedCoordsEmitter )
        {
            _emitter = emitter;
        }
        
        public function get count () : int { return _count; }

        public function get emitter () : FixedCoordsEmitter { return _emitter; }
        public function set emitter ( emitter : FixedCoordsEmitter ) : void { _emitter = emitter; }
        
        public function prepare ( t : Number, ts : Number, time : Number ) : void
        {
            _count = _emitter.coords.length;
        }

        public function clone () : *
        {
            return new EmitterBasedCounter ( _emitter );
        }


    }
}
