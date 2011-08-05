package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

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