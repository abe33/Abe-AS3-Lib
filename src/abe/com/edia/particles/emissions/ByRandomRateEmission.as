package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.emitters.Emitter;
    import abe.com.mon.utils.RandomUtils;


	/**
	 * Emits particles with a randomly modified rate.
	 * 
	 * @author Cédric Néhémie
	 * 
	 */
    [Serialize(constructorArgs="particleType,emitter,rateMin,rateMax")]
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

        public function get rateMin () : Number {
            return _rateMin;
        }

        public function set rateMin ( rateMin : Number ) : void {
            _rateMin = rateMin;
        }

        public function get rateMax () : Number {
            return _rateMax;
        }

        public function set rateMax ( rateMax : Number ) : void {
            _rateMax = rateMax;
        }
	}
}