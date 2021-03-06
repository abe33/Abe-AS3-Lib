package abe.com.ponents.actions.builtin
{
    import abe.com.mon.core.Cancelable;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Reflection;
    import abe.com.mon.utils.magicClone;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.containers.Dialog;
    import abe.com.ponents.skinning.icons.Icon;

    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public class EditFiltersAction extends AbstractAction implements Cancelable
    {
        protected var _filters : Array;
        protected var _cancelled : Boolean;
        protected var _dial : Dialog;
        
        protected var _commandCancelled : Signal;

        public function EditFiltersAction ( filters : Array, icon : Icon = null,  accelerator : KeyStroke = null)
        {
            _commandCancelled = new Signal();
            this._filters = filters;
            super( _("Filters"), icon, _("Edit Filters"), accelerator );
            updateName();
        }

        public function get filters () : Array { return _filters; }
        public function set filters (filters : Array) : void
        {
            _filters = filters;
            updateName();
        }

        protected function updateName () : void
        {
            name = _$( _("Filters : $0"), 
                        filters.length > 0 ? 
                            filters.map( function( o:*, ... args ) : String { return Reflection.getClassName( o ); } ).join(", ") : 
                            _("Empty") );
        }

        override public function execute( ... args ) : void
        {
            _cancelled = false;
            _isRunning = true;
            FilterEditorPaneInstance.value = magicClone( _filters );

            _dial = new Dialog( _("Edit Filters"), 3, FilterEditorPaneInstance );
            _dial.dialogResponded.add( dialogResponded );
            _dial.open();
        }
        private function dialogResponded ( dialog : Dialog, result : int ) : void
        {
            switch( result )
            {
                case Dialog.RESULTS_OK :
                    _filters = FilterEditorPaneInstance.value;
                    updateName ();
                    //firePropertyEvent( "icon", _icon );
                    commandEnded.dispatch( this );
                    break;
                default :
                    commandCancelled.dispatch( this );
                    break;
            }
            _isRunning = false;
            _dial.close();
            _dial.dialogResponded.remove( dialogResponded );
            _dial = null;
        }
        public function cancel () : void
        {
            _dial.close();
            _dial.dialogResponded.remove( dialogResponded );
            _dial = null;
            _cancelled = true;
            _isRunning = false;
            commandCancelled.dispatch( this );
        }
        public function isCancelled () : Boolean
        {
            return _cancelled;
        }
        public function get commandCancelled () : Signal { return _commandCancelled; }
    }
}

import abe.com.ponents.tools.FilterEditorPane;

internal const FilterEditorPaneInstance : FilterEditorPane = new FilterEditorPane();
