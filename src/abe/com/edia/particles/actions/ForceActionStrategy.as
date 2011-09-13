package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

    import flash.geom.Point;

	[Serialize(constructorArgs="force")]
    public class ForceActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{
		protected var _force : Point;

        public function ForceActionStrategy ( force : Point )
		{
			_force = force;
		}
		public override function process(particle:Particle):void
		{
			particle.velocity.x += _force.x * _nTimeStep;
			particle.velocity.y += _force.y * _nTimeStep;
		}
		public function set force ( force : Point ) : void
		{
			_force = force ? force : new Point();
		}
		public function get force () : Point
		{
			return _force;
        }
	}
}