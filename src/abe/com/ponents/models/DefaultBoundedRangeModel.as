package abe.com.ponents.models 
{
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.StringUtils;
	import abe.com.ponents.events.ComponentEvent;

    import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	public class DefaultBoundedRangeModel implements BoundedRangeModel 
	{
		protected var _value : Number;
		protected var _minimum : Number;
		protected var _maximum : Number;
		protected var _extent : Number;
		protected var _formatFunction : Function;
		
		protected var _dataChanged : Signal;

		public function DefaultBoundedRangeModel ( value : Number = 0, min : Number = 0, max : Number = 100, extent : Number = 1 )
		{
			_dataChanged = new Signal();
			
			_minimum = !isNaN(min) ? min : 0;
			_maximum = !isNaN(max) ? max : 100;
			_extent = !isNaN(extent) ? extent : 1;
			_formatFunction = format;
			this.value = !isNaN(value) ? value : 0;
		}
        public function get dataChanged() : Signal { return _dataChanged; }
		public function get displayValue () : String { return _formatFunction( _value ); }
		public function get value () : Number { return _value; }		
		public function set value (value : Number) : void
		{
			var v : Number = MathUtils.restrict( value, _minimum, _maximum );
			if( v != _value )
			{
				_value = v;
				fireDataChangedSignal();
			}
		}
		public function get minimum () : Number { return _minimum; }		
		public function set minimum (minimum : Number) : void
		{
			if( _minimum != minimum )
			{
				_minimum = minimum;
				value = value;
			}
		}
		public function get maximum () : Number { return _maximum; }		
		public function set maximum (maximum : Number) : void
		{
			if( _maximum != maximum )
			{
				_maximum = maximum;
				value = value;
			}
		}
		public function get extent () : Number { return _extent; }		
		public function set extent (extent : Number) : void
		{
			if( _extent != extent )
			{
				_extent = extent;
				fireDataChangedSignal();
			}
		}
		public function get formatFunction () : Function { return _formatFunction; }		
		public function set formatFunction (formatFunction : Function) : void
		{
			_formatFunction = formatFunction;
		}
		protected function fireDataChangedSignal () : void
		{
			_dataChanged.dispatch( this, value );
		}
		protected function format( v : Number ) : String
		{
			var sv : String = String( v );
				
			if( sv.indexOf( "." ) != -1 )
			{
				var a : Array = sv.split(".");
					
				if( a[1].length > 2 )
					a[1] = a[1].substr( 0, 2 );
				else
					a[1] = StringUtils.fill( a[1], 2 );
					
				return a.join(".");
			}
			else
			{
				return sv + "." + StringUtils.fill( "", 2 );
			}

			return null;
		}
		public function toString () : String
		{
			return StringUtils.stringify(this, {'min':_minimum,'max':_maximum,'value':_value});
		}
		public function get valuePositionInRange () : Number
		{
			return MathUtils.map(_value, _minimum, _maximum, 0, 1);
		}
	}
}
