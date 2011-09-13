package abe.com.ponents.completion 
{
    import abe.com.patibility.settings.SettingsManagerInstance;
    import abe.com.ponents.text.AbstractTextComponent;
	public class InputMemory extends AutoCompletion
	{
		// id du champ en mémoire
		private var _id : String;

		// dernière valeur saisie
		private var _lastValue : String;
		private var _showLastValue : Boolean;

		public function InputMemory (tf : AbstractTextComponent, id : String = "default", showLast : Boolean = false )
		{
			super( tf );
			_id = id;
			_showLastValue = showLast;

			setup();
		}
		
		public function get showLastValue () : Boolean { return _showLastValue; }		
		public function set showLastValue (showLastValue : Boolean) : void
		{
			_showLastValue = showLastValue;
			if(_showLastValue && _textField )
				_textField.value = _lastValue ? _lastValue : "";
		}
		
		public function get lastValue () : String { return _lastValue; }		
		
		public function get id () : String { return _id; }
		public function set id (id : String) : void
		{
			_id = id;
			retreiveCollection();
		}
		
		public function setup () : void
		{		
			retreiveCollection();
			if(_showLastValue)
				_textField.value = _lastValue ? _lastValue : "";
		}		
		override protected function retreiveCollection () : void
		{
			var save:* = SettingsManagerInstance.get( this, "entries" );
			_lastValue = SettingsManagerInstance.get( this, "lastValue" );
			
			if( save != null )
			{
				if( save is String )
				{
					var a:Array = save.split("\n");
					a.sort();
					collection = a;
				}
				else if( save is Array )
				{
					save.sort();
					collection = save;
				}
			}
		}

		public function registerCurrent () : void
		{
			var current : String = _textField.value;
			
			SettingsManagerInstance.set( this, "lastValue", current );
	
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
		
			SettingsManagerInstance.set( this, "entries", collection );
		}
		
		public function removeEntry ( entry : String ) : void
		{
			if( collection.indexOf( entry ) != -1 )
			{
				collection.splice( collection.indexOf( entry ), 1 );
				SettingsManagerInstance.set( this, "entries", collection );
			}
		}

		public function clearMemory () : void
		{
			SettingsManagerInstance.set( this, "entries", null );			SettingsManagerInstance.set( this, "lastValue", null );
			collection = [];
		}
	}
}
