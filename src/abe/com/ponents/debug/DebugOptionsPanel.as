package abe.com.ponents.debug
{
    import abe.com.mon.core.Debuggable;
    import abe.com.mon.debug.DebuggableManager;
    import abe.com.mon.debug.DebuggableManagerInstance;
    import abe.com.mon.utils.Reflection;
    import abe.com.patibility.humanize.plural;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.buttons.CheckBox;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.containers.ScrollablePanel;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.forms.FormUtils;
    import abe.com.ponents.forms.managers.SimpleFormManager;
    import abe.com.ponents.forms.renderers.FieldSetFormRenderer;
    import abe.com.ponents.layouts.components.BorderLayout;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.lists.List;
    import abe.com.ponents.models.DefaultListModel;
    import abe.com.ponents.text.Label;

    import flash.utils.Dictionary;

    /**
     * @author cedric
     */
    public class DebugOptionsPanel extends Panel
    {
        [Embed(source="../skinning/icons/components/options.png")]
        static public var ICON : Class;
        
        protected var _classesList : List;
        
        protected var _selectedClass : Class;
        protected var _baseForm : ScrollablePanel;
        protected var _activationCheckBox : CheckBox;
        protected var _instancesLabel : Label;
        
        protected var _cachedFormsManager : Dictionary;
        protected var _cachedForms : Dictionary;
        
        public function DebugOptionsPanel ()
        {
            _cachedForms = new Dictionary();
            _cachedFormsManager = new Dictionary();
            
            var l : BorderLayout = new BorderLayout(this);
            _childrenLayout = l;
            
            super();
            
            DebuggableManagerInstance.classAdded.add( updateClassList ); 
            DebuggableManagerInstance.classRemoved.add( updateClassList ); 
            
            _classesList = new List( DebuggableManagerInstance.classes );
            _classesList.itemFormatingFunction = function( v : Class ) : String{
                return Reflection.getClassName( v ) + ( DebuggableManagerInstance.isClassDebugActive(v) ? 
                											" <font color='#009900'><i>active</i></font>" : 
                                                            "" );
            };
            _classesList.dndEnabled = false;
            _classesList.editEnabled = false;
            _classesList.allowMultiSelection = false;
            _classesList.loseSelectionOnFocusOut = false;
            
            _classesList.selectionChanged.add( listSelectionChanged );
            
            var scpList : ScrollPane = new ScrollPane();
            scpList.view = _classesList;
            scpList.preferredWidth = 150;
            
            createBaseForm ();
            var scpForm : ScrollPane = new ScrollPane();
            scpForm.view = _baseForm;
            
            l.west = scpList;
            l.center = scpForm;
            addComponents( scpList, scpForm );
        }
        protected function listSelectionChanged ( sel : * ) : void
        {
            clearPastForm();
            _selectedClass = _classesList.selectedValue as Class;
            updateForm();            
        }
		protected function createBaseForm () : void
        {
            _baseForm = new ScrollablePanel();
            _baseForm.childrenLayout = new InlineLayout(_baseForm, 0, "left", "top", "topToBottom", true );
            _baseForm.styleKey = "FormPanel";
            
            _activationCheckBox = new CheckBox(_("No selection"));
            _activationCheckBox.enabled = false;
            _activationCheckBox.dataChanged.add( selectionActivationChanged );
            ( _activationCheckBox.childrenLayout as DOInlineLayout ).horizontalAlign = "left";
            
            _instancesLabel = new Label(_("Select an element in the list to access its options."));
            
            _baseForm.addComponents( _activationCheckBox, _instancesLabel );
        }

        protected function selectionActivationChanged ( c : CheckBox, b : Boolean ) : void
        {
            if( _selectedClass )
            {
                if( b )
            		DebuggableManagerInstance.activateClassDebug(_selectedClass);
                else
            		DebuggableManagerInstance.deactivateClassDebug(_selectedClass);
                
                for each( var cp : Component in _cachedForms[_selectedClass].children )
	                cp.enabled = _activationCheckBox.value;
                
                _classesList.invalidate( true );
            }
        }
        protected function formPropertyChanged (propertyName : String, propertyValue : *) : void
        {
            var options : Object = DebuggableManagerInstance.getClassOptions(_selectedClass);
            var instances : Array = DebuggableManagerInstance.getInstancesFor( _selectedClass );
            for each( var d : Debuggable in instances )
            {
            	d.optionChanged( propertyName, propertyValue );
            	d.optionsChanged( options );
            }
        }
        
        protected function clearPastForm():void
        {
            _baseForm.removeAllComponents();
            _baseForm.addComponents( _activationCheckBox, _instancesLabel );
            
            if( _selectedClass )
            {
                var fm : SimpleFormManager = _cachedFormsManager[_selectedClass] as SimpleFormManager;
                fm.propertyChanged.remove( formPropertyChanged );
            }
        }

        protected function updateForm () : void
        {
            var hasSelection : Boolean = _selectedClass != null;
            
            
            if( !hasSelection )
            {
                _activationCheckBox.value = false;
                _activationCheckBox.label = _("No selection");
                _instancesLabel.value = _("Select an element in the list to access its options.");
            }
            else
            {
                var ic : Number = DebuggableManagerInstance.getInstancesFor(_selectedClass).length;
                _instancesLabel.value = _$(_("${instancesCount} ${instancePluralized} registered."), {
                    'instancesCount':ic,
                    'instancePluralized':plural( ic, _("instance"), _("instances") )
                });
	            _activationCheckBox.label = _$(_("Activate ${class} Debug"), {
                    'class':Reflection.getClassName(_selectedClass)
                });
	            _activationCheckBox.value = DebuggableManagerInstance.isClassDebugActive( _selectedClass );
                
                var fm : SimpleFormManager;
                var fp : Panel;
                
                if( _cachedFormsManager[_selectedClass] != undefined )
                {
                    fm = _cachedFormsManager[_selectedClass];
                    fp = _cachedForms[_selectedClass];
                }
                else
                {
                    var fo : FormObject = FormUtils.createFormForPublicMembers( DebuggableManagerInstance.getClassOptions( _selectedClass ) );
                    fm = new SimpleFormManager( fo );
                    fp = FieldSetFormRenderer.instance.render( fo ) as Panel;
                    _cachedFormsManager[_selectedClass] = fm;
                    _cachedForms[_selectedClass] = fp;
                }
                fm.propertyChanged.add( formPropertyChanged );
                fm.updateFieldsWithTarget();
                for each( var c : Component in fp.children )
                {
	                c.enabled = _activationCheckBox.value;
                	_baseForm.addComponent( c );
                }
                ( _baseForm.parentContainer.parentContainer as ScrollPane ).invalidate();
            }
            _activationCheckBox.enabled = hasSelection;
        }
        protected function updateClassList ( manager : DebuggableManager, cl : Class ) : void
        {
            _classesList.model = new DefaultListModel( manager.classes );
        }
    }
}
