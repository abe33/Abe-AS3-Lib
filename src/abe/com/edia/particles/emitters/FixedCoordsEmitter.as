package abe.com.edia.particles.emitters
{
    import abe.com.edia.particles.emitters.Emitter;

    /**
     * @author cedric
     */
    public interface FixedCoordsEmitter extends Emitter
    {
        function get coords():Array;
    }
}
