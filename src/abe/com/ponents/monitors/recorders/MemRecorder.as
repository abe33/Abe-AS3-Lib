package abe.com.ponents.monitors.recorders 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Range;
	import abe.com.patibility.lang._;
	import abe.com.ponents.monitors.GraphCurveSettings;

	import flash.system.System;
	import flash.utils.setInterval;
	/**
	 * @author Cédric Néhémie
	 */
	public class MemRecorder implements Recorder
	{
		static public const FREE : uint = 0;		static public const PRIVATE : uint = 1;		static public const TOTAL : uint = 2;
		
		protected var _values : Array;
		protected var _curveSettings : GraphCurveSettings;
		protected var _valuesRange : Range;
		protected var _memType : uint;
		protected var _interval : uint;
		
		static protected var INITIAL_MEM : uint;
		
		static public function registerMem () : void
		{
			INITIAL_MEM = System.totalMemory;
		}

		public function MemRecorder ( valuesRange : Range = null, curveSettings : GraphCurveSettings = null, memType : uint = 2 )
		{
			_interval = setInterval( rec, 500 );
			this._valuesRange = valuesRange != null ? valuesRange : new Range(0,10);
			this._curveSettings = curveSettings != null ? 
									curveSettings : 
									new GraphCurveSettings( getLabel(memType), 
															getColor(memType), 
															0 );
			this._memType = memType;
			this._values = new Array( );
		}
		
		private function getColor (memType : uint) : Color
		{
			switch(memType)
			{
				case FREE : 
					return Color.RoyalBlue;
				case PRIVATE : 
					return Color.DarkBlue;
				case TOTAL : 
				default : 
					return Color.Blue;
			}
		}

		private function getLabel ( memType : uint ) : String
		{
			switch(memType)
			{
				case FREE : 
					return _("Free Memory");
				case PRIVATE : 
					return _("Private Memory");
				case TOTAL : 
				default : 
					return _("Total Memory");
			}
		}

		public function rec() : void
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _values.push( Number(System.totalMemory) / ( 1024 * 1024 ) ); }
			TARGET::FLASH_10 {  _values.push( Number(System.totalMemory) / ( 1024 * 1024 ) ); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			switch(_memType)
			{
				case FREE : 
					_values.push( Number(System.freeMemory) / ( 1024 * 1024 ) );
					break;
				case PRIVATE :
					_values.push( Number(System.privateMemory) / ( 1024 * 1024 ) ); 
					break;
				case TOTAL :
				default : 
					_values.push( Number(System.totalMemory) / ( 1024 * 1024 ) ); 
					break;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			if( _values.length > 100 )
				_values.shift();
		}
		public function get values () : Array { return _values; }
		
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
		public function get unit () : String { return "Mo"; }
		public function get currentValue () : Number { return Math.round( _values[_values.length-1] * 100 ) / 100; }
	}
}
