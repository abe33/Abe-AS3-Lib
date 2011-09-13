package abe.com.ponents.tools
{
    import abe.com.mon.geom.dm;
    import abe.com.patibility.lang._;
    import abe.com.pile.CompilationManagerInstance;
    import abe.com.pile.units.FunctionCompilationUnit;
    import abe.com.ponents.actions.builtin.CreateFunctionAction;
    import abe.com.ponents.actions.builtin.EditFunctionAction;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.buttons.EasingFunctionPicker;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.layouts.components.GridLayout;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.lists.List;
    import abe.com.ponents.models.LabelComboBoxModel;
    import abe.com.ponents.monitors.EasingFunctionGraph;

    /**
     * @author cedric
     */
    public class EasingFunctionsPane extends Panel
    {
        protected var _functionsList : List;
        protected var _functionPreview : EasingFunctionGraph;
        protected var _addNewFunction : Button;
        protected var _editCurrent : Button;
        
        public function EasingFunctionsPane ()
        {
            _childrenLayout = new GridLayout(this, 1, 2, 5, 0);
            super();
            
            _functionPreview = new EasingFunctionGraph();
            
	        _functionsList = new List( getModel() );
            _functionsList.itemFormatingFunction = function( f : Function ) : String {
                return ( _functionsList.model as LabelComboBoxModel ).getLabel( f ) + 
                	( CompilationManagerInstance.wasCompiled( f ) ? " <font color='#ff0000'><i>(compiled)</i></font>" : "" );
            };
            _functionsList.selectionChanged.add( function( i : int ) : void {
                var f : Function = _functionsList.model.getElementAt( i );
                _editCurrent.enabled = CompilationManagerInstance.wasCompiled( f );
                if( _editCurrent.enabled )
                	( _editCurrent.action as EditFunctionAction ).unit = CompilationManagerInstance.compiledUnits[ f ] as FunctionCompilationUnit;
                
                _functionPreview.easingFunction = f;
            } );
            
            _functionsList.dndEnabled = false;
            _functionsList.editEnabled = false;
            _functionsList.loseSelectionOnFocusOut = false;
            
            _addNewFunction = new Button( new CreateFunctionAction( "function ${functionName}( t:Number, s : Number, g : Number, d : Number ):Number" , 
            														"return s + ( t / d ) * g;",
                                                                    _("New Function") ) );
            _addNewFunction.action.commandEnded.add( newFunctionCommandEnded );
                                                                    
            _editCurrent = new Button( new EditFunctionAction( null, _("Edit Function") ) );
            _editCurrent.action.commandEnded.add( editFunctionCommandEnded );
            _editCurrent.enabled = false;
            
            var scp : ScrollPane = new ScrollPane();
            scp.view = _functionsList;
            
            var p : Panel = new Panel();
            p.childrenLayout = new GridLayout(p, 2, 1, 0, 5 );
            
            var btp : Panel = new Panel();
            btp.childrenLayout = new InlineLayout( btp, 3, "right", "top", "topToBottom" );
                        
            btp.addComponents( _addNewFunction, _editCurrent );
            
            p.addComponents( _functionPreview, btp );
            
            addComponents( scp, p );

            preferredSize = dm(400,300);
        }
        protected function editFunctionCommandEnded( c : EditFunctionAction ):void
        {
            var u : FunctionCompilationUnit = c.unit;
            var lm : LabelComboBoxModel = _functionsList.model as LabelComboBoxModel;
            lm.setElementAt( _functionsList.selectedIndex, u.unit );
            _functionPreview.easingFunction = u.unit;
            if( lm.getLabel( u.unit ) != u.key )
            	lm.setLabel( u.unit, u.key );
        }
        protected function newFunctionCommandEnded( c : CreateFunctionAction ):void
        {
            var u : FunctionCompilationUnit = c.unit;
            ( _functionsList.model as LabelComboBoxModel ).addElementAt( [ u.unit, u.key ], 1 );
            _functionsList.selectedIndex = 1;
        }
        public function refreshModel():void
        {
            _functionsList.model = getModel();
        }
        protected function getModel():LabelComboBoxModel
        {
            var values : Array = [];
            var labels : Array = [];
            
            for each( var a : Array in EasingFunctionPicker.EASING_FUNCTIONS )
            {
                values.push(a[0]);
                labels.push(a[1]);
            }
            return new LabelComboBoxModel ( values, labels );
        }

        public function get functionsList () : List {
            return _functionsList;
        }
    }
}
