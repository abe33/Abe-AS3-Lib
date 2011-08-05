package abe.com.edia.particles.timers
{
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class LimitedTimer implements Timer
    {
        protected var _duration : Number;
        protected var _since : Number;
        protected var _time : Number;
        protected var _nextTime : Number;
        protected var _firstTime : Boolean;
        
        public function LimitedTimer ( duration : Number = 1000, since : Number = 0)
        {
            _duration = duration;
            _since = since;
            _firstTime = true;
            _time = 0;
        }

        public function get nextTime () : int { return _nextTime; }
        public function get isFinish () : Boolean { return _time >= _duration; }
        
        public function prepare ( t : Number, ts : Number, time : Number ) : void
        {
            if( _firstTime )
            {
                _nextTime = _since;
                _firstTime = false;
            }
            else
            	_nextTime = t;
            
            _time += t;
        }
        public function toSource():String
        {
            return _$("new $0($1,$2)", getQualifiedClassName(this).replace("::", "."), _duration, _since );
        }
        public function toReflectionSource():String
        {
            return _$("new $0($1,$2)", getQualifiedClassName(this), _duration, _since );
        }
        public function clone () : *
        {
            return new LimitedTimer(_duration, _since);
        }
    }
}
