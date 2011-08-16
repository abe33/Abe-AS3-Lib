package abe.com.ponents.buttons
{
    import abe.com.mands.*;
    import abe.com.patibility.lang._;
    import abe.com.ponents.forms.*;
    import abe.com.ponents.skinning.icons.*;

    import org.osflash.signals.Signal;

    public class AbstractFormButton extends AbstractButton implements FormComponent
    {
        protected var _disabledMode : uint;
        protected var _disabledValue : *;
        protected var _dataChanged : Signal;
        
        public function AbstractFormButton ( actionOrLabel : * = null, icon : Icon = null )
        {
            _dataChanged = new Signal();
            super( actionOrLabel, icon );
        }
        public function get dataChanged () : Signal { return _dataChanged; }
        
        public function get disabledMode () : uint { return _disabledMode; }
        public function set disabledMode (b : uint) : void
        {
            _disabledMode = b;
    
            if( !_enabled )
                checkDisableMode();
        }
        public function get disabledValue () : * { return _disabledValue; }
        public function set disabledValue (v : *) : void { _disabledValue = v; }
        
        public function get value () : * { return null; }
        public function set value (value : *) : void {}
        
        override public function set enabled (b : Boolean) : void 
		{
			super.enabled = b;
			checkDisableMode();
		}
        
        protected function checkDisableMode() : void
        {
            switch( _disabledMode )
            {
                case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY : 
                    disabledValue = _("different values across many");
                    affectLabelText();
                break;

                case FormComponentDisabledModes.UNDEFINED : 
                    disabledValue = _("not defined");
                    affectLabelText();
                break;

                case FormComponentDisabledModes.NORMAL :
                case FormComponentDisabledModes.INHERITED : 
                default : 
                    disabledValue = _action ? _action.name : ( _safeLabel ? _safeLabel : _label );
                    affectLabelText();
                break;
            }
        }
        protected function fireDataChangedSignal():void
        {
            _dataChanged.dispatch( this, value );
        }
        override protected function affectLabelText () : void 
		{
			if( _enabled )
				super.affectLabelText();
			else
				_labelTextField.htmlText = String( _disabledValue );
		}
		override protected function commandEnded (c:Command) : void
		{
			super.commandEnded( c );
			fireDataChangedSignal();
		}
    }
}
