package abe.com.edia.particles.timers
{

    /**
     * @author cedric
     */
    public class InstantTimer implements Timer
    {
        public function get nextTime () : int { return 0; }
        public function get isFinish () : Boolean { return true; }

        public function prepare ( t : Number, ts : Number, time : Number ) : void {}
        
        public function clone () : *
        {
            return new InstantTimer();
        }
    }
}
