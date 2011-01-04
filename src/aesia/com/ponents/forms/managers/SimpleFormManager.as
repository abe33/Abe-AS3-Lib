package aesia.com.ponents.forms.managers 
{
	import aesia.com.mon.core.Allocable;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.forms.FormField;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.text.AbstractTextComponent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="change",type="flash.events.Event")]	[Event(name="propertyChange",type="aesia.com.ponents.events.PropertyEvent")]
	/**
	 * @author Cédric Néhémie
	 */
	public class SimpleFormManager extends EventDispatcher implements Allocable
	{
		protected var _formObject : FormObject;
		public function SimpleFormManager ( fo : FormObject = null )
		{
			if( fo )
				formObject = fo;
		}
		public function get formObject () : FormObject { return _formObject; }		public function set formObject ( o : FormObject ) : void
		{ 
			if( _formObject )
				dispose();
			
			_formObject = o;
			
			if( _formObject )
				init();
		}
		public function save () : void
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.component && f.component is AbstractTextComponent )
				  ( f.component as AbstractTextComponent ).registerValue();
			
			updateTargetWithFields();
		}
		public function init () : void
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.component )
					f.component.addEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
		}
		
		public function dispose () : void
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.component )
					f.component.removeEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
		}
		
		public function updateFieldsWithTarget () : void
		{
			for each ( var f: FormField in _formObject.fields )
			{
				if( f.component )
				{
					f.component["value"] = _formObject.target[ f.memberName ];
					f.component.invalidate(true);
				}
			}
				
			fireChangeEvent ();
		}
		
		public function updateTargetWithFields () : void
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.component && f.component.enabled )
					_formObject.target[ f.memberName ] = f.component["value"];
			
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
			_formObject.target[ name ] = value;
			firePropertyEvent( name , value );
			fireChangeEvent ();
		}
		
		public function dataChanged ( e : ComponentEvent ) : void
		{
			var field : FormField = getFieldByComponent( e.target as Component );
			fieldChanged( field.memberName, field.component["value"] );
			fireChangeEvent ();
		}

		protected function firePropertyEvent ( name : String, v : *) : void
		{
			dispatchEvent( new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, name, v ) );
		}
		protected function fireChangeEvent () : void
		{
			dispatchEvent( new Event(Event.CHANGE ));
		}
	}
}
