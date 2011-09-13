/**
 * @license
 */
package abe.com.mon.utils 
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Copyable;
    import abe.com.mon.core.Equatable;
    import abe.com.mon.core.FormMetaProvider;
    import abe.com.mon.core.Serializable;

    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
	/**
	 * Represents an interval of time 
	 */ 
    [Serialize(constructorArgs="start,end")]    
	public class TimeDelta implements IExternalizable, FormMetaProvider, Copyable, Cloneable, Serializable, Equatable
	{
/*----------------------------------------------------------------------*
 * CLASS MEMBERS
 *----------------------------------------------------------------------*/
		/**
		 * Creates a TimeDelta from the different between two dates
		 * 
		 * Note that start can be after end, but it will result in negative values. 
		 *  
		 * @param start The start date of the timedelta
		 * @param end The end date of the timedelta
		 * @return A TimeDelta that represents the difference between the dates
		 * 
		 */             
		public static function fromDates (start : Date, end : Date) : TimeDelta
		{
			return new TimeDelta( end.time - start.time );
		}
		/**
		 * Creates a TimeDelta from the specified number of milliseconds
		 * @param milliseconds The number of milliseconds in the timedelta
		 * @return A TimeDelta that represents the specified value
		 */             
		public static function fromMilliseconds (milliseconds : int) : TimeDelta
		{
			return new TimeDelta( milliseconds );
		}
		/**
		 * Creates a TimeDelta from the specified number of seconds
		 * @param seconds The number of seconds in the timedelta
		 * @return A TimeDelta that represents the specified value
		 */     
		public static function fromSeconds (seconds : int) : TimeDelta
		{
			return new TimeDelta( seconds * DateUtils.MILLISECONDS_IN_SECOND );
		}
		/**
		 * Creates a TimeDelta from the specified number of minutes
		 * @param minutes The number of minutes in the timedelta
		 * @return A TimeDelta that represents the specified value
		 */     
		public static function fromMinutes (minutes : int) : TimeDelta
		{
			return new TimeDelta( minutes * DateUtils.MILLISECONDS_IN_MINUTE );
		}
		/**
		 * Creates a TimeDelta from the specified number of hours
		 * @param hours The number of hours in the timedelta
		 * @return A TimeDelta that represents the specified value
		 */     
		public static function fromHours (hours : int) : TimeDelta
		{
			return new TimeDelta( hours * DateUtils.MILLISECONDS_IN_HOUR );
		}
		/**
		 * Creates a TimeDelta from the specified number of days
		 * @param days The number of days in the timedelta
		 * @return A TimeDelta that represents the specified value
		 */     
		public static function fromDays (days : int) : TimeDelta
		{
			return new TimeDelta( days * DateUtils.MILLISECONDS_IN_DAY );
		}
/*----------------------------------------------------------------------*
 * INSTANCE MEMBERS
 *----------------------------------------------------------------------*/
		private var _totalMilliseconds : int;

		public function TimeDelta ( milliseconds : int = 1 )
		{
			_totalMilliseconds = Math.floor( milliseconds );
		}
		/**
		 * Gets the number of whole days
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromHours(25), 
		 *                      totalHours will be 1.04, but hours will be 1 
		 * @return A number representing the number of whole days in the TimeDelta
		 */
		[Form(type="intSpinner",label="Days", order="0")]
		public function get days () : int { return int( _totalMilliseconds / DateUtils.MILLISECONDS_IN_DAY ); }
		public function set days ( d : int ) : void {_totalMilliseconds += ( d - days ) * DateUtils.MILLISECONDS_IN_DAY; }
		/**
		 * Gets the number of whole hours (excluding entire days)
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMinutes(1500), 
		 *                      totalHours will be 25, but hours will be 1 
		 * @return A number representing the number of whole hours in the TimeDelta
		 */
		[Form(type="intSpinner",label="Hours", order="1")]
		public function get hours () : int { return int( _totalMilliseconds / DateUtils.MILLISECONDS_IN_HOUR ) % 24; }
		public function set hours ( h : int ) : void { _totalMilliseconds += ( h - hours ) * DateUtils.MILLISECONDS_IN_HOUR; }
		/**
		 * Gets the number of whole minutes (excluding entire hours)
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMilliseconds(65500), 
		 *                      totalSeconds will be 65.5, but seconds will be 5 
		 * @return A number representing the number of whole minutes in the TimeDelta
		 */
		[Form(type="intSpinner",label="Minutes", order="2")]
		public function get minutes () : int { return int( _totalMilliseconds / DateUtils.MILLISECONDS_IN_MINUTE ) % 60; }
		public function set minutes( m : int ) : void { _totalMilliseconds += ( m - minutes ) * DateUtils.MILLISECONDS_IN_MINUTE; }
		/**
		 * Gets the number of whole seconds (excluding entire minutes)
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMilliseconds(65500), 
		 *                      totalSeconds will be 65.5, but seconds will be 5 
		 * @return A number representing the number of whole seconds in the TimeDelta
		 */
		[Form(type="intSpinner",label="Seconds", order="3")]
		public function get seconds () : int { return int( _totalMilliseconds / DateUtils.MILLISECONDS_IN_SECOND ) % 60; }
		public function set seconds( m : int ) : void { _totalMilliseconds += ( m - seconds ) * DateUtils.MILLISECONDS_IN_SECOND; }
		/**
		 * Gets the number of whole milliseconds (excluding entire seconds)
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMilliseconds(2123), 
		 *                      totalMilliseconds will be 2001, but milliseconds will be 123 
		 * @return A number representing the number of whole milliseconds in the TimeDelta
		 */
		public function get milliseconds () : int { return int( _totalMilliseconds ) % 1000; }		public function set milliseconds ( n : int ) : void { _totalMilliseconds = n; }
		/**
		 * Gets the total number of days.
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromHours(25), 
		 *                      totalHours will be 1.04, but hours will be 1 
		 * @return A number representing the total number of days in the TimeDelta
		 */
		public function get totalDays () : Number { return _totalMilliseconds / DateUtils.MILLISECONDS_IN_DAY; }
		/**
		 * Gets the total number of hours.
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMinutes(1500), 
		 *                      totalHours will be 25, but hours will be 1 
		 * @return A number representing the total number of hours in the TimeDelta
		 */
		public function get totalHours () : Number { return _totalMilliseconds / DateUtils.MILLISECONDS_IN_HOUR; }
		/**
		 * Gets the total number of minutes.
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMilliseconds(65500), 
		 *                      totalSeconds will be 65.5, but seconds will be 5 
		 * @return A number representing the total number of minutes in the TimeDelta
		 */
		public function get totalMinutes () : Number { return _totalMilliseconds / DateUtils.MILLISECONDS_IN_MINUTE; }
		/**
		 * Gets the total number of seconds.
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMilliseconds(65500), 
		 *                      totalSeconds will be 65.5, but seconds will be 5 
		 * @return A number representing the total number of seconds in the TimeDelta
		 */
		public function get totalSeconds () : Number { return _totalMilliseconds / DateUtils.MILLISECONDS_IN_SECOND; }
		/**
		 * Gets the total number of milliseconds.
		 * 
		 * @example In a TimeDelta created from TimeDelta.fromMilliseconds(2123), 
		 *                      totalMilliseconds will be 2001, but milliseconds will be 123 
		 * @return A number representing the total number of milliseconds in the TimeDelta
		 */
		public function get totalMilliseconds () : Number { return _totalMilliseconds; }
		/**
		 * Adds the timedelta represented by this instance to the date provided and returns a new date object.
		 * @param date The date to add the timedelta to
		 * @return A new Date with the offseted time
		 */             
		public function add (date : Date) : Date
		{
			var ret : Date = new Date( date.time );
			ret.milliseconds += totalMilliseconds;

			return ret;
		}
		/**
		 * Subtract the timedelta represented by this instance to the date provided and returns a new date object.
		 * @param date The date to subtract the timedelta from
		 * @return A new Date with the offseted time
		 */
		public function subtract( date : Date ) : Date
		{
			var ret : Date = new Date( date.time );
			ret.milliseconds -= totalMilliseconds;
			
			return ret;
		}
		public function equals (o : *) : Boolean
		{
			if( o is TimeDelta )
				return (o as TimeDelta).totalMilliseconds == _totalMilliseconds; 
			else
				return false;
		}
		
		public function clone () : * { return new TimeDelta( _totalMilliseconds ); }
		public function copyTo (o : Object) : void { o.milliseconds = _totalMilliseconds; }
		public function copyFrom (o : Object) : void { _totalMilliseconds = o.totalMilliseconds; }
		
		public function writeExternal (output : IDataOutput) : void { output.writeInt( _totalMilliseconds ); }
		public function readExternal (input : IDataInput) : void { _totalMilliseconds = input.readInt(); }
		
		public function toString() : String { return StringUtils.stringify( this, {'days':days, 'hours':hours, 'minutes':minutes, 'seconds':seconds } ) ; }
		
	}
}
