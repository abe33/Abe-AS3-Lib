package abe.com.edia.particles.counters
{

    /**
     * @author cedric
     */
    
    public class NullCounter implements Counter
    {
        public function get count () : int { return 0; }
        public function prepare ( t : Number, ts : Number, time : Number ) : void {}
        
        public function clone () : *
        {
            return new NullCounter();
        }
    }
}
