package abe.com.edia.particles.recorders
{
    import abe.com.edia.particles.core.ParticleManager;
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Range;
    import abe.com.mon.utils.arrays.lastIn;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.patibility.lang._;
    import abe.com.ponents.monitors.GraphCurveSettings;
    import abe.com.ponents.monitors.recorders.Recorder;

    /**
     * @author cedric
     */
    public class ParticleRecorder implements Recorder, ImpulseListener
    {
        protected var _values : Array;
		protected var _curveSettings : GraphCurveSettings;
		protected var _valuesRange : Range;
        protected var _manager : ParticleManager;
        
        public function ParticleRecorder ( manager : ParticleManager, valuesRange : Range = null, curveSettings : GraphCurveSettings = null )
        {
            _manager = manager;
            Impulse.register( tick );
			
			this._values = new Array();
			this._valuesRange = valuesRange ? valuesRange : new Range(0,1000);
			this._curveSettings = curveSettings ? 
										curveSettings : 
										new GraphCurveSettings( _("Particles"), Color.Crimson, 0 );
        }
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
        public function get values () : Array { return _values; }
        public function get currentValue () : Number { return lastIn(_values); }
        public function get unit () : String { return _("particles"); }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            _values.push( _manager.particles.length );
            
            if( _values.length > 100 )
				_values.shift();
        }
    }
}
