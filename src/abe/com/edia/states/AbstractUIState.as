package abe.com.edia.states
{
    import org.osflash.signals.Signal;

    /**
     * @author cedric
     */
    public class AbstractUIState implements UIState
    {
        protected var _manager : UIStateMachine;
        protected var _released : Signal;
        protected var _active : Boolean;

        public function AbstractUIState ()
        {
            _released = new Signal();
        }
        public function get isActive () : Boolean { return false; }

        public function get key () : String { return _manager.getKey(this); }
        public function get index () : int { return _manager.getIndex(this); }

        public function get manager () : UIStateMachine { return _manager; }
        public function set manager ( m : UIStateMachine ) : void {	_manager = m; }

        public function get released () : Signal { return _released; }
        
        public function goto ( state : * ) : void  { _manager.goto( state ); }
        
        public function activate ( previousState : UIState ) : void { _active = true; }

        public function release () : void { _released.dispatch ( this ); _active = false;  }
    }
}
