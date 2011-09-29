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
        protected var _ratio : Number;
        protected var _emitter : FixedCoordsEmitter;
        
        public function EmitterBasedCounter ( emitter : FixedCoordsEmitter, ratio : Number = 1 )
        {
            _emitter = emitter;
            _ratio = ratio;
        }
        
        public function get count () : int { return _count; }

        public function get emitter () : FixedCoordsEmitter { return _emitter; }
        public function set emitter ( emitter : FixedCoordsEmitter ) : void { _emitter = emitter; }

        public function get ratio () : Number { return _ratio; }
        public function set ratio ( ratio : Number ) : void { _ratio = ratio; }
        
        public function prepare ( t : Number, ts : Number, time : Number ) : void
        {
            if( _ratio != 1 )
            	_count = Math.floor( _emitter.coords.length * _ratio );
            else
            	_count = _emitter.coords.length;
        }       
        
        public function clone () : *
        {
            return new EmitterBasedCounter ( _emitter, _ratio );
        }

    }
}
