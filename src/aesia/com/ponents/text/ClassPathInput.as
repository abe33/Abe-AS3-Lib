package aesia.com.ponents.text 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import aesia.com.ponents.text.TextInput;
	
	/**
	 * @author cedric
	 */
	public class ClassPathInput extends TextInput 
	{
		public function ClassPathInput (maxChars : int = 0, password : Boolean = false, autoCompletionKey : String = null, showLastValueAtStartup : Boolean = false)
		{
			super( maxChars, password, autoCompletionKey, showLastValueAtStartup );
		}
		override public function get value () : * { return getDefinitionByName( super.value ) as Class; }
		override public function set value (val : *) : void
		{
			super.value = val is Class ? getQualifiedClassName( val ) : val;
		}
	}
}
