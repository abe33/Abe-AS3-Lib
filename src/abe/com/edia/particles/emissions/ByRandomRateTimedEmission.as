package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.emitters.Emitter;

    import flash.utils.getTimer;

	/**
	 * Emits particles since and during a specific time according to a fixed generation rate.
	 * 
	 * @author Cédric Néhémie
     */
    public class ByRandomRateTimedEmission extends ByRandomRateEmission
	{
		public static const INFINITE : Number = Number.POSITIVE_INFINITY;
		
		protected var _nEmissionDuration : Number;
		protected var _nEmitSince : Number;
		protected var _nElapsedTime : Number;

        public function ByRandomRateTimedEmission ( type : Class, 
        											emitter : Emitter = null, 
                                                    rateMin : Number = 1, 
                                                    rateMax : Number = 2, 
                                                    duration : Number = 0, 
                                                    since : uint = 0 )
		{
			super(type, emitter, rateMin, rateMax );
			
			_nEmissionDuration = checkTime( duration );
			_nEmitSince = since;
			_nElapsedTime = 0;
			
			prepare( _nEmitSince, _nEmitSince/1000, getTimer() );			
		}
		public override function prepare( bias: Number, biasInSecond : Number, time : Number ) : void
		{
			_nElapsedTime += time;
			super.prepare( bias, biasInSecond, time );
		}
		
		public override function isFinish() : Boolean
		{
			return _nElapsedTime >= _nEmissionDuration;
		}
		
		public override function hasNext() : Boolean
		{
			return super.hasNext();
		}
		public override function clone () : *
		{
			return new ByRandomRateTimedEmission ( _particleType, _emitter, _nRate, _nEmissionDuration, _nEmitSince );
		}
		public function checkTime ( n : Number ) : Number
		{
			if( isNaN ( n ) || n < 0 )
				return 0;
			
			return n;
        }
		public function get duration () : Number { return _nEmissionDuration; }
		public function get elapsed () : Number { return _nElapsedTime; }
        
        override protected function getSourceArguments () : String
        {
            return super.getSourceArguments() + "," + [ _nEmissionDuration, _nEmitSince ].join(",");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return super.getReflectionSourceArguments() + "," + [ _nEmissionDuration, _nEmitSince ].join(",");
        }
	}
}