package abe.com.edia.particles.timers
{
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="since")]
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

        public function clone () : *
        {
            return new InfiniteTimer (_since);
        }
    }
}
