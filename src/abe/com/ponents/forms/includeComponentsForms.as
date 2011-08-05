package abe.com.ponents.forms
{
    import abe.com.ponents.skinning.decorations.ComponentDecoration;
    import abe.com.ponents.skinning.icons.BitmapIcon;
    import abe.com.ponents.skinning.icons.CheckBoxCheckedIcon;
    import abe.com.ponents.skinning.icons.CheckBoxUncheckedIcon;
    import abe.com.ponents.skinning.icons.ColorIcon;
    import abe.com.ponents.skinning.icons.DOIcon;
    import abe.com.ponents.skinning.icons.DOInstanceIcon;
    import abe.com.ponents.skinning.icons.EmbeddedBitmapIcon;
    import abe.com.ponents.skinning.icons.ExternalBitmapIcon;
    import abe.com.ponents.skinning.icons.FontIcon;
    import abe.com.ponents.skinning.icons.GradientIcon;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.skinning.icons.PaletteIcon;
    import abe.com.ponents.skinning.icons.RadioCheckedIcon;
    import abe.com.ponents.skinning.icons.RadioUncheckedIcon;
    import abe.com.ponents.skinning.icons.SWFIcon;
    import abe.com.ponents.utils.Borders;
    import abe.com.ponents.utils.Corners;
    import abe.com.ponents.utils.Insets;

    import flash.utils.getQualifiedClassName;
    /**
     * @author cedric
     */
    public function includeComponentsForms () : void
    {
        FormUtils.addTypeMapFunction( FormFieldsType.INSETS_INT, getInsetsInt)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.INSETS_UINT, getInsetsUint)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.INSETS_FLOAT, getInsetsFloat)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Insets), getInsetsFloat)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.BORDERS_INT, getBordersInt)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.BORDERS_UINT, getBordersUint)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.BORDERS_FLOAT, getBordersFloat)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Borders), getBordersFloat)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.CORNERS_INT, getCornersInt)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.CORNERS_UINT, getCornersUint)  ;
		FormUtils.addTypeMapFunction( FormFieldsType.CORNERS_FLOAT, getCornersFloat)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Corners), getCornersFloat)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.CLASS, getClassPathInput)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Class), getClassPathInput)  ;
			
		FormUtils.addTypeMapFunction( getQualifiedClassName(ExternalBitmapIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(EmbeddedBitmapIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(SWFIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(ColorIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(GradientIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(PaletteIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(CheckBoxUncheckedIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(CheckBoxCheckedIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(RadioCheckedIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(RadioUncheckedIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(DOIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(DOInstanceIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(FontIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(BitmapIcon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Icon), getIcon)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(ComponentDecoration), getComponentDecoration)  ;
		
        FormUtils.addTypeMapFunction( FormFieldsType.COMPONENT_DECORATION, getComponentDecoration)  ;
    }
}
import abe.com.ponents.buttons.ComponentDecorationPicker;
import abe.com.ponents.buttons.IconPicker;
import abe.com.ponents.menus.ComboBox;
import abe.com.ponents.skinning.decorations.ComponentDecoration;
import abe.com.ponents.spinners.QuadSpinner;
import abe.com.ponents.text.ClassPathInput;
import abe.com.ponents.utils.Borders;
import abe.com.ponents.utils.Corners;
import abe.com.ponents.utils.Insets;
internal function getComponentDecoration ( v : ComponentDecoration, args : Object ) : *
{
	return new ComponentDecorationPicker(); 
}
internal function getInsetsInt ( v : Insets, args : Object ) : *
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
	return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
}
internal function getInsetsUint ( v : Insets, args : Object ) : *
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
	return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
}

internal function getInsetsFloat ( v : Insets, args : Object ) : *
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
	return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step );
}
internal function getBordersInt ( v : Borders, args : Object ) : *
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
	return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
}
internal function getBordersUint ( v : Borders, args : Object ) : *
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
	return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
}
internal function getBordersFloat ( v : Borders, args : Object ) : *
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
	return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step );
}

internal function getCornersInt ( v : Corners, args : Object ) : *
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
	return new QuadSpinner( v, "topLeft", "topRight", "bottomLeft", "bottomRight", min, max, step, true );
}
internal function getCornersUint ( v : Corners, args : Object ) : *
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
	return new QuadSpinner( v, "topLeft", "topRight", "bottomLeft", "bottomRight", min, max, step, true );
}
internal function getIcon ( v : *, args : Object ) : *
{
	return new IconPicker( v );
}
internal function getCornersFloat ( v : Corners, args : Object ) : *
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
	return new QuadSpinner( v, "topLeft", "topRight", "bottomLeft", "bottomRight", min, max, step );
}
internal function getClassPathInput ( v : *, args : Object ) : *
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
		var ti : ClassPathInput = new ClassPathInput( args.hasOwnProperty( "length" ) ? args.length : 0 );
		ti.value = v ? v : "";
		return ti;
	}
}
