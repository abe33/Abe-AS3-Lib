package abe.com.edia.keyboard
{
	/**
	 * @author cedric
	 */
	public class KeyCombinatorFilter 
	{
		protected var _keyMap : Object;
		
		public function KeyCombinatorFilter ( keyMap : Object = null )
		{
			_keyMap = keyMap ? keyMap : {};
		}
		public function isValidKey( keyCode : uint ) : Boolean
		{
			return _keyMap.hasOwnProperty( keyCode );
		}
		public function getKeyMap ( keyCode : uint ) : String
		{
			if( isValidKey(keyCode) )
				return _keyMap[keyCode];
			
			return null;
		}
	}
}
