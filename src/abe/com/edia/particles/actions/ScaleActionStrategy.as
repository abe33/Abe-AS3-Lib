package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;

    import flash.geom.Point;

	[Serialize(constructorArgs="growthSpeed")]
	public class ScaleActionStrategy extends AbstractActionStrategy
	{
		protected var _growthSpeed : Point;
		
		public function ScaleActionStrategy ( growthSpeed : Point = null )
		{
			_growthSpeed = growthSpeed ? growthSpeed : new Point();
		}
		
		override public function process( particle : Particle ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
			p.scale.x += _growthSpeed.x * _nTimeStep;
            p.scale.y += _growthSpeed.y * _nTimeStep;
        }

        public function get growthSpeed () : Point {
            return _growthSpeed;
        }

        public function set growthSpeed ( growthSpeed : Point ) : void {
            _growthSpeed = growthSpeed;
        }

	}
}