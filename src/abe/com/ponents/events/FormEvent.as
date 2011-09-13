package abe.com.ponents.events 
{
    import abe.com.ponents.forms.FormField;

    import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class FormEvent extends Event 
	{
		static public const SHARED_FIELD : String = "sharedField";
		static public const UNDEFINED_FIELD : String = "undefinedField";
		static public const DIFFERENT_FIELDS : String = "differentFields";
		
		public var formField : FormField;

		public function FormEvent (type : String, formField : FormField, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.formField = formField;
		}
	}
}
