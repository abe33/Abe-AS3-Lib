package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.PointUtils;

	[Serialize(constructorArgs="friction")]
    public class FrictionActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{
		protected var _nFriction : Number;

        public function FrictionActionStrategy ( friction : Number = 0.99 )
		{
			_nFriction = friction;
		}
		public override function process(particle:Particle):void
		{
			PointUtils.scale( particle.velocity, _nFriction );
		}
		
		public function get friction () : Number { return _nFriction; }
		public function set friction( friction : Number ) : void { _nFriction = isNaN( friction ) ? 1 : friction; }	
	}
}