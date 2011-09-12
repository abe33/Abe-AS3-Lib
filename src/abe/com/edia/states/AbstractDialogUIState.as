package abe.com.edia.states
{
    import abe.com.ponents.core.Component;

    /**
     * @author cedric
     */
    public class AbstractDialogUIState extends AbstractComponentUIState
    {
        public function AbstractDialogUIState ( component : Component = null )
        {
            super ( component );
        }
        
        override public function activate ( previousState : UIState ) : void
        {
            if( (_component as Object).hasOwnProperty("open") )
            	_component["open"]();
            
            _active = true;
        }

        override public function release () : void
        {
            if( (_component as Object).hasOwnProperty("close") )
            	_component["close"]();
            
            released.dispatch(this);
            _active = false;
        }
    }
}
