package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;

    public class AbstractActionStrategy implements ActionStrategy
	{
        protected var _nTimeStep : Number;
        protected var _system : ParticleSystem;
		
		public function prepare( bias : Number, biasInSecond : Number, currentTime : Number ) : void
		{
			_nTimeStep = biasInSecond;
		}
        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void {  _system = s; }
        
		public function process( particle : Particle ) : void
		{
		}
	}
}