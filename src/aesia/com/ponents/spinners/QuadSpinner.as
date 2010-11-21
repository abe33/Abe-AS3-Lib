package aesia.com.ponents.spinners 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.buttons.LockerButton;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.layouts.components.ColumnSettings;
	import aesia.com.ponents.layouts.components.ColumnsLayout;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.text.Label;

	/**
	 * @author cedric
	 */
	[Event(name="dataChange", type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="EmptyComponent")]
	public class QuadSpinner extends AbstractContainer implements FormComponent 
	{
		protected var _spinner1 : Spinner;
		protected var _spinner2 : Spinner;		protected var _spinner3 : Spinner;		protected var _spinner4 : Spinner;
		
		protected var _label1 : Label;
		protected var _label2 : Label;		protected var _label3 : Label;		protected var _label4 : Label;
		
		protected var _lockButton : LockerButton;
		
		protected var _value : Object;
		protected var _valuesLocked : Boolean;
		
		protected var _propertyName1 : String;				protected var _propertyName2 : String;		protected var _propertyName3 : String;
		protected var _propertyName4 : String;
		
		private var _valueSetProgrammatically : Boolean;

		public function QuadSpinner ( value : Object, 
									  property1 : String, 
									  property2 : String, 									  property3 : String, 									  property4 : String, 
									  min : Number = 0, 
									  max : Number = 10, 
									  step : Number = 1, 
									  intOnly : Boolean = false )
		{
			super();
			
			_propertyName1 = property1;
			_propertyName2 = property2;			_propertyName3 = property3;			_propertyName4 = property4;
			
			_spinner1 = new Spinner( new SpinnerNumberModel( 0, min, max, step, intOnly ) );
			_spinner2 = new Spinner( new SpinnerNumberModel( 0, min, max, step, intOnly ) );			_spinner3 = new Spinner( new SpinnerNumberModel( 0, min, max, step, intOnly ) );			_spinner4 = new Spinner( new SpinnerNumberModel( 0, min, max, step, intOnly ) );
			
			_label1 = new Label( property1 );
			_label2 = new Label( property2 );			_label3 = new Label( property3 );			_label4 = new Label( property4 );
			
			_lockButton = new LockerButton();
			_lockButton.allowFocus = false;
			
			_label1.isComponentIndependent = false;
			_label2.isComponentIndependent = false;			_label3.isComponentIndependent = false;			_label4.isComponentIndependent = false;
			_spinner1.isComponentIndependent = false;
			_spinner2.isComponentIndependent = false;			_spinner3.isComponentIndependent = false;			_spinner4.isComponentIndependent = false;
			_lockButton.isComponentIndependent = false;
			
			_valuesLocked = false;
			
			this.value = value;
			
			addComponent( _label1 );			addComponent( _spinner1 );			addComponent( _spinner2 );
			addComponent( _label2 );
			addComponent( _label3 );
			addComponent( _spinner3 );
			addComponent( _spinner4 );
			addComponent( _label4 );
			addComponent( _lockButton );
			
			childrenLayout = new ColumnsLayout( this, 3, 
												new ColumnSettings("right", "top", 3, true, _label1, _label3 ),												new ColumnSettings("right", "top", 3, false, _spinner1, _spinner3 ),												new ColumnSettings("center", "center", 3, false, _lockButton ),												new ColumnSettings("left", "top", 3, false, _spinner2, _spinner4 ),												new ColumnSettings("left", "top", 3, true, _label2, _label4 )
												);
		}
		
		
		public function get value () : * { return _value; }	
		public function set value (value : * ) : void
		{
			checkProperties( value as Object, _propertyName1 );
			checkProperties( value as Object, _propertyName2 );			checkProperties( value as Object, _propertyName3 );			checkProperties( value as Object, _propertyName4 );
			
			_value = value as Object;
			
			_valueSetProgrammatically = true;
			_spinner1.value = _value[ _propertyName1 ];
			
			_valueSetProgrammatically = true;
			_spinner2.value = _value[ _propertyName2 ];
			
			_valueSetProgrammatically = true;
			_spinner3.value = _value[ _propertyName3 ];
			
			_valueSetProgrammatically = true;
			_spinner4.value = _value[ _propertyName4 ];
			
			_valueSetProgrammatically = false;
		}
				
		public function get disabledMode () : uint { return _spinner1.disabledMode;	}

		public function set disabledMode (b : uint) : void
		{
			_spinner1.disabledMode = b;
			_spinner2.disabledMode = b;			_spinner3.disabledMode = b;			_spinner4.disabledMode = b;
		}
		
		public function get disabledValue () : * {}		
		public function set disabledValue (v : *) : void
		{
		}

		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			
			_spinner1.addEventListener(ComponentEvent.DATA_CHANGE, spinner1DataChange );
			_spinner2.addEventListener(ComponentEvent.DATA_CHANGE, spinner2DataChange );
			_spinner3.addEventListener(ComponentEvent.DATA_CHANGE, spinner3DataChange );
			_spinner4.addEventListener(ComponentEvent.DATA_CHANGE, spinner4DataChange );
			
			_lockButton.addEventListener(ComponentEvent.DATA_CHANGE, lockDataChange );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			
			_spinner1.removeEventListener(ComponentEvent.DATA_CHANGE, spinner1DataChange );
			_spinner2.removeEventListener(ComponentEvent.DATA_CHANGE, spinner2DataChange );
			_spinner3.removeEventListener(ComponentEvent.DATA_CHANGE, spinner3DataChange );
			_spinner4.removeEventListener(ComponentEvent.DATA_CHANGE, spinner4DataChange );
			
			_lockButton.addEventListener(ComponentEvent.DATA_CHANGE, lockDataChange );
		}

		protected function checkProperties (value : Object, propertyName : String) : void
		{
			if( !value.hasOwnProperty(propertyName) )
				throw new Error( _$(_("The object $0 don't have any propertie named $1"), value, propertyName ) );
		}
		
		protected function lockDataChange (event : ComponentEvent) : void 
		{
			event.stopImmediatePropagation();
			_valuesLocked = _lockButton.selected;
			
			if( _valuesLocked )
			{
				_value[_propertyName2] = _value[_propertyName1];				_value[_propertyName3] = _value[_propertyName1];				_value[_propertyName4] = _value[_propertyName1];
				
				_valueSetProgrammatically = true;
								_spinner2.value = _spinner1.value;				_spinner3.value = _spinner1.value;
				_spinner4.value = _spinner1.value;
				
				_valueSetProgrammatically = false;
				
			}
			fireDataChange();
		}
		
		protected function spinner1DataChange (event : ComponentEvent) : void 
		{
			if( _valueSetProgrammatically )
				return;
			
			_value[ _propertyName1 ] = _spinner1.value;
			
			if( _valuesLocked )
			{
				_value[_propertyName2] = _value[_propertyName1];				_value[_propertyName3] = _value[_propertyName1];				_value[_propertyName4] = _value[_propertyName1];
				
				_valueSetProgrammatically = true;
				
				_spinner2.value = _spinner1.value;				_spinner3.value = _spinner1.value;				_spinner4.value = _spinner1.value;
				
				_valueSetProgrammatically = false;
			}
			fireDataChange();
		}

		protected function spinner2DataChange (event : ComponentEvent) : void 
		{
			event.stopImmediatePropagation();
			if( _valueSetProgrammatically )
				return;
			
			_value[ _propertyName2 ] = _spinner2.value;
			
			if( _valuesLocked )
			{
				_value[_propertyName1] = _value[_propertyName2];				_value[_propertyName3] = _value[_propertyName2];				_value[_propertyName4] = _value[_propertyName2];
				
				_valueSetProgrammatically = true;
				
				_spinner1.value = _spinner2.value;				_spinner3.value = _spinner2.value;				_spinner4.value = _spinner2.value;
				
				_valueSetProgrammatically = false;
			}
			fireDataChange();
		}
		
		protected function spinner3DataChange (event : ComponentEvent) : void 
		{
			event.stopImmediatePropagation();
			if( _valueSetProgrammatically )
				return;
			
			_value[ _propertyName3 ] = _spinner3.value;
			
			if( _valuesLocked )
			{
				_value[_propertyName1] = _value[_propertyName3];
				_value[_propertyName2] = _value[_propertyName3];
				_value[_propertyName4] = _value[_propertyName3];
				
				_valueSetProgrammatically = true;
				
				_spinner1.value = _spinner3.value;
				_spinner2.value = _spinner3.value;
				_spinner4.value = _spinner3.value;
				
				_valueSetProgrammatically = false;
			}
			fireDataChange();
		}
		
		protected function spinner4DataChange (event : ComponentEvent) : void 
		{
			event.stopImmediatePropagation();
			if( _valueSetProgrammatically )
				return;
			
			_value[ _propertyName4 ] = _spinner4.value;
			
			if( _valuesLocked )
			{
				_value[_propertyName1] = _value[_propertyName4];
				_value[_propertyName2] = _value[_propertyName4];
				_value[_propertyName3] = _value[_propertyName4];
				
				_valueSetProgrammatically = true;
				
				_spinner1.value = _spinner4.value;
				_spinner2.value = _spinner4.value;
				_spinner3.value = _spinner4.value;
				
				_valueSetProgrammatically = false;
			}
			fireDataChange();
		}
		
		public function get valuesLocked () : Boolean { return _valuesLocked; }		
		public function set valuesLocked (valuesLocked : Boolean) : void
		{
			_valuesLocked = valuesLocked;
			fireDataChange();
		}
		
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}
