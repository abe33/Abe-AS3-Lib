package abe.com.ponents.monitors.recorders 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Range;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.motion.MotionImpulse;
    import abe.com.patibility.lang._;
    import abe.com.ponents.monitors.GraphCurveSettings;

    import flash.utils.getTimer;
	/**
	 * @author Cédric Néhémie
	 */
	public class ImpulseListenerRecorder implements Recorder, ImpulseListener
	{
		protected var _values : Array;
		protected var _lastTimer : Number;
		protected var _curveSettings : GraphCurveSettings;
		protected var _valuesRange : Range;
		protected var _impulse : MotionImpulse;
	
		public function ImpulseListenerRecorder ( o : MotionImpulse, valuesRange : Range = null, curveSettings : GraphCurveSettings = null )
		{
			Impulse.register( tick );
			this._impulse = o;
			this._lastTimer = getTimer();
			this._values = new Array();
			this._valuesRange = valuesRange ? valuesRange : new Range(0,200);
			this._curveSettings = curveSettings ? 
										curveSettings : 
										new GraphCurveSettings( _("Impulse Listeners"), Color.OliveDrab, 0 );
		}
		
		public function get valuesRange () : Range { return _valuesRange; }
		public function get curveSettings () : GraphCurveSettings { return _curveSettings; }
		public function get values () : Array { return _values; }
		public function get currentValue () : Number { return _values[_values.length-1]; }
		
		public function get unit () : String { return "obj"; }
		
		public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number) : void
		{
			_values.push( _impulse.listenersCount );
			
			if( _values.length > 100 )
				_values.shift();
		}
	}
}
