package abe.com.ponents.forms
{
    /**
     * @author cedric
     */
    public function includeSubObjectForms () : void
    {
        
        FormUtils.addTypeMapFunction( "subObject", getSubObject );
        
    }
}
import abe.com.mon.utils.Reflection;
import abe.com.ponents.forms.fields.SubObjectFormComponent;
internal function getSubObject ( o : Object, args : Object ):*
{
    return Reflection.buildInstance( SubObjectFormComponent, [ args.owner, o, args.allowNull ].concat( args.types ) );
}