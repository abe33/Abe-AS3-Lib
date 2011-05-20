package abe.com.ponents.tools
{
    import abe.com.mon.colors.*;
    
    import abe.com.ponents.containers.*;
    import abe.com.ponents.events.*;
    import abe.com.ponents.layouts.components.*;
    
    import org.osflash.signals.Signal;
    
    public class ColorWheelEditor extends Panel 
    {
        protected var _target : Color;
        protected var _wheel : ColorWheel;
        
        public var dataChanged : Signal;
        
        public function ColorWheelEditor()
        {
            super();
            dataChanged = new Signal();
            _childrenLayout = new InlineLayout(this);
            _target = new Color();
            
            _wheel = new ColorWheel();
            _wheel.addEventListener(ComponentEvent.DATA_CHANGE, colorWheelDataChange );
            
            addComponent( _wheel );
        }
        public function get target () : Color { return _target; }    
        public function set target (target : Color) : void
        {
            _target = target;
            _wheel.target = target;
        }
        public function colorWheelDataChange( e : ComponentEvent ) : void
        {
            fireDataChangedSignal();
        }
        
        protected function fireDataChangedSignal () : void 
        {
            dataChanged.dispatch( this, _target );
        }
    }
}
