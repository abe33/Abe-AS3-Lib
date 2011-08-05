package abe.com.edia.particles.counters
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Serializable;
    /**
     * @author cedric
     */
    public interface Counter extends Serializable, Cloneable
    {
        function get count():int;
        function prepare( t : Number, ts : Number, time : Number ):void;
    }
}
