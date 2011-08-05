package abe.com.ponents.tools
{
    import abe.com.mon.geom.dm;
    import abe.com.pile.units.FunctionCompilationUnit;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.forms.FormUtils;
    import abe.com.ponents.forms.managers.SimpleFormManager;
    import abe.com.ponents.forms.renderers.FieldSetFormRenderer;
    import abe.com.ponents.layouts.components.InlineLayout;

    /**
     * @author cedric
     */
    public class FunctionEditorPane extends Panel
    {
        protected var _unit : FunctionCompilationUnit;
        protected var _formObject:  FormObject;
        protected var _formManager : SimpleFormManager;
        
        public function FunctionEditorPane ()
        {
            _childrenLayout = new InlineLayout(this,0,"left","top","topToBottom",true);
            super();
            _formObject = FormUtils.createFormFromMetas( new FunctionCompilationUnit() );
            _formManager = new SimpleFormManager( _formObject );
//            _formManager.formChanged.add( formChanged );
            
            addComponent( FieldSetFormRenderer.instance.render( _formObject ) );
            preferredSize = dm( 350, 280 );
        }

        public function get unit () : FunctionCompilationUnit { return _unit; }
        public function set unit ( unit : FunctionCompilationUnit ) : void {
            _unit = unit;
            _formObject.target = _unit;
            _formManager.updateFieldsWithTarget();
        }
    }
}
