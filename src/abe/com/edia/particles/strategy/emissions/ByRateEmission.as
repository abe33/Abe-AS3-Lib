package abe.com.edia.particles.strategy.emissions
{
    import avmplus.getQualifiedClassName;
    import abe.com.edia.particles.emitters.Emitter;
    import abe.com.mon.core.Cloneable;

	/**
	 * Emits particles indefinitely according to a fixed generation rate.
	 * 
	 * @author Cédric Néhémie
	 */
	public class ByRateEmission extends AbstractEmission implements Cloneable
	{
		protected var _nRate : Number;
		protected var _nTimeStep : Number;
		protected var _nTimeRest : Number;
		protected var _nParticlesRest : Number;

		public function ByRateEmission( type : Class, emitter : Emitter = null, rate : Number = 1 )
		{
			super(type, emitter);
			
			this.rate = rate;
			_nTimeRest = 0;
			_nParticlesRest = 0;
		}
		override public function clone () : * { return new ByRateEmission ( _particleType, _emitter, _nRate ); }
        
		public override function isFinish() : Boolean { return false; }
		public override function nextTime() : Number { return ( _nParticlesRest - 1 ) * _nTimeStep;	}
		public override function hasNext() : Boolean { return _nParticlesRest > 0; }
		
		public override function prepareEmission( bias : Number, biasInSecond : Number, time : Number ) : void
		{
			var t : Number = _nTimeRest + bias;
			_nParticlesRest = ( t - ( _nTimeRest = ( t % _nTimeStep ) ) ) / _nTimeStep;
		}
		public override function next() : *
		{
			_nParticlesRest--;
			return super.next();			
		}
        public function get rate() : Number { return _nRate; }
		public function set rate( rate : Number ) : void 
        { 
            if( isNaN ( rate ) || rate <= 0 ) rate = 1;
			
			_nRate = rate;	
			_nTimeStep = 1000/_nRate;
		}
        override protected function getSourceArguments () : String
        {
            return [ getQualifiedClassName(_particleType).replace("::", "."), _emitter.toSource(), _nRate ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ getQualifiedClassName(_particleType), _emitter.toReflectionSource(), _nRate ].join(", ");
        }
	}
}