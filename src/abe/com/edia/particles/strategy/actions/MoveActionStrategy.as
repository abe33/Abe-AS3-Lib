package abe.com.edia.particles.strategy.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.strategy.ActionStrategy;

    public class MoveActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{	
		public override function process( particle : Particle ) : void
		{
			particle.lastPosition.x = particle.position.x;
			particle.lastPosition.y = particle.position.y;
			
			particle.position.x += particle.velocity.x * _nTimeStep;
			particle.position.y += particle.velocity.y * _nTimeStep;
		}
	}
}