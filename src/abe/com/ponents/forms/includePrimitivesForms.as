package abe.com.ponents.forms
{
    import flash.net.URLRequest;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;
    /**
     * @author cedric
     */
    public function includePrimitivesForms () : void
    {
        // AbeLib Defaults :
		FormUtils.addTypeMapFunction( FormFieldsType.INT_SLIDER, getIntSlider );
		FormUtils.addTypeMapFunction( FormFieldsType.INT_SPINNER, getIntSpinner) ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(int), getIntSpinner)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.UINT_SLIDER, getUintSlider);
		FormUtils.addTypeMapFunction( FormFieldsType.UINT_SPINNER, getUintSpinner);
		FormUtils.addTypeMapFunction( getQualifiedClassName(uint), getUintSpinner)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.FLOAT_SLIDER, getFloatSlider);
		FormUtils.addTypeMapFunction( FormFieldsType.FLOAT_SPINNER, getFloatSpinner);
		FormUtils.addTypeMapFunction( getQualifiedClassName(Number), getFloatSpinner)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.STRING, getString);
		FormUtils.addTypeMapFunction( getQualifiedClassName(String), getString)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.TEXT, getText)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.PASSWORD, getPassword);
		FormUtils.addTypeMapFunction( FormFieldsType.BOOLEAN, getBoolean);
		FormUtils.addTypeMapFunction( getQualifiedClassName(Boolean), getBoolean)  ;
		
        FormUtils.addTypeMapFunction( FormFieldsType.URL, getURLInput)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(URLRequest), getURLInput)  ;
        
        FormUtils.addTypeMapFunction( FormFieldsType.TEXT_FORMAT, getTextFormat)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(TextFormat), getTextFormat)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.ARRAY, getArray)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Array), getArray)  ;
    }
}
import abe.com.ponents.buttons.CheckBox;
import abe.com.ponents.core.Component;
import abe.com.ponents.forms.FormUtils;
import abe.com.ponents.lists.ListEditor;
import abe.com.ponents.menus.ComboBox;
import abe.com.ponents.models.DefaultBoundedRangeModel;
import abe.com.ponents.models.SpinnerNumberModel;
import abe.com.ponents.sliders.HSlider;
import abe.com.ponents.spinners.Spinner;
import abe.com.ponents.text.Label;
import abe.com.ponents.text.TextArea;
import abe.com.ponents.text.TextFormatEditor;
import abe.com.ponents.text.TextInput;
import abe.com.ponents.text.URLInput;

import flash.text.TextFormat;
import flash.utils.getQualifiedClassName;

