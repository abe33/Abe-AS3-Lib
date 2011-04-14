package abe.com.mands.load 
{
	import org.osflash.signals.Signal;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;

	public class AbstractLoaderEstimator implements Estimator
	{
		protected var _time : Number;
		protected var _rate : Number;
		protected var _remain : Number;
		protected var _lastBytesLoaded : Number;	
		protected var _rates : Array;
		protected var _rateSmoothness : Number;
		protected var _ratesSum : Number;
		protected var _remains : Array;
		protected var _remainSmoothness : Number;
		protected var _remainsSum : Number;
		protected var _double : Boolean;
		protected var _available : Boolean;
		protected var _startTime : Number;
		
		protected var _estimationsAvailable : Signal;		protected var _estimationsProgressed : Signal;
		
		public function AbstractLoaderEstimator (  rateSmoothness : Number = 10,
									 	  			remainSmoothness : Number = 1 )
		{
			_rateSmoothness = rateSmoothness;
			_remainSmoothness = remainSmoothness;
			_estimationsAvailable = new Signal(Number, Number);			_estimationsProgressed = new Signal(Number, Number);
			reset();
		}
		public function get estimationsAvailable () : Signal { return _estimationsAvailable; }
		public function get estimationsProgressed () : Signal { return _estimationsProgressed; }
		
		public function reset() : void
		{
			_ratesSum = 0;
			_rates = [];
			_remainsSum = 0;
			_remains = [];
			_lastBytesLoaded = 0;
			_double = false;
			_available = false;
		}
		protected function open ( e : Event ) : void
		{
			_startTime = _time = getTimer();
		}
		protected function progress ( e : ProgressEvent ) : void
		{
			// cas particulier : on recoit deux fois l'event avec les mêmes données
			if( e.bytesLoaded == _lastBytesLoaded && !_double  )
			{
				_double = true;
				return;
			}
			
			var bytesLoaded : Number = e.bytesLoaded;
			var bytesTotal : Number = e.bytesTotal;
			var time : Number = getTimer();			
			var timeGap : Number = time - _time;
			var bytesGap : Number = bytesLoaded - _lastBytesLoaded;	
			var rate : Number = bytesGap / timeGap * 100;
			
			// on calcule le taux de téléchargement, en fonction 
			// du paramètre de lissage correspondant.
			_rates.push( rate );
			_ratesSum += rate;
			
			if( _rates.length > _rateSmoothness )
			{
				_ratesSum -= _rates.shift();
			}
			_rate = _ratesSum / _rates.length;
			
			// on calcule l'estimation du temps restant, en fonction
			// du parametre de lissage correspondant
			var remain : Number = ( bytesTotal - bytesLoaded ) / _rate;

			_remains.push( remain );
			_remainsSum += remain;
			
			if( _remains.length > _remainSmoothness )
			{
				_remainsSum -= _remains.shift();
			}	
			_remain = _remainsSum / _remains.length;
			
			// 
			_time = time;
			_lastBytesLoaded = bytesLoaded;
			_double = false;
			
			if( !_available )
			{
				_available = true;
				_estimationsAvailable.dispatch( _rate, _remain );
			}
			
			if( _available )
				_estimationsProgressed.dispatch( _rate, _remain );
		}
		protected function complete ( e : Event ) : void
		{
			reset();
		}
	}
}
