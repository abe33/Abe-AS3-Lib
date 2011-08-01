package abe.com.ponents.forms
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.colors.Gradient;

    import flash.filters.ColorMatrixFilter;
    import flash.utils.getQualifiedClassName;
    /**
     * @author cedric
     */
    public function includeColorForms () : void
    {
        FormUtils.addTypeMapFunction( FormFieldsType.COLOR, getColor)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Color), getColor)  ;
		
		FormUtils.addTypeMapFunction( FormFieldsType.GRADIENT, getGradient)  ;
		FormUtils.addTypeMapFunction( getQualifiedClassName(Gradient), getGradient)  ;
		
        FormUtils.addPublicMembersFormFunction( ColorMatrixFilter, getColorMatrixFilterForm);
        FormUtils.addTypeMapFunction( FormFieldsType.FILTERS_ARRAY, getFiltersArray)  ;
    }
}
import abe.com.mon.colors.Color;
import abe.com.mon.colors.Gradient;
import abe.com.patibility.lang._;
import abe.com.ponents.buttons.ColorPicker;
import abe.com.ponents.buttons.FiltersPicker;
import abe.com.ponents.buttons.GradientPicker;
import abe.com.ponents.forms.FormField;
import abe.com.ponents.forms.FormObject;
import abe.com.ponents.tools.ColorMatrixEditor;

import flash.filters.ColorMatrixFilter;
internal function getColor ( v : Color, args : Object ) : ColorPicker
{
	return new ColorPicker(v);
}
internal function getGradient ( v : Gradient, args : Object ) : GradientPicker
{
	return new GradientPicker(v);
}
internal function getFiltersArray ( v : Array, args : Object ) : *
{
	return new FiltersPicker( v );
}
internal  function getColorMatrixFilterForm ( o : ColorMatrixFilter ) : FormObject 
{
	return new FormObject( o , 
						   [ new FormField( _("Matrix"), 
						   					"matrix", 
						   					new ColorMatrixEditor( o ), 
						   					0, 
						   					Array, 
						   					_("Due to the impossiblity to determinate the initial settings with the matrix contained in a ColorMatrixFilter instance, editing the matrix consist in recreating the whole matrix from scratch.") ) ] );
}
