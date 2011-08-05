package abe.com.edia.particles.counters
{
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class NullCounter implements Counter
    {
        public function get count () : int { return 0; }
        public function prepare ( t : Number, ts : Number, time : Number ) : void {}
        public function toSource():String
        {
            return _$("new $0()", getQualifiedClassName(this).replace("::", ".") );
        }
        public function toReflectionSource():String
        {
            return _$("new $0()", getQualifiedClassName(this) );
        }
        public function clone () : *
        {
            return new NullCounter();
        }
    }
}
