package abe.com.patibility.humanize
{
    import abe.com.mon.utils.DateUtils;
    import abe.com.mon.utils.TimeDelta;
    import abe.com.patibility.lang._;
	/**
	 * @author cedric
	 */
	public function naturalday ( date : Date, format : String = "Y-m-d\TH:i:sP" ) : String 
	{
		var delta : TimeDelta = TimeDelta.fromDates( new Date(), date );
		
		if( delta.days == 0 )
			return _("today");
		else if( delta.days == 1 )
			return _("tomorrow");
		else if( delta.days == -1 )
			return _("yesterday");
		else
			return DateUtils.format( date, format);
	}
}
