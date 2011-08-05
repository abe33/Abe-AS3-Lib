package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;

    import flash.geom.Point;

	public class ScaleActionStrategy extends AbstractActionStrategy
	{
		protected var _pGrowthSpeed : Point;
		
		public function ScaleActionStrategy ( growthSpeed : Point = null )
		{
			_pGrowthSpeed = growthSpeed ? growthSpeed : new Point();
		}
		
		override public function process( particle : Particle ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
			p.scale.x += _pGrowthSpeed.x * _nTimeStep;
			p.scale.y += _pGrowthSpeed.y * _nTimeStep;
        }

        override protected function getSourceArguments () : String
        {
            return String( _pGrowthSpeed );
        }
        override protected function getReflectionSourceArguments () : String
        {
            return String( _pGrowthSpeed );
        }

	}
}