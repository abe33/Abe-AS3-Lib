package abe.com.ponents.forms
{
    import abe.com.ponents.buttons.EasingFunctionPicker;
    /**
     * @author cedric
     */
    public function includeMotionForms () : void
    {
        EasingFunctionPicker.EASING_FUNCTIONS;
        
        FormUtils.addTypeMapFunction( FormFieldsType.EASING_FUNCTION, getEasing )  ;
    }
}
import abe.com.ponents.buttons.EasingFunctionPicker;

internal function getEasing( v : Function, args : Object ) : EasingFunctionPicker
{
    return EasingFunctionPicker( v );
}