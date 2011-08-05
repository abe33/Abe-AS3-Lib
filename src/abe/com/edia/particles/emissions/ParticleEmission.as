package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Iterator;
    import abe.com.mon.core.Serializable;

	public interface ParticleEmission extends Iterator, Serializable, Cloneable
	{
		function prepare ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void;
		function isFinish() : Boolean;
		function nextTime() : Number;
        
        function get system () : ParticleSystem;
        function set system ( s : ParticleSystem ):void;
	}
}