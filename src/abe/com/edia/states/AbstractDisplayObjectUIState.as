package abe.com.edia.states
{
    import abe.com.ponents.utils.ToolKit;

    import flash.display.DisplayObject;

    /**
     * @author cedric
     */
    public class AbstractDisplayObjectUIState extends AbstractUIState
    {
        protected var _displayObject : DisplayObject;
        
        public function AbstractDisplayObjectUIState ( displayObject : DisplayObject = null )
        {
            super ();
            _displayObject = displayObject;
        }

        public function get displayObject () : DisplayObject { return _displayObject; }
        public function set displayObject ( displayObject : DisplayObject ) : void { _displayObject = displayObject; }
        
        override public function activate ( previousState : UIState ) : void
        {
         	if( _displayObject )   
            	ToolKit.mainLevel.addChild( _displayObject );
            
            super.activate ( previousState );
        }

        override public function release () : void
        {
            if( _displayObject )
            	ToolKit.mainLevel.removeChild( _displayObject );
            super.release ();
        }
    }
}
