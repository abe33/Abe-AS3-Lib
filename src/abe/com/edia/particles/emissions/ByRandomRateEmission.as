package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.emitters.Emitter;
    import abe.com.mon.utils.RandomUtils;
    import flash.utils.getQualifiedClassName;


	/**
	 * Emits particles with a randomly modified rate.
	 * 
	 * @author Cédric Néhémie
	 * 
	 */
	public class ByRandomRateEmission extends ByRateEmission implements ParticleEmission
	{
		protected var _rateMin : Number; 
		protected var _rateMax : Number; 
		
		public function ByRandomRateEmission( type : Class, emitter : Emitter = null, rateMin : Number = 1, rateMax : Number = 2 )
		{
			super( type, emitter, rate );
			
            _rateMin = rateMin;
            _rateMax = rateMax;
        }
        override public function clone () : *
        {
            return new ByRandomRateEmission( _particleType, _emitter, _rateMin, _rateMax );
        }
		public override function prepare( bias : Number, biasInSecond : Number, time : Number ) : void
		{
			var t : Number = _nTimeRest + bias;
			
			rate =  RandomUtils.rangeAB( _rateMin, _rateMax );
			
			_nParticlesRest = ( t - ( _nTimeRest = ( t % _nTimeStep ) ) ) / _nTimeStep;
		}
        override protected function getSourceArguments () : String
        {
            return [ getQualifiedClassName(_particleType).replace("::", "."), _emitter.toSource(), _rateMin, _rateMax ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ getQualifiedClassName(_particleType), _emitter.toReflectionSource(), _rateMin, _rateMax ].join(", ");
        }
	}
}