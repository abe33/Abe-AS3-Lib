package abe.com.ponents.forms.managers 
{
    import abe.com.ponents.forms.fields.SubObjectFormComponent;
    import abe.com.mon.core.Allocable;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.forms.FormField;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.text.AbstractTextComponent;

    import org.osflash.signals.Signal;

	/**
	 * @author Cédric Néhémie
	 */
	public class SimpleFormManager implements Allocable
	{
	    public var formChanged : Signal;
	    public var propertyChanged : Signal;
	
		protected var _formObject : FormObject;
		public function SimpleFormManager ( fo : FormObject = null )
		{
			if( fo )
				formObject = fo;
			
			formChanged = new Signal();
			propertyChanged = new Signal();
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
				{
				    if( f.component is FormComponent || ( f.component as Object ).hasOwnProperty( "dataChanged" ) )
					    f.component["dataChanged"].add( dataChanged );
				}
		}
		
		public function dispose () : void
		{
			for each ( var f: FormField in _formObject.fields )
				 if( f.component is FormComponent || ( f.component as Object ).hasOwnProperty( "dataChanged" ) )
					    f.component["dataChanged"].remove( dataChanged );
		}
		
		public function updateFieldsWithTarget () : void
		{
			for each ( var f: FormField in _formObject.fields )
			{
				if( f.component )
				{
					f.component["value"] = _formObject.target[ f.memberName ];
					f.component.invalidate(true);
                    
                    if( f.component is SubObjectFormComponent )
                        ( f.component as SubObjectFormComponent ).owner = _formObject.target;
				}
			}
			fireFormChangedSignal ();
		}
		
		public function updateTargetWithFields () : void
		{
			for each ( var f: FormField in _formObject.fields )
				if( f.component && f.component.enabled )
					_formObject.target[ f.memberName ] = f.component["value"];
			
			fireFormChangedSignal();
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
			firePropertyChangedSignal( name , value );
			fireFormChangedSignal ();
		}
		
		public function dataChanged ( c : Component, v : * ) : void
		{
			var field : FormField = getFieldByComponent( c );
			fieldChanged( field.memberName, field.component["value"] );
		}

		protected function firePropertyChangedSignal ( name : String, v : *) : void
		{
			propertyChanged.dispatch( name, v );
		}
		protected function fireFormChangedSignal () : void
		{
			formChanged.dispatch( this );
		}
	}
}
