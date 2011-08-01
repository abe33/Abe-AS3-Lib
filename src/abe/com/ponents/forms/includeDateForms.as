package abe.com.ponents.forms
{
    import abe.com.mon.utils.TimeDelta;

    import flash.utils.getQualifiedClassName;
    /**
     * @author cedric
     */
    public function includeDateForms () : void
    {
        
        FormUtils.addTypeMapFunction( FormFieldsType.DATE_SPINNER, getDateSpinner)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.DATE_CALENDAR, getDateCalendar)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Date), getDateCalendar)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.TIME_DELTA, getTimeDelta)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(TimeDelta), getTimeDelta)  ;
    }
}
import abe.com.mon.utils.TimeDelta;
import abe.com.ponents.buttons.DatePicker;
import abe.com.ponents.buttons.TimeDeltaPicker;
import abe.com.ponents.models.SpinnerDateModel;
import abe.com.ponents.spinners.Spinner;
internal function getDateSpinner ( d : Date, args : Object ) : Spinner
{
	var min : Date;
	var max : Date;
	if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	return new Spinner( new SpinnerDateModel(d, min, max ) );
}
internal function getDateCalendar ( d : Date, args : Object ) : DatePicker
{
	return new DatePicker(d);
}
internal function getTimeDelta ( d : TimeDelta, args : Object ) : TimeDeltaPicker
{
	return new TimeDeltaPicker(d);
}
