package abe.com.edia.states
{
    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public interface UIState
    {
        
        function get key():String;
        function get index():int;
        function get manager () : UIStateMachine;
        function set manager ( m : UIStateMachine ) : void;
        function get isActive():Boolean;
        function get released () : Signal;
        
        function goto( state : * ):void;
        function release ():void;
        function activate ( previousState : UIState ):void;
        
    }
}
