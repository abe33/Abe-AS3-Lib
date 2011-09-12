package abe.com.edia.states
{
    import abe.com.ponents.core.Component;
    import abe.com.ponents.utils.ToolKit;

    import flash.display.DisplayObject;

    /**
     * @author cedric
     */
    public class AbstractComponentUIState extends AbstractUIState
    {
        protected var _component : Component;

        public function AbstractComponentUIState ( component : Component = null )
        {
            super ();
            _component = component;
        }

        public function get component () : Component { return _component; }
		public function set component ( component : Component ) : void { _component = component; }

        override public function activate ( previousState : UIState ) : void
        {
         	if( _component )   
            	ToolKit.mainLevel.addChild( _component as DisplayObject );
            super.activate ( previousState );
        }

        override public function release () : void
        {
            if( _component )
            	ToolKit.mainLevel.removeChild( _component as DisplayObject );
            super.release ();
        }

    }
}
