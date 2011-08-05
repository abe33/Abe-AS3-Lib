package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

	public class LifeActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{		
		public override function process( particle : Particle ):void
		{
			particle.life += _nTimeStep * 1000;
            if( particle.life >= particle.maxLife )
            	particle.die();
            
        }
	}
}