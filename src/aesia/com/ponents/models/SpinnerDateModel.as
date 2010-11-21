package aesia.com.ponents.models 
{
	import aesia.com.mon.utils.DateUtils;

	/**
	 * @author Cédric Néhémie
	 */
	public class SpinnerDateModel extends AbstractSpinnerModel 
	{
		protected var _value : Date;
		protected var _startDate : Date;
		protected var _endDate : Date;
		protected var _formatFunction : Function;
		protected var _calendarField : uint;

		public function SpinnerDateModel ( date : Date = null, start : Date = null, end : Date = null, calendarField : uint = 3 )
		{
			_value = date ? date : new Date();
			_startDate = start;
			_endDate = end;
			_calendarField = calendarField;
			_formatFunction = format;
		}

		override public function get displayValue () : String { return _formatFunction( _value ); }

		override public function get value () : * { return _value; }		override public function set value (v : *) : void
		{
			if( v is Date )
			{
				var d : Date = v as Date;
				if( ( !_startDate || !DateUtils.isPastDate( d, _startDate ) ) && 
					( !_endDate   || !DateUtils.isFutureDate( d, _endDate ) ) )
				{
					_value = d;
					fireDataChange();
				}
			}
		}
		public function get startDate () : Date {	return _startDate; }		
		public function set startDate (startDate : Date) : void
		{
			_startDate = startDate;
		}
		public function get endDate () : Date { return _endDate; }		
		public function set endDate (endDate : Date) : void
		{
			_endDate = endDate;
		}
		public function get calendarField () : uint { return _calendarField; }
		public function set calendarField (calendarField : uint) : void 
		{ 
			_calendarField = calendarField;
		}
		
		public function get formatFunction () : Function { return _formatFunction; }		
		public function set formatFunction (formatFunction : Function) : void
		{
			_formatFunction = formatFunction;
		}
		override public function getNextValue () : *
		{
			var n : Date = _nextValue();
			if( _endDate && DateUtils.isFutureDate( n, _endDate ) )
				return _endDate;
			else		
				return n;
		}
		override public function getPreviousValue () : *
		{
			var n : Date = _previousValue();
			if( _startDate && DateUtils.isPastDate( n, _startDate ) )
				return _startDate;
			else		
				return n;
		}
		protected function _nextValue () : Date
		{
			var n : Date;
			
			switch( _calendarField )
			{
				case SpinnerDateModelFields.YEAR : 
					n = DateUtils.oneYearLater( _value );
					break;
				case SpinnerDateModelFields.MONTH : 
					n = DateUtils.oneMonthLater( _value );
					break;
				case SpinnerDateModelFields.WEEK : 
					n = DateUtils.getFutureDateAt( _value, 7 );
					break;
				case SpinnerDateModelFields.DAY :
				default : 
					n = DateUtils.getDayAfter(_value);
					break;
				case SpinnerDateModelFields.HOUR : 
					n = DateUtils.getTimeAfter( _value,	DateUtils.MILLISECONDS_IN_HOUR );
					break;
				case SpinnerDateModelFields.MINUTE : 
					n = DateUtils.getTimeAfter( _value,	DateUtils.MILLISECONDS_IN_MINUTE );
					break;
				case SpinnerDateModelFields.SECOND : 
					n = DateUtils.getTimeAfter( _value,	DateUtils.MILLISECONDS_IN_SECOND );
					break;
				case SpinnerDateModelFields.MILLISECOND : 
					n = DateUtils.getTimeAfter( _value,	1 );
					break;
			}
			
			return n;
		}
		protected function _previousValue () : Date
		{
			var n : Date;
			
			switch( _calendarField )
			{
				case SpinnerDateModelFields.YEAR : 
					n = DateUtils.oneYearBefore( _value );
					break;
				case SpinnerDateModelFields.MONTH : 
					n = DateUtils.oneMonthBefore( _value );
					break;
				case SpinnerDateModelFields.WEEK : 
					n = DateUtils.getPastDateAt( _value, 7 );
					break;
				case SpinnerDateModelFields.DAY :
				default : 
					n = DateUtils.getDayBefore(_value);
					break;
				case SpinnerDateModelFields.HOUR : 
					n = DateUtils.getTimeBefore( _value, DateUtils.MILLISECONDS_IN_HOUR );
					break;
				case SpinnerDateModelFields.MINUTE : 
					n = DateUtils.getTimeBefore( _value, DateUtils.MILLISECONDS_IN_MINUTE );
					break;
				case SpinnerDateModelFields.SECOND : 
					n = DateUtils.getTimeBefore( _value, DateUtils.MILLISECONDS_IN_SECOND );
					break;
				case SpinnerDateModelFields.MILLISECOND : 
					n = DateUtils.getTimeBefore( _value, 1 );
					break;
			}
			
			return n;
		}
		override public function hasNextValue () : Boolean
		{
			return !( _endDate && DateUtils.isFutureDate( _nextValue(), _endDate ) );
		}
		override public function hasPreviousValue () : Boolean
		{
			return !( _startDate && DateUtils.isFutureDate( _nextValue(), _startDate ) );
		}
		protected function format ( d : Date ) : String
		{
			return  DateUtils.format( d, "m/d/Y" );
		}
	}
}
