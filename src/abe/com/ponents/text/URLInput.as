package abe.com.ponents.text 
{
    import flash.net.URLRequest;
	/**
	 * @author cedric
	 */
	public class URLInput extends TextInput 
	{
		public function URLInput (maxChars : int = 0, password : Boolean = false, autoCompletionKey : String = null, showLastValueAtStartup : Boolean = false)
		{
			super( maxChars, password, autoCompletionKey, showLastValueAtStartup );
		}

		override public function get value () : * { return new URLRequest( super.value ); }
		override public function set value (val : *) : void
		{
			super.value = val is URLRequest ? val.url : val;
		}
	}
}
