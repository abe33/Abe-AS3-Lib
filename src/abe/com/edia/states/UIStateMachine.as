package abe.com.edia.states
{
    import abe.com.patibility.lang._;
    /**
     * @author cedric
     */
    public class UIStateMachine
    {
        protected var _states : Array;
        protected var _statesMap : Object;
        protected var _currentState : UIState;
        protected var _nextState : UIState;

        public function UIStateMachine ()
        {
            _states = [];
            _statesMap = {};
        }
        
        public function goto( state : * ) : void
        {
            if( state is int )
            	_goto( _states[ state ] );
            else if( state is String )
            	_goto( _statesMap[ state ] );
            else if( state is UIState )
                _goto( state );
            else
            	throw new Error(_("Invalid state argument in the goto method" ));
        }
        private function _goto( state : UIState ):void
        {
            if( _currentState )
            {
                _nextState = state;
                _currentState.release();
            }
            else
            	_setState( state );
        }

        private function _setState ( state : UIState ) : void
        {
            var oldState : UIState = _currentState;
            _currentState = state;
            _currentState.released.add( stateReleased );
            _currentState.activate(oldState);
        }

        private function stateReleased ( state : UIState ) : void
        {
            state.released.remove( stateReleased );
            _setState( _nextState );
        }

        public function getIndex( state : UIState ) : int { return findState( state ); }
        public function getKey( state : UIState ) : String
        {
            for ( var i : String in _statesMap )
            	if( _statesMap[i] == state )
                	return i;
            
            return null;
        }
        public function getState( state : * ) : UIState
        {
            if( state is int )
            	return _states[ state ];
            else if( state is String )
            	return _statesMap[ state ];
            else
	         	return null;   
        }
        public function addState ( o : UIState, key : String ) : void
        {
            if( !containsState( o ) )
            {
                _states.push( o );
                _statesMap[ key ] = o;
                o.manager = this;
            } 
        }
        public function removeState ( o : UIState ) : void
        {
            if( containsState( o ) )
            {
                delete _statesMap[ o.key ];
                _states.splice( findState( o ) );
                o.manager = null;
            } 
        }
        public function containsState ( o : UIState ) : Boolean { return  findState( o ) != -1; }
        public function findState( o : UIState ) : int { return _states.indexOf( o ); }
    }
}
