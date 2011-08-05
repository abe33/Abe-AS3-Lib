package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.mon.core.Serializable;
	
	/**
	 * 
	 * @author Cédric Néhémie
	 */
	public interface ActionStrategy extends Serializable
	{
		/**
		 * Prepares the computation of action for all particles according
		 * to the time parameter (in milliseconds).
		 * 
		 * @param e
		 */
		function prepare ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void;
		
		/**
		 * 
		 * @param particle
		 */
		function process ( particle : Particle ) : void;
        
        function get system () : ParticleSystem;
        function set system ( s : ParticleSystem ):void;
	}
}