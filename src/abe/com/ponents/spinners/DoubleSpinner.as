package abe.com.ponents.spinners 
{
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.buttons.LockerButton;
    import abe.com.ponents.core.*;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.layouts.components.ColumnSettings;
    import abe.com.ponents.layouts.components.ColumnsLayout;
    import abe.com.ponents.models.SpinnerNumberModel;
    import abe.com.ponents.text.Label;

    import org.osflash.signals.Signal;
	/**
	 * @author cedric
	 */
	[Skinable(skin="EmptyComponent")]
	public class DoubleSpinner extends AbstractContainer implements FormComponent
	{
		protected var _spinner1 : Spinner;
		protected var _spinner2 : Spinner;
		protected var _lockButton : LockerButton;	
		
		protected var _value : Object;
		
		protected var _propertyName1 : String;		
		protected var _propertyName2 : String;
		
		protected var _valuesLocked : Boolean;	
		protected var _label1 : Label;
		protected var _label2 : Label;
		
		private var _valueSetProgrammatically : Boolean;
        
        protected var _dataChanged : Signal;
		public function get dataChanged() : Signal { return _dataChanged; }
		
		public function DoubleSpinner ( value : Object, 
										property1 : String, 
										property2 : String, 
										min : Number = 0, 
										max : Number = 10, 
										step : Number = 1, 
										intOnly : Boolean = false )
		{
			super();
			_dataChanged = new Signal();
			_propertyName1 = property1;
			_propertyName2 = property2;
			
			_valuesLocked = false;
			
			_spinner1 = new Spinner( new SpinnerNumberModel( 0, min, max, step, intOnly ) );
			_spinner2 = new Spinner( new SpinnerNumberModel( 0, min, max, step, intOnly ) );
			_label1 = new Label( property1 );
			_label2 = new Label( property2 );
			_lockButton = new LockerButton();
			_lockButton.allowFocus = false;
            
            _spinner1.preferredWidth = _spinner2.preferredWidth = 60;
			
			_label1.isComponentIndependent = false;
			_label2.isComponentIndependent = false;
			_spinner1.isComponentIndependent = false;
			_spinner2.isComponentIndependent = false;
			_lockButton.isComponentIndependent = false;
			
			this.value = value;
			
			addComponent( _label1 );
			addComponent( _spinner1 );
			addComponent( _lockButton );
			addComponent( _spinner2 );
			addComponent( _label2 );
			
			childrenLayout = new ColumnsLayout( this, 3, 
												new ColumnSettings("right", "top", 3, true, _label1 ),
												new ColumnSettings("right", "top", 3, false, _spinner1 ),
												new ColumnSettings("center", "center", 3, false, _lockButton ),
												new ColumnSettings("left", "top", 3, false, _spinner2 ),
												new ColumnSettings("left", "top", 3, true, _label2 )
												);
		}
		public function get disabledMode () : uint 
		{
			return _spinner1.disabledMode;
		}
		public function set disabledMode (b : uint) : void
		{
			_spinner1.disabledMode = b;
			_spinner2.disabledMode = b;
		}

		public function get disabledValue () : * {}
		public function set disabledValue (v : *) : void
		{
		}
        public function get canValidateForm () : Boolean { return false; }
        public function get formValidated() : Signal { return null; }

		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			
			_spinner1.dataChanged.add( spinner1DataChanged );
			_spinner2.dataChanged.add( spinner2DataChanged );
			_lockButton.dataChanged.add( lockDataChanged );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			
			_spinner1.dataChanged.remove( spinner1DataChanged );
			_spinner2.dataChanged.remove( spinner2DataChanged );
			_lockButton.dataChanged.remove( lockDataChanged );
		}

		protected function lockDataChanged ( bt : Component, b : Boolean ) : void 
		{
			_valuesLocked = _lockButton.selected;
			
			if( _valuesLocked )
			{
				_valueSetProgrammatically = true;
				_spinner2.value = _spinner1.value;
				_valueSetProgrammatically = false;
				
				_value[_propertyName2] = _value[_propertyName1];
				
				fireDataChangedSignal();
			}
		}

		protected function spinner1DataChanged ( c : Component, v : * ) : void 
		{
			if( _valueSetProgrammatically )
				return;
			
			_value[ _propertyName1 ] = _spinner1.value;
			if( _valuesLocked )
			{
				_value[_propertyName2] = _value[_propertyName1];
				
				_valueSetProgrammatically = true;
				_spinner2.value = _spinner1.value;
				_valueSetProgrammatically = false;
			}
			
			fireDataChangedSignal();
		}

		protected function spinner2DataChanged (c : Component, v : * ) : void 
		{
			if( _valueSetProgrammatically )
				return;
			
			_value[ _propertyName2 ] = _spinner2.value;
			if( _valuesLocked )
			{
				_value[_propertyName1] = _value[_propertyName2];
				
				_valueSetProgrammatically = true;
				_spinner1.value = _spinner2.value;
				_valueSetProgrammatically = false;
			}
			fireDataChangedSignal();
		}
		
		public function get valuesLocked () : Boolean { return _valuesLocked; }		
		public function set valuesLocked (valuesLocked : Boolean) : void
		{
			_valuesLocked = valuesLocked;
		}
		
		public function get value () : * { return _value; }	
		public function set value ( value : * ) : void
		{
			
			checkProperties( value as Object, _propertyName1 );
			checkProperties( value as Object, _propertyName2 );
			
			_value = value as Object;
			
			_valueSetProgrammatically = true;
			_spinner1.value = _value[ _propertyName1 ];
			_spinner2.value = _value[ _propertyName2 ];
			_valueSetProgrammatically = false;
		}
		
		public function get propertyName1 () : String { return _propertyName1; }		
		public function set propertyName1 (propertyName : String) : void
		{
			checkProperties(_value, propertyName);
			
			_propertyName1 = propertyName;
			_label1.value = _propertyName1;
			_spinner1.value = _value[ _propertyName1 ];
		}

		public function get propertyName2 () : String { return _propertyName2; }		
		public function set propertyName2 (propertyName : String) : void
		{
			checkProperties(_value, propertyName);
			
			_propertyName2 = propertyName;
			_label2.value = _propertyName2;
			_spinner2.value = _value[ _propertyName2 ];
		}

		protected function checkProperties (value : Object, propertyName : String) : void
		{
			if( !value.hasOwnProperty(propertyName) )
				throw new Error( _$(_("The object $0 don't have any propertie named $1"), value, propertyName ) );
		}

		protected function fireDataChangedSignal () : void 
		{
			_dataChanged.dispatch( this, value );
		}
	}
}
