package abe.com.edia.particles.timers
{

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="duration,since")]
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
        
        public function clone () : *
        {
            return new LimitedTimer ( _duration, _since );
        }

        public function get duration () : Number {
            return _duration;
        }

        public function set duration ( duration : Number ) : void {
            _duration = duration;
        }

        public function get since () : Number {
            return _since;
        }

        public function set since ( since : Number ) : void {
            _since = since;
        }
    }
}
