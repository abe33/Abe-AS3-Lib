package abe.com.ponents.text 
{
    import abe.com.mon.geom.Range;

    import com.adobe.linguistics.spelling.HunspellDictionary;
    import com.adobe.linguistics.spelling.SpellChecker;

    import flash.events.Event;
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

		public function loadDictionary ( rules : String, dict : String, callback : Function = null ) : void
		{
			if( _loadingDictionaries[ rules ] )
			{
				if( _callbacks[ rules ] )
				{
					if( _callbacks[ rules ] is Function )
						_callbacks[ rules ] = [ _callbacks[ rules ], callback ];
					else if( _callbacks[ rules ] is Array )
						( _callbacks[ rules ] as Array ).push( callback );
				}
				else
					_callbacks[ rules ] = callback;
			}
			else if( _spellCheckers[ rules ] )
			{
				callback( _spellCheckers[ rules ] );
			}
			else
			{
				var dic : HunspellDictionary = new HunspellDictionary();
				_loadingDictionaries[ rules ] = dic;
				_callbacks[ rules ] = callback;
				
				dic.addEventListener( Event.COMPLETE, handleLoadComplete );			
				dic.load( rules, dict );			
			}
		}
		protected function handleLoadComplete(e:Event):void
        {
        	var dic : HunspellDictionary = e.target as HunspellDictionary;
        	
        	var index : String = indexOf( dic );
        	
        	if( index )
        		delete _loadingDictionaries[ index ];
        
        	var checker : SpellChecker = new SpellChecker( dic );
        	
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

        protected function indexOf( dic : HunspellDictionary ) : String
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
