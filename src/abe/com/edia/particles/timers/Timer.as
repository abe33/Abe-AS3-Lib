package abe.com.edia.particles.timers
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Serializable;
    /**
     * @author cedric
     */
    public interface Timer extends Serializable, Cloneable
    {
        function prepare( t : Number, ts : Number, time : Number ) : void;
        function get nextTime() : int;
        function get isFinish() : Boolean;
    }
}
