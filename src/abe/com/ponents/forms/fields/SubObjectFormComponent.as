package abe.com.ponents.forms.fields
{
    import abe.com.mon.core.FormMetaProvider;
    import abe.com.mon.utils.Reflection;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.containers.FieldSet;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.forms.FormUtils;
    import abe.com.ponents.forms.managers.SimpleFormManager;
    import abe.com.ponents.forms.renderers.DefaultRenderer;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.menus.ComboBox;
    import abe.com.ponents.models.LabelComboBoxModel;

    import org.osflash.signals.Signal;

    import flash.utils.Dictionary;

    /**
     * @author cedric
     */
    public class SubObjectFormComponent extends Panel implements FormComponent
    {
        static private const INSTANCES_VALUES_CACHE : Dictionary = new Dictionary();
        static private const FORMS_CACHE : Dictionary = new Dictionary();
        static private const FORMS_PANEL_CACHE : Dictionary = new Dictionary();
        
        protected var _dataChanged : Signal;
        protected var _choicesCombo : ComboBox;
        protected var _allowNull : Boolean;
        protected var _owner : Object;
        protected var _value : Object;
        protected var _valueType : Class;
        protected var _factoryFunction : Function;
        
        protected var _subObjectForm : FormObject;
        protected var _subObjectManager : SimpleFormManager;
        protected var _subObjectPanel : FieldSet;
        
        public function SubObjectFormComponent ( owner : Object, value : Object, allowNull : Boolean = false, ... types ) 
        {
            _dataChanged = new Signal();
            _childrenLayout = new InlineLayout(this,0,"left","top","topToBottom",true);
            _allowNull = allowNull;
            
            if( _allowNull )
            	types.unshift( null );
            
            var labels : Array = [];
            for each( var c : Class in types )
            	if( c == null )
                	labels.push(_("None"));
                else
                	labels.push(Reflection.getClassName( c ));
            
            _choicesCombo = new ComboBox( new LabelComboBoxModel( types, labels ) );
            _choicesCombo.itemFormatingFunction = ( _choicesCombo.model as LabelComboBoxModel ).getLabel;
            _choicesCombo.dataChanged.add( comboDataChanged );
            addComponent( _choicesCombo );

            this.owner = owner;
            this.value = value;
        }
        public function get owner () : Object { return _owner; }
        public function set owner ( owner : Object ) : void 
        { 
            _owner = owner; 
            if( !INSTANCES_VALUES_CACHE[_owner] )
            	INSTANCES_VALUES_CACHE[_owner] = new Dictionary();
        }
        
        public function get factoryFunction () : Function { return _factoryFunction; }
        public function set factoryFunction ( factoryFunction : Function ) : void { _factoryFunction = factoryFunction; }
        
        public function get disabledMode () : uint { return 0; }
        public function set disabledMode ( b : uint ) : void {}

        public function get disabledValue () : * {}
        public function set disabledValue ( v : * ) : void {}

        public function get dataChanged () : Signal { return _dataChanged; }
        
        public function get value () : * { return _value; }
        public function set value ( v : * ) : void 
        {
            if( v != _value )
            {
	            _value = v;
	            _valueType = Reflection.getClass( _value );
	            INSTANCES_VALUES_CACHE[_owner][ _valueType ] = _value;
	            _choicesCombo.value = _valueType;
                
                updateForm();
            }
        }
        
        public function get canValidateForm () : Boolean { return false; }
        public function get formValidated() : Signal { return null; }

        private function updateForm () : void
        {
            if( _subObjectForm )
            {
                _subObjectManager.formChanged.remove( formDataChanged );
                removeComponent(_subObjectPanel);
            }
                
            if( _value != null )
            {
                if( !FORMS_CACHE[ _valueType ] )
                {
                    var fo : FormObject;
                    
                    if( _value is FormMetaProvider )
                    	fo = FormUtils.createFormFromMetas( _value );
                    else
                    	fo = FormUtils.createFormForPublicMembers( _value );
                    
                    FORMS_CACHE[ _valueType ] = new SimpleFormManager( fo );
                    var fs : FieldSet = new FieldSet( _$(_( "${class} Properties" ), {'class':Reflection.getClassName(_valueType)} ) );
                    fs.childrenLayout = new InlineLayout(null, 0, "left", "top", "topToBottom", true );
                    var p : Panel = DefaultRenderer.render(fo) as Panel;;
                    fs.addComponent( p );
                    FORMS_PANEL_CACHE[ _valueType ] = fs;
                }
                
                _subObjectManager = FORMS_CACHE[ _valueType ];
                _subObjectForm = _subObjectManager.formObject;
                _subObjectPanel = FORMS_PANEL_CACHE[ _valueType ];
                
                _subObjectForm.target = _value;
                _subObjectManager.updateFieldsWithTarget();
                _subObjectManager.formChanged.add( formDataChanged );
                addComponent(_subObjectPanel);
            }
        }

        private function formDataChanged ( fm : SimpleFormManager ) : void
        {
            dataChanged.dispatch( this, _value );
        }
        
 		private function comboDataChanged ( c : ComboBox, cl : Class ) : void
        {
         	if( cl != _valueType )
            {
                if( cl == null )
					this.value = null;
                else if( INSTANCES_VALUES_CACHE[_owner][ cl ] )
                	this.value = INSTANCES_VALUES_CACHE[_owner][ cl ];
                else
                	this.value = _factoryFunction != null ? _factoryFunction( cl, _owner ) : new cl();
            }
            dataChanged.dispatch( this, _value );
        }
    }
}
