package abe.com.edia.particles.timers
{
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class NullTimer implements Timer
    {
        public function get nextTime () : int {return 0;}
        public function get isFinish () : Boolean {return true;}

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
            return new NullTimer();
        }
    }
}
