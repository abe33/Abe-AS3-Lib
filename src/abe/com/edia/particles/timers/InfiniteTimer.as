package abe.com.edia.particles.timers
{
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class InfiniteTimer implements Timer
    {
        protected var _nextTime : Number;
        protected var _since : Number;
        protected var _firstTime : Boolean;

        public function InfiniteTimer ( since : Number = 0 )
        {
            _since  = since;
            _firstTime = true;
        }
		
        public function get since () : Number { return _since; }
        public function set since ( since : Number ) : void { _since = since;}

        public function get nextTime () : int { return _nextTime; }
        public function get isFinish () : Boolean { return false; }
        
        public function prepare ( t : Number, ts : Number, time : Number ) : void
        {
            if( _firstTime )
            {
                _nextTime = _since;
                _firstTime = false;
            }
            else
            	_nextTime = t;
        }

        public function toSource():String
        {
            return _$("new $0($1)", getQualifiedClassName(this).replace("::", "."), _since );
        }
        public function toReflectionSource():String
        {
            return _$("new $0($1)", getQualifiedClassName(this), _since );
        }
        public function clone () : *
        {
            return new InfiniteTimer (_since);
        }
    }
}
