package abe.com.edia.particles.strategy.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.strategy.ActionStrategy;
    import abe.com.mon.utils.PointUtils;

    public class FrictionActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{
		protected var _nFriction : Number;

        public function FrictionActionStrategy ( friction : Number )
		{
			_nFriction = friction;
		}
		public override function process(particle:Particle):void
		{
			PointUtils.scale( particle.velocity, _nFriction );
		}
		
		public function get friction () : Number { return _nFriction; }
		public function set friction( friction : Number ) : void { _nFriction = isNaN( friction ) ? 1 : friction; }	
        
        override protected function getSourceArguments () : String
        {
            return String( _nFriction );
        }
        override protected function getReflectionSourceArguments () : String
        {
            return String( _nFriction );
        }
	
	}
}