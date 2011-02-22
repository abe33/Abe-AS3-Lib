package abe.com.ponents.monitors.recorders 
{
	import abe.com.mon.core.impl.AllocatorImpl;
	import abe.com.mon.geom.Range;
	import abe.com.mon.utils.Color;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.monitors.GraphCurveSettings;

	import flash.utils.setInterval;

	/**
	 * @author Cédric Néhémie
	 */
	public class AllocatorRecorder implements Recorder 
	{
		static public const ALL_INSTANCES : uint = 0;		static public const UNUSED_INSTANCES : uint = 1;		static public const USED_INSTANCES : uint = 2;
		
		protected var _valuesRange : Range;
		protected var _curveSettings : GraphCurveSettings;
		protected var _values : Array;
		protected var _unit : String;
		protected var _allocator : AllocatorImpl;
		protected var _class : Class;
		protected var _mode : uint;
		protected var _interval : uint;

		public function AllocatorRecorder ( allocator : AllocatorImpl = null,
											cl : Class = null,
											mode : uint = 0,
											valuesRange : Range = null,
											curveColor : Color = null )
		{
			_interval = setInterval( rec, 250 );
			_mode = mode;
			_class = cl;
			_allocator = allocator;
			_class = cl;
			_valuesRange = valuesRange != null ? valuesRange : new Range(0,100);
			_unit = "obj";
			if( !curveColor )
				curveColor=Color.Crimson;
			var s : String;
			switch( _mode )
			{
				case UNUSED_INSTANCES : 
					s = _class != null ?
						_$(_("All unused $0"), _class):
						_("All unused objects");
					break;
				case USED_INSTANCES : 
					s = _class != null ?
						_$(_("All used $0"), _class):
						_("All used objects");
					break;
				case ALL_INSTANCES : 
				default : 
					s = _class != null ?
						_$(_("All allocated $0"), _class):
						_("All allocated objects");
					break;
			}
			_curveSettings = new GraphCurveSettings( s,
													 curveColor, 
													 0 );
			_values = new Array( );
		}
		
		protected function rec () : void
		{
			switch( _mode )
			{
				case USED_INSTANCES : 
					_values.push( _allocator.getUsedObjectsCount( _class ) );
					break;
				case UNUSED_INSTANCES : 
					_values.push( _allocator.getUnusedObjectsCount( _class ) );
					break;
				case ALL_INSTANCES : 
					_values.push( _allocator.getTotalAllocated( _class ) );
					break;
			}
			if( _values.length > 100 )
				_values.shift();
		}

		public function get valuesRange () : Range { return _valuesRange; }
		public function set valuesRange (valuesRange : Range) : void
		{
			_valuesRange = valuesRange;
		}
		
		public function get curveSettings () : GraphCurveSettings { return _curveSettings; }
		public function set curveSettings (curveSettings : GraphCurveSettings) : void
		{
			_curveSettings = curveSettings;
		}
		
		public function get values () : Array { return _values; }
		
		public function get currentValue () : Number
		{
			return _values[_values.length-1];
		}
		public function get unit () : String { return _unit; }		
		public function set unit (unit : String) : void
		{
			_unit = unit;
		}
	}
}
