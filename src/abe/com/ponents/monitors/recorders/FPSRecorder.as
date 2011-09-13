package abe.com.ponents.monitors.recorders 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Range;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.patibility.lang._;
    import abe.com.ponents.monitors.GraphCurveSettings;

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
		public function tick( bias : Number, biasInSeconds : Number, currentTime : Number) : void
		{
			var t : Number = bias;
				
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
