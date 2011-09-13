package abe.com.patibility.humanize
{
    import abe.com.mon.utils.StringUtils;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
	/**
	 * @author cedric
	 */
	public function intword ( value : * ) : String 
	{
		if( value is String )
			value = parseInt( value );
		
		value = int(value);
		var new_value : Number;
		
	    if( value < 1000000 )
	        return String( value );
	    if ( value < 1000000000 )
	    {
	        new_value = value / 1000000.0;
	        return _$( "$0 $1", StringUtils.formatNumber( new_value, 1 ), plural( new_value, _("million"), _("millions") ) );
		}
	    if ( value < 1000000000000 )
	    {
	        new_value = value / 1000000000.0;
	        return _$( "$0 $1", StringUtils.formatNumber( new_value, 1 ), plural( new_value, _("billion"), _("billions") ) );
	    }
	    if ( value < 1000000000000000 ) 
	    {
	        new_value = value / 1000000000000.0;
	        return _$( "$0 $1", StringUtils.formatNumber( new_value, 1 ), plural( new_value, _("trillion"), _("trillions") ) );
	    }
	    return String( value );
	}
}
