package aesia.com.ponents.skinning.cursors 
{
	public class SystemCursor extends Cursor 
	{
		protected var _systemCursorName : String;
		
		public function SystemCursor ( name : String )
		{
			super( null, null );
			systemCursorName = name;
		}
		
		public function get systemCursorName () : String
		{
			return _systemCursorName;
		}		
		public function set systemCursorName (systemCursorName : String) : void
		{
			_systemCursorName = systemCursorName;
		}
	}
}
