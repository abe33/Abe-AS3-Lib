package abe.com.ponents.forms
{
    import flash.geom.Rectangle;
    import abe.com.mon.geom.Dimension;

    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;
    /**
     * @author cedric
     */
    public function includeGeometryForms () : void
    {
		FormUtils.addTypeMapFunction( FormFieldsType.DIMENSION_INT, getDimensionInt)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.DIMENSION_UINT, getDimensionUint)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.DIMENSION_FLOAT, getDimensionFloat)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Dimension), getDimensionFloat)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.POINT_INT, getPointInt)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.POINT_UINT, getPointUint)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.POINT_FLOAT, getPointFloat)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Point), getPointFloat)  ;
        
        FormUtils.addTypeMapFunction( FormFieldsType.RECTANGLE_INT, getRectangleInt )  ;
		FormUtils.addTypeMapFunction( FormFieldsType.RECTANGLE_FLOAT, getRectangleFloat )  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Rectangle), getRectangleFloat)  ;
    }
}
import abe.com.mon.geom.Dimension;
import abe.com.ponents.forms.fields.RectangleFormComponent;
import abe.com.ponents.spinners.DoubleSpinner;

import flash.geom.Point;
import flash.geom.Rectangle;
internal  function getDimensionInt ( v : Dimension, args : Object ) : *
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	else
	{
		min = int.MIN_VALUE;
		max = int.MAX_VALUE;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}	
	return new DoubleSpinner( v, "width", "height", min, max, step, true );
}
internal  function getDimensionUint ( v : Dimension, args : Object ) : *
{
	var min : uint;
	var max : uint;
	var step : uint;
	
	if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	else
	{
		min = uint.MIN_VALUE;
		max = uint.MAX_VALUE;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}	
	return new DoubleSpinner( v, "width", "height", min, max, step, true );
}
internal  function getDimensionFloat ( v : Dimension, args : Object ) : *
{
	var min : Number;
	var max : Number;
	var step : Number;
	
	if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	else
	{
		min = Number.NEGATIVE_INFINITY;
		max = Number.POSITIVE_INFINITY;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}	
	return new DoubleSpinner( v, "width", "height", min, max, step );
}
internal  function getPointInt ( v : Point, args : Object ) : *
{
	var min : int;
	var max : int;
	var step : int;
	
	if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	else
	{
		min = int.MIN_VALUE;
		max = int.MAX_VALUE;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}	
	return new DoubleSpinner( v, "x", "y", min, max, step, true );
}
internal  function getPointUint ( v : Point, args : Object ) : *
{
	var min : uint;
	var max : uint;
	var step : uint;
	
	if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	else
	{
		min = uint.MIN_VALUE;
		max = uint.MAX_VALUE;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}	
	return new DoubleSpinner( v, "x", "y", min, max, step, true );
}
internal function getPointFloat ( v : Point, args : Object ) : *
{
	var min : Number;
	var max : Number;
	var step : Number;
	
	if( args.hasOwnProperty( "range" ) && args.range is Array )
	{
		min = args.range[0];
		max = args.range[1];
	}
	else
	{
		min = Number.NEGATIVE_INFINITY;
		max = Number.POSITIVE_INFINITY;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}	
	return new DoubleSpinner( v, "x", "y", min, max, step );
}
internal function getRectangleFloat( v : Rectangle, args : Object ):*
{
    return new RectangleFormComponent( v );
}
internal function getRectangleInt( v : Rectangle, args : Object ):*
{
    return new RectangleFormComponent( v );
}

