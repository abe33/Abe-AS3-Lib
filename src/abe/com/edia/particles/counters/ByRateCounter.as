package abe.com.edia.particles.counters
{
    import abe.com.patibility.lang._$;

    import avmplus.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class ByRateCounter implements Counter
    {
        protected var _rate : Number;
        protected var _count : int;
        protected var _fcount : Number;
        
        public function ByRateCounter ( rate : Number )
        {
            _rate = rate;
            _fcount = 0;
        }
        public function get rate () : Number { return _rate; }
        public function set rate ( rate : Number ) : void { _rate = rate; }

        public function prepare ( t : Number, ts : Number, time : Number ) : void
        {
            _fcount += _rate * ts;
            _count = Math.floor( _fcount );
            _fcount -= _count;
        }

        public function get count () : int { return _count; }

        public function toSource():String
        {
            return _$("new $0($1)", getQualifiedClassName(this).replace("::", "."), _rate );
        }
        public function toReflectionSource():String
        {
            return _$("new $0($1)", getQualifiedClassName(this), _rate );
        }
        public function clone () : *
        {
            return new ByRateCounter(_rate);
        }

    }
}
