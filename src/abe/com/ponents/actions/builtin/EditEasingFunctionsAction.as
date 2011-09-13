package abe.com.ponents.actions.builtin
{
    import abe.com.mon.utils.magicToSource;
    import abe.com.mon.core.Cancelable;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.buttons.EasingFunctionPicker;
    import abe.com.ponents.containers.Dialog;
    import abe.com.ponents.models.LabelComboBoxModel;
    import abe.com.ponents.skinning.icons.Icon;

    import org.osflash.signals.Signal;

    /**
     * @author cedric
     */
    public class EditEasingFunctionsAction extends AbstractAction implements Cancelable
    {
        protected var _cancelled : Boolean;
        protected var _dial : Dialog;
        
        protected var _commandCancelled : Signal;
        
        public function EditEasingFunctionsAction ( icon : Icon = null, accelerator : KeyStroke = null )
        {
            _commandCancelled = new Signal();
            super ( _("Edit Easing Functions List"), icon, null, accelerator );
        }
        public function get commandCancelled () : Signal { return _commandCancelled; }

        override public function execute ( ...args ) : void
        {
             _cancelled = false;
            _isRunning = true;
            
            EasingFunctionsPaneInstance.refreshModel();
            
            _dial = new Dialog( _("Edit Easing Functions List"), 3, EasingFunctionsPaneInstance );
            _dial.dialogResponded.add( dialogResponded );
            _dial.open();
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
        private function dialogResponded ( dialog : Dialog, result : int ) : void
        {
            switch( result )
            {
                case Dialog.RESULTS_OK :
                	EasingFunctionPicker.EASING_FUNCTIONS.length = 0;
                
                	var lm : LabelComboBoxModel = EasingFunctionsPaneInstance.functionsList.model as LabelComboBoxModel;
                	var l : uint = lm.size;
                    
                    for( var i:uint=0;i<l;i++ )  
                    {
                        var f : Function = lm.getElementAt( i );
                        var s : String = lm.getLabel( f );
                        var src : String = magicToSource( f );
                        EasingFunctionPicker.EASING_FUNCTIONS.push( [ f, s, src ] );     	
                    }
                	
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
        public function isCancelled () : Boolean
        {
            return _cancelled;
        }
    }
}
import abe.com.ponents.tools.EasingFunctionsPane;
internal const EasingFunctionsPaneInstance : EasingFunctionsPane = new EasingFunctionsPane();
