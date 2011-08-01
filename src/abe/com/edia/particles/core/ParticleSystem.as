package abe.com.edia.particles.core
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Serializable;
    import abe.com.edia.particles.strategy.EmissionStrategy;
    import abe.com.mands.Command;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.Suspendable;
    import abe.com.motion.ImpulseListener;

	/**
	 * A <code>ParticleSystem</code> is a structure witch both contains
	 * particles and methods to apply on them. Use a particle system each
	 * time you want to manage particles with specific behaviors.
	 * 
	 * <p>That interface defines rules that a <code>ParticleSystem</code>
	 * have to follow when dealing with particles. For example, a system
	 * should use <code>EmissionStrategy</code> object to perform creation
	 * of particles in time. That's not the system that creates particles,
	 * it just handle them, in the same way the system don't act itself
	 * on particles, it simply own strategies that will act on particles.</p>
	 * 
	 * <p>That interface don't defines rules a system have to follow concerning
	 * initializations and actions methods to apply to particles. It's let at
	 * the convenience of concrets classes that implement <code>ParticleSystem</code>
	 * witch can create and use any kind of strategies to performs particles life.</p>
	 * 
	 * <p>The only object that is allowed to handle particle systems is the 
	 * <code>ParticleManager</code>, systems have to register themselves to
	 * it when instanciated. That registration iss necessary in order to provide
	 * a global access to all systems created within Atomos.</p>
	 * 
	 * @author  Cédric Néhémie 
	 * @see		com.atomos.particle.Particle
	 * @see		com.atomos.particle.ParticleManager
	 * @see		com.atomos.strategy.emission.EmissionStrategy
	 */
	public interface ParticleSystem extends Command, ImpulseListener, Suspendable, Allocable, Serializable, Cloneable
	{
		/**
		 * Starts an emission of particles according to the rules defined in
		 * the passed-in <code>EmissionStrategy</code>. A particle system may
		 * own several emissions at the same time.
		 * 
		 * <p>If a system witch use strategy to perform particles creation receive
		 * a null object in the <code>emit</code>
		 * 
		 * <p>If a system don't use <code>EmissionStrategy</code> to perform the
		 * particles creation it have to throw an <code>UnsupportedOperationException</code>
		 * in the <code>emit</code> method and have to provide an alternative method
		 * to perform emission.</p>
		 * 
		 * @param emission	<code>EmissionStrategy</code> to perform
		 * @throws com.bourre.error.NullPointerException The passed-in strategy is null
		 * @throws com.bourre.error.UnsupportedOperationException The current
		 * 		   class don't support the <code>emit<code> method
		 */
		function emit ( emission : EmissionStrategy = null ) : void;
		function stopEmission ( emission : EmissionStrategy ) : void;

		function set particles ( particles : Array ) : void;
		function get particles () : Array;

		function get emissions () : Array;

		/**
		 * Returns <code>true</code> if there is at least one emission running
		 * in the current system, either <code>false</code>.
		 * 
		 * @return <code>true</code> if there is an emission running in the system,
		 * 		   either <code>false</code>
		 */
		function isEmitting () : Boolean;
	}
}