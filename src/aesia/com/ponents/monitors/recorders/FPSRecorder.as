package aesia.com.ponents.monitors.recorders 
{
	import aesia.com.motion.ImpulseListener;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.utils.Color;
	import aesia.com.motion.Impulse;
	import aesia.com.motion.ImpulseEvent;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.monitors.GraphCurveSettings;

	import flash.utils.getTimer;

	/**
	 * @author Cédric Néhémie
	 */
	public class FPSRecorder implements Recorder, ImpulseListener
	{
		protected var _values : Array;
		protected var _lastTimer : Number;
		protected var _curveSettings : GraphCurveSettings;
		protected var _valuesRange : Range;
		
		public function FPSRecorder ( valuesRange : Range = null, curveSettings : GraphCurveSettings = null )
		{
			Impulse.register( tick );
			
			this._lastTimer = getTimer();
			this._values = new Array();
			this._valuesRange = valuesRange ? valuesRange : new Range(0,60);
			this._curveSettings = curveSettings ? 
										curveSettings : 
										new GraphCurveSettings( _("FPS"), Color.DarkOrange, 0 );
		}
		public function tick( e : ImpulseEvent ) : void
		{
			var t : Number = e.bias;
				
			_values.push( Math.round( 1000 / t ) );
			
			if( _values.length > 100 )
				_values.shift();
				
			_lastTimer = getTimer();
		}
		public function get values () : Array { return _values;	}
		
		public function get curveSettings () : GraphCurveSettings { return _curveSettings; }		
		public function set curveSettings (curveSettings : GraphCurveSettings) : void 
		{ 
			_curveSettings = curveSettings; 
		}
		
		public function get valuesRange () : Range { return _valuesRange; }		
		public function set valuesRange (valuesRange : Range) : void
		{
			_valuesRange = valuesRange;
		}
		public function get currentValue () : Number { return _values[_values.length - 1]; }
		
		public function get unit () : String { return "fps"; }
	}
}
