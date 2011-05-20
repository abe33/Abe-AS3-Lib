package abe.com.ponents.core
{

    public class UserActionContext
    {
        static public const NO_ACTION : uint = 0;        
        static public const MOUSE_ACTION : uint = 1;        
        static public const KEYBOARD_ACTION : uint = 2;   
        static public const PROGRAM_ACTION : uint = 3;   
        
        public var target : Object;
        public var action : uint;
        public var actionData : *;
        
        public var ctrlPressed : Boolean;
        public var shiftPressed : Boolean;
        public var altPressed : Boolean; 
        
        public function UserActionContext( target : Object,
                                           action : uint = 0, 
                                           actionData : * = null, 
                                           ctrlPressed : Boolean = false,
                                           shiftPressed : Boolean = false,
                                           altPressed : Boolean = false ) 
        {
            this.target = target;
            this.action = action;
            this.actionData = actionData;
            this.ctrlPressed = ctrlPressed;
            this.shiftPressed = shiftPressed;
            this.altPressed = altPressed;
        }            
    }
}
