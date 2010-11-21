package aesia.com.ponents.completion 
{
	import aesia.com.ponents.utils.SettingsMemoryChannels;
	import aesia.com.mon.utils.Cookie;
	import aesia.com.ponents.text.AbstractTextComponent;

	public class InputMemory extends AutoCompletion
	{
		// id du champ en mémoire
		private var _id : String;

		// dernière valeur saisie
		private var _lastValue : String;
		private var _showLastValue : Boolean;
		private var _cookie : Cookie;

		public function InputMemory (tf : AbstractTextComponent, id : String = "default", showLast : Boolean = false )
		{
			super( tf );
			_cookie = new Cookie( SettingsMemoryChannels.INPUTS );	
			_id = id;
			_showLastValue = showLast;

			setup();
		}
		
		public function get showLastValue () : Boolean { return _showLastValue; }		
		public function set showLastValue (showLastValue : Boolean) : void
		{
			_showLastValue = showLastValue;
		}
		
		public function get lastValue () : String { return _lastValue; }		
		public function get id () : String { return _id; }
		
		public function setup () : void
		{		
			retreiveCollection();
			if(_showLastValue)
				_textField.value = _lastValue ? _lastValue : "";
		}		
		override protected function retreiveCollection () : void
		{
			var save:String;
			if( _cookie[_id] )
			{
				save = _cookie[_id].entries as String;
				_lastValue = _cookie[_id].lastValue as String;
			}
			if( save != null )
			{
				var a:Array = save.split("\n");
				a.sort();
				collection = a;
			}
		}

		public function registerCurrent () : void
		{
			var current : String = _textField.value;
			if( !_cookie[_id] )
				_cookie[_id] = {};
				
			_cookie[_id].lastValue = current;

			if( current == "" )
				return;

			for(var i : String in collection)
			{
				if( collection[ i ] == current)
				{
					return;
				}
			}
			collection.push( current );
			collection.sort();
		
			_cookie[_id].entries = collection.join("\n");
		}
		
		public function removeEntry ( entry : String ) : void
		{
			if( collection.indexOf( entry ) != -1 )
			{
				collection.splice( collection.indexOf( entry ), 1 );
				_cookie[_id].entries = collection.join("\n");
			}
		}

		public function clearMemory () : void
		{
			_cookie[_id] = null;
			collection = [];
		}
	}
}
