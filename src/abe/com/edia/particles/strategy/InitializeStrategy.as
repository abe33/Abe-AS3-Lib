package abe.com.edia.particles.strategy
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.mon.core.Serializable;

    /**
     * 
     * @author Cédric Néhémie
     */
    public interface InitializeStrategy extends Serializable
    {
        /**
         * 
         * @param particle
         */
        function initialize ( particle : Particle ) : void;
        
        function get system () : ParticleSystem;
        function set system ( s : ParticleSystem ):void;
    }
}