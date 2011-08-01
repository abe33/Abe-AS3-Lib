package abe.com.edia.particles.strategy.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.strategy.ActionStrategy;

	public class LifeActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{		
		public override function process( particle : Particle ):void
		{
			particle.life += _nTimeStep * 1000;
            if( particle.isDead() )
            	particle.died.dispatch( particle );
        }
	}
}