internal function getIntSpinner ( v : int, args : Object ) : Spinner
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
	
	return new Spinner(new SpinnerNumberModel( v, min, max, step, true ) );
}
internal function getIntSlider ( v : int, args : Object ) : HSlider
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
	var model : DefaultBoundedRangeModel = new DefaultBoundedRangeModel( v, min, max, step );
	model.formatFunction = function ( v : * ) : String { return String(v); }	
	
	return new HSlider( model, 
						10, 
						step, 
						false, 
						true, 
						true, 
						!isNaN( min ) ? new Label(min.toString() ) : null, 
						!isNaN( max ) ? new Label(max.toString() ) : null );
}
internal function getUintSpinner ( v : uint, args : Object ) : Spinner
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
	
	return new Spinner( new SpinnerNumberModel( v, min, max, step, true ) );
}
internal function getUintSlider ( v : uint, args : Object ) : HSlider
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
		step = args.step;
	else
		step = 1;
		
	var model : DefaultBoundedRangeModel = new DefaultBoundedRangeModel( v, min, max, step );
	model.formatFunction = function ( v : * ) : String { return String(v); };
	return new HSlider( model, 
						10, 
						1, 
						false, 
						true, 
						true, 
						!isNaN( min ) ? new Label(min.toString() ) : null, 
						!isNaN( max ) ? new Label(max.toString() ) : null  );
}
internal function getFloatSpinner ( v : Number, args : Object ) : Spinner
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
	
	return new Spinner(new SpinnerNumberModel( v, min, max, step ) );
}
internal function getFloatSlider ( v : Number, args : Object ) : HSlider
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
		min = NaN;
		max = NaN;
	}
	if( args.hasOwnProperty( "step" ) )
	{
		step = args.step;
	}
	else
	{
		step = 1;
	}		
	
	return new HSlider( new DefaultBoundedRangeModel( v, min, max, step ), 
						10, 
						1, 
						false, 
						false, 
						true, 
						!isNaN( min ) ? new Label(min.toString() ) : null, 
						!isNaN( max ) ? new Label(max.toString() ) : null );
}
internal function getString ( v : String, args : Object ) : Component
{
	if( args.hasOwnProperty( "enumeration" ) )
	{
		var combobox : ComboBox = new ComboBox( args.enumeration );
		
		combobox.model.selectedElement = v;
		combobox.popupAlignOnSelection = true;
			
		return combobox;
	}
	else
	{
		var ti : TextInput = new TextInput( args.hasOwnProperty( "length" ) ? args.length : 0 );
		ti.value = v ? v : "";
		return ti;
	}
}
internal function getText ( v : String, args : Object ) : TextArea
{
	var ta : TextArea = new TextArea();

	ta.value = v ? v : "";
	
	return ta;
}
internal function getPassword ( v : String, args : Object ) : TextInput
{
	var ti : TextInput = new TextInput( args.hasOwnProperty( "length" ) ? args.length : 0, true );

	ti.value = v ? v : "";
	
	
	return ti;
}
internal function getBoolean ( v : Boolean, args : Object ) : CheckBox
{
	var c : CheckBox = new CheckBox("");
	c.checked = v;
	
	return c;
}
internal function getURLInput ( v : *, args : Object ) : *
{
	if( args.hasOwnProperty( "enumeration" ) )
	{
		var combobox : ComboBox = new ComboBox( args.enumeration );
		
		combobox.model.selectedElement = v;
		combobox.popupAlignOnSelection = true;
			
		return combobox;
	}
	else
	{
		var ti : URLInput = new URLInput( args.hasOwnProperty( "length" ) ? args.length : 0 );
		ti.value = v ? v : "";
		return ti;
	}
}
internal function getTextFormat ( v : TextFormat, args : Object ) : *
		{
			return new TextFormatEditor( v );
		}
internal function getArray ( v : Array, args : Object ) : *
		{
			var l : ListEditor = new ListEditor( v ? v : [] );
			
			ifenum:if( args.hasOwnProperty( "enumeration" ) && args.enumeration is Array )
	{
		var e : Array = args.enumeration;
		var le : uint = e.length;
		var c : ComboBox;
		if( args.hasOwnProperty( "contentType" ) && args.contentType is Class )
		{
			var t : Class = args.contentType;
			
			for( var i:int=0;i<le;i++) 
				if( !( e[i] is t ) )
					break ifenum;
			
			c = new ComboBox( e );
			l.newValueProvider = c;
			l.contentType = t;
		}
		else
		{
			c = new ComboBox( e );
			l.newValueProvider = c;
		}
		return l;
	}		
	if( args.hasOwnProperty( "contentType" ) && args.contentType is Class )
	{
		var fn : Function;
		fn = FormUtils.typesMap[ getQualifiedClassName( args.contentType ) ];
		
		if( fn != null )
		{
			var provider : Component = fn( FormUtils.getNewValue(args.contentType), {} );
			if( provider )
				l.newValueProvider = provider;
			else
				l.newValueProvider = new TextInput();
		}
		l.contentType = args.contentType;
		
		if( args.hasOwnProperty( "listCell" ) && args.listCell is Class )
			l.list.listCellClass = args.listCell;
	}
	else
	{
		l.newValueProvider = new TextInput();
	}
	return l;
}
