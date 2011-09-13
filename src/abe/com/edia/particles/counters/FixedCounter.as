package abe.com.edia.particles.counters
{

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="count")]
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

        public function clone () : *
        {
            return new FixedCounter( _count );
        }
    }
}
