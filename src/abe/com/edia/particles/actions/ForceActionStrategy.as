package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.patibility.lang._$;
    import flash.geom.Point;


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
        override protected function getSourceArguments () : String
        {
            return _$("new flash.geom.Point($0,$1)", _force.x, _force.y );
        }
        override protected function getReflectionSourceArguments () : String
        {
            return _$("new flash.geom::Point($0,$1)", _force.x, _force.y );
        }
	}
}