package abe.com.ponents.forms.fields
{
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.spinners.DoubleSpinner;

    import org.osflash.signals.Signal;

    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    public class RectangleFormComponent extends Panel implements FormComponent
    {
        protected var _positionSpinner : DoubleSpinner;
        protected var _sizeSpinner : DoubleSpinner;
        
        protected var _targetRectangle : Rectangle;
        protected var _dataChanged : Signal;
        
        public function RectangleFormComponent ( value : Rectangle )
        {
            _childrenLayout = new InlineLayout(this, 3, "left", "top", "topToBottom", true );
            _dataChanged = new Signal();
            super();
            
            _positionSpinner = new DoubleSpinner( value, "x", "y", Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, 1, false );
            _sizeSpinner = new DoubleSpinner( value, "width", "height", 0, Number.POSITIVE_INFINITY, 1, false );
            
            _positionSpinner.dataChanged.add( positionChanged );
            _sizeSpinner.dataChanged.add( sizeChanged );
            
            addComponents( _positionSpinner, _sizeSpinner );
        }

        public function get value () : * { return _targetRectangle; }
        public function set value ( v : * ) : void 
        {
            _targetRectangle = v;
            _positionSpinner.value = v;
            _sizeSpinner.value = v;
        }
        
        public function get dataChanged () : Signal { return _dataChanged; }

        public function get disabledMode () : uint { return _positionSpinner.disabledMode; }
        public function set disabledMode ( b : uint ) : void 
        {
            _positionSpinner.disabledMode = b;
            _sizeSpinner.disabledMode = b;
        }
        public function get disabledValue () : * { return _positionSpinner.disabledValue; }
        public function set disabledValue ( v : * ) : void 
        {
            _positionSpinner.disabledValue = v;
            _sizeSpinner.disabledValue = v;
        }
		private function positionChanged ( s : DoubleSpinner, r : Rectangle ) : void
        {
            dataChanged.dispatch( this, r );
        }
        private function sizeChanged ( s : DoubleSpinner, r : Rectangle ) : void
        {
            dataChanged.dispatch( this, r );
        }
    }
}
