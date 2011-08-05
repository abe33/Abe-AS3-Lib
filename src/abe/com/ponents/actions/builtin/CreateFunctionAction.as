package abe.com.ponents.actions.builtin
{
    import abe.com.mon.core.Cancelable;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.patibility.lang._;
    import abe.com.pile.compile;
    import abe.com.pile.units.FunctionCompilationUnit;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.containers.Dialog;
    import abe.com.ponents.skinning.icons.Icon;

    import org.osflash.signals.Signal;

    /**
     * @author cedric
     */
    public class CreateFunctionAction extends AbstractAction implements Cancelable
    {
        protected var _cancelled : Boolean;
        protected var _dial : Dialog;
        
        protected var _commandCancelled : Signal;
        
        protected var _signature : String;
        protected var _defaultContent : String;
        protected var _unit : FunctionCompilationUnit;
        
        public function CreateFunctionAction ( signature : String = "function ${functionName} ():void",
        									   defaultContent : String = "",
											   name : String = "", 
											   icon : Icon = null, 
                                               longDescription : String = null, 
                                               accelerator : KeyStroke = null )
        {
            super ( name, icon, longDescription, accelerator );
            _commandCancelled = new Signal();
            _defaultContent = defaultContent;
            _signature = signature;
        }
        
        public function get unit () : FunctionCompilationUnit { return _unit; }
        public function get commandCancelled () : Signal { return _commandCancelled; }
        
        override public function execute ( ...args ) : void
        {
            _cancelled = false;
            _isRunning = true;
            _unit = new FunctionCompilationUnit( "funcName" , _signature, _defaultContent );
            FunctionEditorPaneInstance.unit = _unit.clone();

            _dial = new Dialog( _("Create Function"), 3, FunctionEditorPaneInstance, 0 );
            _dial.dialogResponded.addOnce( dialogResponded );
            _dial.open( Dialog.CLOSE_ON_RESULT );
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
        private function dialogResponded ( dialog : Dialog, result : int ) : void
        {
            switch( result )
            {
                case Dialog.RESULTS_OK :
                	var u : FunctionCompilationUnit = FunctionEditorPaneInstance.unit;
                	_unit.key = u.key;
                    _unit.extraImports = u.extraImports;
                    _unit.signature = u.signature;
                    _unit.content = u.content;
                    
                    Log.debug( _unit.source );
                    
                	_unit.unitCompiled.addOnce( unitCompiled );
                	compile( _unit, false );
                    
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
		private function unitCompiled(... args):void{
           	commandEnded.dispatch( this );
        }
    }
}
import abe.com.ponents.tools.FunctionEditorPane;
internal const FunctionEditorPaneInstance : FunctionEditorPane = new FunctionEditorPane();
