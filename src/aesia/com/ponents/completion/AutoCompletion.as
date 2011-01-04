package aesia.com.ponents.completion 
{
	import aesia.com.ponents.events.AutoCompletionEvent;
	import aesia.com.ponents.text.AbstractTextComponent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="entriesFound", type="aesia.com.ponents.events.AutoCompletionEvent")]
	[Event(name="entriesLoaded", type="aesia.com.ponents.events.AutoCompletionEvent")]
	/**
	 * @author Cédric Néhémie
	 */
	public class AutoCompletion extends EventDispatcher 
	{
		protected var _textField : AbstractTextComponent;
		protected var _lastSuggestions : Array;
		protected var _lastSuggestionsCount : Number;
		protected var _last : String;
		protected var _enabled : Boolean;
		protected var _collection : Array;
		protected var _checkWordAtCaret : Boolean;
		
		public var charactersCountBeforeSuggest : Number = 1;
		
		public function AutoCompletion ( textField : AbstractTextComponent ) 
		{
			super();
			this._textField = textField;
			this._collection = [];
			this._enabled = true;
			this._lastSuggestions = [];
			_checkWordAtCaret = false;
			textField.addEventListener( Event.CHANGE, changed );
		}
		public function get last () : String { return _last; }
		
		public function get lastSuggestions () : Array { return _lastSuggestions; }	
		public function get lastSuggestionsCount () : Number { return _lastSuggestions.length; }
		
		public function get collection () : Array {	return _collection;	}
		public function set collection ( a : Array ) : void
		{
			_collection = a;
			_collection.sort();
			dispatchEvent( new AutoCompletionEvent( AutoCompletionEvent.ENTRIES_LOADED ) );
		}
		
		public function get checkWordAtCaret () : Boolean { return _checkWordAtCaret; }	
		public function set checkWordAtCaret (checkWordAtCaret : Boolean) : void
		{
			_checkWordAtCaret = checkWordAtCaret;
		}
		
		public function get enabled () : Boolean { return _enabled;	}
		public function set enabled ( b : Boolean ) : void
		{
			this._enabled = b;
		}
		
		protected function retreiveCollection () : void
		{}

		public function check ( match : String  ) : void
		{
			if( match.length >= charactersCountBeforeSuggest )
			{
				var propositions : Array = [];
				var l : Number = _collection.length;
				for(var i : Number = 0; i < l ;i++)
				{
					var s : String = _collection[i];
					
					if( s.toLowerCase().indexOf( match.toLowerCase() ) == 0 && s != "" )
					{
						propositions.push( s );
					}
				}
				l = propositions.length;
				if(l != 0 || _lastSuggestionsCount != l)
				{
					_lastSuggestionsCount = l;
					_lastSuggestions = propositions;
					dispatchEvent( new AutoCompletionEvent( AutoCompletionEvent.ENTRIES_FOUND ) );
				}
			}
			else if( _lastSuggestions.length != 0 )
			{
				_lastSuggestions = [];
				dispatchEvent( new AutoCompletionEvent( AutoCompletionEvent.ENTRIES_FOUND ) );
			}
		}		

		public function changed ( e : Event = null ) : void
		{
			if( _enabled )
			{
				var current : String;
				if( _checkWordAtCaret )
					current = _textField.getWordAt( _textField.caretIndex );
				else
					current = _textField.text;
				
				if( current && current != _last )
				{
					_last = current;
					check(current);
				}					
			}
		}
		
		public function forceChanged ( e : Event = null ) : void
		{
			if( _enabled )
			{
				var current : String;
				
				if( _checkWordAtCaret )
					current = _textField.getWordAt( _textField.caretIndex );
				else
					current = _textField.text;
				
				if( current )
				{
					_last = current;
					check(current);
				}	
			}
		}
		
		
		/**
		 * Réécriture de la méthode <code>dispatchEvent</code> afin d'éviter la diffusion
		 * d'évènement en l'absence d'écouteurs pour cet évènement.
		 * 
		 * @param	evt	objet évènement à diffuser
		 * @return	<code>true</code> si l'évènement a bien été diffusé, <code>false</code>
		 * 			en cas d'échec ou d'appel de la méthode <code>preventDefault</code>
		 * 			sur cet objet évènement
		 */
		override public function dispatchEvent( evt : Event ) : Boolean 
		{
		 	if ( hasEventListener(evt.type) || evt.bubbles) 
		 	{
		  		return super.dispatchEvent(evt);
		  	}
		 	return true;
		}
	}
}
