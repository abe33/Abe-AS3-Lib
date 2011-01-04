package aesia.com.ponents.text 
{
	import aesia.com.mon.geom.Range;

	import com.adobe.linguistics.spelling.SpellChecker;
	import com.adobe.linguistics.spelling.SpellingDictionary;

	import flash.events.Event;
	import flash.net.URLRequest;

	public class SpellCheckManager 
	{
		protected var _spellCheckers : Object;
		protected var _loadingDictionaries : Object;
		protected var _callbacks : Object;
		
		public function SpellCheckManager ()
		{
			_spellCheckers = {};
			_loadingDictionaries = {};
			_callbacks = {};
		}

		public function loadDictionary ( url : String, callback : Function = null ) : void
		{
			if( _loadingDictionaries[ url ] )
			{
				if( _callbacks[ url ] )
				{
					if( _callbacks[ url ] is Function )
						_callbacks[ url ] = [ _callbacks[ url ], callback ];
					else if( _callbacks[ url ] is Array )
						( _callbacks[ url ] as Array ).push( callback );
				}
				else
					_callbacks[ url ] = callback;
			}
			else if( _spellCheckers[ url ] )
			{
				callback( _spellCheckers[ url ] );
			}
			else
			{
				var dic : SpellingDictionary = new SpellingDictionary();
				_loadingDictionaries[ url ] = dic;
				_callbacks[ url ] = callback;
				
				dic.addEventListener( Event.COMPLETE, handleLoadComplete );			
				dic.load( new URLRequest( url ) );			
			}
		}
		protected function handleLoadComplete(e:Event):void
        {
        	var dic : SpellingDictionary = e.target as SpellingDictionary;
        	
        	var index : String = indexOf( dic );
        	
        	if( index )
        		delete _loadingDictionaries[ index ];
        
        	var checker : SpellChecker = new SpellChecker();
			checker.addDictionary( dic );
        	
			_spellCheckers[ index ] = checker;
			var callback : * = _callbacks[ index ];
			if( callback )
			{
				if( callback is Function )
					callback( checker );
				else if(callback is Array )
				{
					var a : Array = callback as Array;
					var l : Number = a.length;
					for(var i : int = 0; i<l;i++)
						a[i]( checker );
				}
			}
			delete _callbacks[ index ];
        }
        public function get ( id : String ) : SpellChecker
        {
        	if( _spellCheckers.hasOwnProperty( id ) )
        		return _spellCheckers[id] as SpellChecker;
        	else
        		return null;
		}
        /*FDT_IGNORE*/
        TARGET::FLASH_9
        public function checkText( value : String, sp : SpellChecker ) : Array { return _checkText(value, sp) as Array; }
        TARGET::FLASH_10
        public function checkText( value : String, sp : SpellChecker ) : Vector.<Range> { return Vector.<Range> ( _checkText(value, sp) ); }
        TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function checkText( value : String, sp : SpellChecker ) : Vector.<Range> { return Vector.<Range> ( _checkText(value, sp) ); }
        
        private function _checkText( value : String, sp:SpellChecker) : Object
        {
        	var wordPattern:RegExp =/\b\w+\b/; // match next word...
            var inputValue:String = value;
            var offset:int, curPos:int;
            
            /*FDT_IGNORE*/
            TARGET::FLASH_9 { var v : Array = []; }
            TARGET::FLASH_10 { var v : Vector.<Range> = new Vector.<Range>(); }
            TARGET::FLASH_10_1 { /*FDT_IGNORE*/
            var v : Vector.<Range> = new Vector.<Range>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
            
            for ( ; ; ) 
            {
                var res:Array = inputValue.match( wordPattern); // lookup word by word....
                if ( res == null ) break;
                if ( !sp.checkWord(res[0]) ) 
                {
                    offset = value.length-inputValue.length;
                    curPos = inputValue.indexOf(res[0]);
                    v.push( new Range( offset + curPos, 
                    				   offset + curPos + res[0].length) );
                }
                inputValue = inputValue.substr( inputValue.indexOf(res[0])+ res[0].length );
            }
            return v;
        }

        protected function indexOf( dic : SpellingDictionary ) : String
        {
        	for(var i : String in _loadingDictionaries )
        	{
        		if(_loadingDictionaries[ i ] == dic)
        			return i;
        	}
        	return null;
        }
	}
}
