package abe.com.edia.particles.strategy.initialize
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.RandomUtils;

	public class LifeInitializer extends AbstractInitializer
	{
		protected var _lifeMin : uint;
		protected var _lifeMax : uint;
		
		public function LifeInitializer ( lifeMin : uint, lifeMax : uint = 0 )
		{
			_lifeMin = lifeMin;
			_lifeMax = lifeMax;
		}
		override public function initialize( particle : Particle ) : void
		{
            if( _lifeMax != 0 )
				particle.maxLife = RandomUtils.irangeAB(_lifeMin,_lifeMax);
            else
            	particle.maxLife = _lifeMin;
        }

        override protected function getSourceArguments () : String
        {
            return [_lifeMin, _lifeMax].join(", ");
        }

        override protected function getReflectionSourceArguments () : String
        {
            return [_lifeMin, _lifeMax].join(", ");
        }
        
	}
}