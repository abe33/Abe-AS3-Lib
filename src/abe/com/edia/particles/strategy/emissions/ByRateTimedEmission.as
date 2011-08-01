package abe.com.edia.particles.strategy.emissions
{
    import abe.com.edia.particles.emitters.Emitter;
    import flash.utils.getTimer;


	/**
	 * Emits particles since and during a specific time according to a fixed generation rate.
	 * 
	 * @author Cédric Néhémie
     */
    public class ByRateTimedEmission extends ByRateEmission
	{
		public static const INFINITE : Number = Number.POSITIVE_INFINITY;
		
		protected var _nEmissionDuration : Number;
		protected var _nEmitSince : Number;
		protected var _nElapsedTime : Number;

        public function ByRateTimedEmission ( type : Class, 
        									  emitter : Emitter = null, 
                                              rate : Number = 1, 
                                              duration : Number = 0, 
                                              since : uint = 0 )
		{
			super(type, emitter, rate);
			
			_nEmissionDuration = checkTime( duration );
			_nEmitSince = since;
			_nElapsedTime = 0;
			
			prepareEmission( _nEmitSince, _nEmitSince/1000, getTimer() );			
		}
		
		public override function prepareEmission( bias : Number, biasInSecond : Number, time : Number ) : void
		{
			_nElapsedTime += bias;
			super.prepareEmission( bias, biasInSecond, time );
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
			return new ByRateTimedEmission ( _particleType, _emitter, _nRate, _nEmissionDuration, _nEmitSince );
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