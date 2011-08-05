package abe.com.edia.particles.counters
{
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class FixedCounter implements Counter
    {
        protected var _count : int;
        
        public function FixedCounter ( count : int = 1 )
        {
            _count = count;
        }
        public function get count () : int { return _count; }
        public function set count ( count : int ) : void { _count = count; }
        
        public function prepare ( t : Number, ts : Number, time : Number ) : void {}

        public function toSource () : String
        {
            return _$("new $0($1)", getQualifiedClassName(this).replace("::", "."), _count );
        }
        public function toReflectionSource () : String
        {
            return _$("new $0($1)", getQualifiedClassName(this), _count );
        }
        public function clone () : *
        {
            return new FixedCounter( _count );
        }
    }
}
