package aesia.com.ponents.monitors.recorders 
{
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.utils.Color;
	import aesia.com.motion.Impulse;
	import aesia.com.motion.ImpulseEvent;
	import aesia.com.motion.ImpulseListener;
	import aesia.com.motion.MotionImpulse;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.monitors.GraphCurveSettings;

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
		
		public function tick (e : ImpulseEvent) : void
		{
			_values.push( _impulse.listenersCount );
			
			if( _values.length > 100 )
				_values.shift();
		}
	}
}
