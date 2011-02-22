package abe.com.ponents.forms.managers 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.magicClone;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.builder.dialogs.PreventOverrideDifferentValuesDialog;
	import abe.com.ponents.builder.dialogs.PreventOverrideSharedInstance;
	import abe.com.ponents.builder.dialogs.PreventOverrideUndefinedValue;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.containers.WarningDialog;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.events.FormEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.forms.FormField;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.FormUtils;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.utils.firstIndependentComponent;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	[Event(name="change",type="flash.events.Event")]	[Event(name="differentFields",type="abe.com.ponents.events.FormEvent")]	[Event(name="undefinedField",type="abe.com.ponents.events.FormEvent")]	[Event(name="sharedField",type="abe.com.ponents.events.FormEvent")]
	[Event(name="propertyChange",type="abe.com.ponents.events.PropertyEvent")]
	/**
	 * @author cedric
	 */
	public class MultiTargetFormManager extends EventDispatcher implements Allocable
	{
		public var preventModificationOfSharedValues : Function;
		
		protected var _formObject : FormObject;
		protected var _targets : Array;
		protected var _componentConcernedByWarning : Component;

		public function MultiTargetFormManager ( targets : Array = null, fo : FormObject = null )
		{
			if( fo != null )
				this.formObject = fo;
			
			if( targets != null )
				this.targets = targets;
		}
		public function get formObject () : FormObject { return _formObject; }
		public function set formObject ( o : FormObject ) : void
		{ 
			if( _formObject )
				dispose();
			
			_formObject = o;
			
			if( _formObject )
				init();
		}
		
		public function get targets () : Array { return _targets; }		
		public function set targets (targets : Array) : void
		{
			_targets = targets;
			
			var f: FormField;
			if( _targets && _targets.length > 0 )
			{
				var t : String = getQualifiedClassName( _targets[0] );
				for each( var o : * in _targets )
					if( getQualifiedClassName(o) != t )
						throw new Error( _("All targets in this MultiTargetFormManager must have the same type " + t) );
					
				updateFieldsWithTargets();
			}
			else
			{
				for each ( f in _formObject.fields )
				{
					f.component.enabled = false;
					if( f.component is FormComponent )
					{
						var fc : FormComponent = f.component as FormComponent;
						fc.disabledMode = FormComponentDisabledModes.UNDEFINED;
					}
				}
			}
		}
		
		public function init () : void
		{
			for each ( var f: FormField in _formObject.fields )
				f.component.addEventListener(ComponentEvent.DATA_CHANGE, dataChanged );
		}
		public function dispose () : void
		{
			for each ( var f: FormField in _formObject.fields )
				f.component.removeEventListener(ComponentEvent.DATA_CHANGE, dataChanged );
		}
		public function updateFieldsWithTargets () : void
		{
			var fc : FormComponent;
			
			var valuesWasShared : Boolean = false;
			var sharedProperties : Array = [];
			
			for each ( var f: FormField in _formObject.fields )
			{	
				f.component.removeEventListener( MouseEvent.CLICK, clickDifferentAcrossMany );				f.component.removeEventListener( MouseEvent.CLICK, clickUndefined );
							
				if( hasDifferentValuesAcrossTargets( f.memberName ) )
				{
					f.component.enabled = false;
					if( f.component is FormComponent )
					{
						fc = f.component as FormComponent;
						fc.disabledMode = FormComponentDisabledModes.DIFFERENT_ACROSS_MANY;
					}
					f.component.addEventListener(MouseEvent.CLICK, clickDifferentAcrossMany );
					fireDifferentFieldsEvent(f);
				}
				else
				{
					if( _targets[0][f.memberName] == null )
					{
						f.component.enabled = false;
						if( f.component is FormComponent )
						{
							fc = f.component as FormComponent;
							fc.disabledMode = FormComponentDisabledModes.UNDEFINED;
						}
						f.component.addEventListener(MouseEvent.CLICK, clickUndefined );
						fireUndefinedFieldEvent(f);
					}
					else
					{
						f.component.enabled = true;

						if( preventModificationOfSharedValues != null )
						{
							if( preventModificationOfSharedValues( _targets[0][f.memberName], f.memberName, _targets.length ) )
							{
								valuesWasShared = true;
								sharedProperties.push( f.memberName );
								f.component["value"] = magicClone(_targets[0][f.memberName]);
								fireSharedFieldEvent(f);
							}
							else
								f.component["value"] = _targets[0][f.memberName];
						}
						else
							f.component["value"] = _targets[0][f.memberName];
						
						f.component.invalidate(true);
					}
				}	
			}
			
			if( valuesWasShared )
			{
				var d:PreventOverrideSharedInstance = new PreventOverrideSharedInstance( "<li>" + sharedProperties.join("</li>\n<li>") + "</li>" );
				
				/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
				if( SettingsManagerInstance.get( d, "ignoreWarning" ) )
				{
					fireChangeEvent();
					return;
				}
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				d.open( Dialog.CLOSE_ON_RESULT );
			}
				
			fireChangeEvent ();
		}
		public function updateTargetsWithFields () : void
		{
			for each ( var f: FormField in _formObject.fields )
			{
				var l : uint = _targets.length;
				for(var i:int=0;i<l;i++)
					_targets[i][ f.memberName ] = f.component["value"];
			}
			dispatchEvent( new Event(Event.CHANGE ));
		}
		
		public function getFieldByComponent ( c : Component ) : FormField
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.component == c )
					return f;
			
			return null;
		}
		public function getFieldByName ( s : String ) : FormField
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.name == s )
					return f;
			
			return null;
		}
		public function getFieldByMemberName ( s : String ) : FormField
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.memberName == s )
					return f;
			
			return null;
		}
		
		protected function fieldChanged ( name : String, value : * ) : void
		{
			var l : uint = _targets.length;
			for(var i:int=0;i<l;i++)
				_targets[i][ name ] = value;
				
			firePropertyEvent( name , value );
			fireChangeEvent ();
		}
		
		public function dataChanged ( e : ComponentEvent ) : void
		{
			var field : FormField = getFieldByComponent( e.target as Component );
			fieldChanged( field.memberName, field.component["value"] );
			fireChangeEvent ();
		}
		
		protected function clickUndefined (event : MouseEvent) : void 
		{
			_componentConcernedByWarning = firstIndependentComponent( event.target as DisplayObject );
			var d : WarningDialog = new PreventOverrideUndefinedValue();
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( SettingsManagerInstance.get( d, "ignoreWarning" ) )
			{
				warnOverrideUndefinedValue();
				return;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			d.addWeakEventListener(DialogEvent.DIALOG_RESULT, warnOverrideUndefinedValue );
			d.open( Dialog.CLOSE_ON_RESULT );
		}
		
		protected function warnOverrideUndefinedValue ( e : DialogEvent = null ) : void
		{
			if( !e || e.result == Dialog.RESULTS_YES )
			{
				var f : FormField = getFieldByComponent( _componentConcernedByWarning );
				var t : Class = f.type;
				try
				{
					if( !( _componentConcernedByWarning is ComboBox ) )
						_componentConcernedByWarning["value"] = FormUtils.getNewValue( t );
					
					_componentConcernedByWarning.enabled = true;
					_componentConcernedByWarning.grabFocus();
					_componentConcernedByWarning.removeEventListener(MouseEvent.CLICK, clickUndefined );
				}
				catch( e : Error )
				{
					throw new Error( _$(_("The class $0 can't be instanciated with no arguments in its constructor function."), t ) );
				}
				(_componentConcernedByWarning as Object).click();
			}
			_componentConcernedByWarning = null;
		}

		protected function clickDifferentAcrossMany (event : MouseEvent) : void 
		{
			_componentConcernedByWarning = firstIndependentComponent( event.target as DisplayObject );
			var d : WarningDialog = new PreventOverrideDifferentValuesDialog();
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( SettingsManagerInstance.get( d, "ignoreWarning" ) )
			{
				warnOverrideDifferentValues();
				return;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			d.addWeakEventListener(DialogEvent.DIALOG_RESULT, warnOverrideDifferentValues );
			d.open( Dialog.CLOSE_ON_RESULT );
		}
		
		protected function warnOverrideDifferentValues ( e : DialogEvent = null ) : void
		{

			if( !e || e.result == Dialog.RESULTS_YES )
			{
				var f : FormField = getFieldByComponent( _componentConcernedByWarning );
				var t : Class = Reflection.getClass( _formObject.target[f.memberName] );
				try
				{
					if( !( _componentConcernedByWarning is ComboBox ) )
						_componentConcernedByWarning["value"] = new t();
					
					_componentConcernedByWarning.enabled = true;
					_componentConcernedByWarning.grabFocus();
					_componentConcernedByWarning.removeEventListener(MouseEvent.CLICK, clickDifferentAcrossMany );
				}
				catch( e : Error )
				{
					throw new Error( _$(_("The class $0 can't be instanciated with no arguments in its constructor function."), t ) );
				}
				(_componentConcernedByWarning as Object).click();
			}
			_componentConcernedByWarning = null;
		}

		protected function hasDifferentValuesAcrossTargets ( member : String ) : Boolean
		{
			var l : uint = _targets.length;
			var v : *;
			
				v = _targets[0][member];
			
			for(var i:int=0;i<l;i++)
				if( _targets[i][member] != v )
					return true;
					
			return false;
		}
		
		protected function firePropertyEvent ( name : String, v : *) : void
		{
			dispatchEvent( new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, name, v ) );
		}
		protected function fireChangeEvent () : void
		{
			dispatchEvent( new Event(Event.CHANGE ));
		}
		protected function fireSharedFieldEvent ( f : FormField ) : void
		{
			dispatchEvent( new FormEvent( FormEvent.SHARED_FIELD, f ) );
		}
		protected function fireUndefinedFieldEvent ( f : FormField ) : void
		{
			dispatchEvent( new FormEvent( FormEvent.UNDEFINED_FIELD, f ) );
		}
		protected function fireDifferentFieldsEvent ( f : FormField ) : void
		{
			dispatchEvent( new FormEvent( FormEvent.UNDEFINED_FIELD, f ) );
		}
	}
}
