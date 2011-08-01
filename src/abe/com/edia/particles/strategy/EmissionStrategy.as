package abe.com.edia.particles.strategy
{
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Iterator;
    import abe.com.mon.core.Serializable;

	public interface EmissionStrategy extends Iterator, Serializable, Cloneable
	{
		function isFinish() : Boolean;
		function prepareEmission ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void;
		function nextTime() : Number;
        
        function get system () : ParticleSystem;
        function set system ( s : ParticleSystem ):void;
	}
}