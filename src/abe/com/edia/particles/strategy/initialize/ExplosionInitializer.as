package abe.com.edia.particles.strategy.initialize
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.geom.Range;
    import abe.com.mon.utils.RandomUtils;

	public class ExplosionInitializer extends AbstractInitializer
	{
		protected var _oAngleRange : Range;
		protected var _nRadiusMin : Number;
		protected var _nRadiusMax : Number;
		protected var _nRandom : Number;
		
		public function ExplosionInitializer ( radiusMin : Number, radiusMax : Number, angle : Range = null )
		{
			_nRadiusMin = isNaN( radiusMin ) ? 0 : radiusMin;
			_nRadiusMax = isNaN( radiusMax ) ? 0 : radiusMax;
			_oAngleRange = angle ? angle : new Range( 0, Math.PI * 2 );
		}
		override public function initialize(particle:Particle):void
		{
			var a : Number = RandomUtils.range( _oAngleRange );
			var rad : Number = RandomUtils.rangeAB( _nRadiusMin, _nRadiusMax );
			
			particle.velocity.x = Math.sin( a ) * rad;
			particle.velocity.y = Math.cos( a ) * rad;
        }

        override protected function getSourceArguments () : String
        {
            return [ _nRadiusMin, _nRadiusMax, _oAngleRange.toSource() ].join(", ");
        }

        override protected function getReflectionSourceArguments () : String
        {
            return [ _nRadiusMin, _nRadiusMax, _oAngleRange.toReflectionSource() ].join(", ");
        }

	}
}