package abe.com.edia.keyboard
{
    import org.osflash.signals.Signal;

    import flash.events.KeyboardEvent;
    import flash.utils.getTimer;

	public class KeyCombinator
	{
		static public const SIMULTANEOUS : Number = 60;
		static public const CHAINED : Number = 300;
		static public const HOLDED : Number = 800;
		
		static public const HOLD : String = "…";
		static public const CHAIN : String = "+";
        
        public var keyPressed : Signal;
        public var keyReleased : Signal;
        public var keySequenceFound : Signal;
		
		protected var _enabled : Boolean;
		protected var _filter : KeyCombinatorFilter;
		
		protected var _lastTime : Number;
		protected var _lastSequence : String;
		protected var _lastKey : String;
		
		protected var _keysHolded : Number;
		protected var _keysPressed : Object;
		protected var _labelPressed : Object;
		protected var _simultaneousKeysEnabled : Boolean;
		protected var _chainedKeysEnabled : Boolean;
		protected var _holdedKeysEnabled : Boolean;

		public function KeyCombinator ( filter : KeyCombinatorFilter = null,
										chainedKeysEnabled : Boolean = true,
										simultaneousKeysEnabled : Boolean = true,
										holdedKeysEnabled : Boolean = true )
		{
			_enabled = true;
			_lastTime = 0;
			_keysHolded = 0;
			_lastSequence = "";
			_keysPressed = {};			
			_labelPressed = {};			
			_filter = filter;
			_simultaneousKeysEnabled = simultaneousKeysEnabled;
			_chainedKeysEnabled = chainedKeysEnabled;
			_holdedKeysEnabled = holdedKeysEnabled;
            
            keyPressed = new Signal();
            keyReleased = new Signal();
            keySequenceFound = new Signal();
		}
/*-----------------------------------------------------------------------*
 * 	GETTER/SETTER
 *-----------------------------------------------------------------------*/	
		public function get enabled () : Boolean { return _enabled; }	
		public function set enabled (enabled : Boolean) : void
		{
			_enabled = enabled;
		}
		public function get simultaneousKeysEnabled () : Boolean { return _simultaneousKeysEnabled; }		
		public function set simultaneousKeysEnabled (simultaneousKeysEnabled : Boolean) : void
		{
			_simultaneousKeysEnabled = simultaneousKeysEnabled;
		}
		public function get chainedKeysEnabled () : Boolean { return _chainedKeysEnabled; }		
		public function set chainedKeysEnabled (chainedKeysEnabled : Boolean) : void
		{
			_chainedKeysEnabled = chainedKeysEnabled;
		}
		public function get holdedKeysEnabled () : Boolean { return _holdedKeysEnabled; }		
		public function set holdedKeysEnabled (holdedKeysEnabled : Boolean) : void
		{
			_holdedKeysEnabled = holdedKeysEnabled;
		}

/*-----------------------------------------------------------------------*
 * 	PUBLIC METHODS
 *-----------------------------------------------------------------------*/	

		public function clearCurrentSequence () : void
		{
			_lastSequence = "";
		}
		public function setSequence ( key : String ) : void
		{
			_lastSequence = key;
		}
		public function hasSequence () : Boolean
		{
			return _lastSequence != "";
		}		
		public function isPressed ( key : Number ) : Boolean
		{
			return _keysPressed[ key ];
		}
        public function isKeyActive ( key : String ) : Boolean
		{
			return _labelPressed[ key ];
		}
		public function checkForPressedKey () : void
		{
			loop : for( var i : String in _keysPressed )
			{
				if( _keysPressed [ i ] )
				{ 
					_lastSequence = i;
				}	
			}
		}
		protected function isValidKey ( keyCode : uint ) : Boolean
		{
			return _filter ? _filter.isValidKey(keyCode) : true;
		}	
		protected function getKeyMap ( keyCode : uint ) : String
		{
			return _filter ? _filter.getKeyMap( keyCode ) : String( keyCode );
		}

/*-----------------------------------------------------------------------*
 * 	EVENTS HANDLERS
 *-----------------------------------------------------------------------*/	

		public function keyDown ( e : KeyboardEvent ) : void
		{
			if( !_enabled ) return;
			
			var keyCode : Number = e.keyCode;
			
			// removing all non-valid keycodes, keys already pressed
			if( !isValidKey( keyCode ) ) return;
			if( _keysPressed[ keyCode ] ) return;
			
			// getting the corresponding action key
			var actionKey : String = getKeyMap(keyCode);
			
			// computing time
			var time : Number = getTimer();
			var timestep : Number = time - _lastTime;
			
			// if the sequence is clear but there's already pressed key
			// we search for the pressed key
			if( !hasSequence() && _keysHolded > 0 )
				checkForPressedKey ();
			
			if( hasSequence() )
			{
				// we can't actually get a real simultaneous combination of key
				// so we look for a really small time step between the two events
				if( _simultaneousKeysEnabled && timestep < SIMULTANEOUS )
				{
					_lastSequence += actionKey;
				}
				// the time step is shorter enough to trigger a key chain
				else if( _chainedKeysEnabled && timestep < CHAINED )
				{
					_lastSequence += CHAIN + actionKey;
				}
				// one or more keys are holded and one new key is pressed
				// 
				else if( _holdedKeysEnabled && timestep >= CHAINED && _keysHolded > 0 )
				{
					_lastSequence += HOLD + actionKey;
				}
				// simple case, the new key is the sole key
				else
				{
					_lastSequence = actionKey;
				}
			}
			// simple case again, the new key is the sole key
			else
			{
				_lastSequence = actionKey;
			}
				
			// updating states of the controller
			_keysHolded++;
			_lastKey = actionKey;
			_keysPressed[ keyCode ] = true;
			_labelPressed[ _filter.getKeyMap(keyCode) ] = true;
			_lastTime = time;
			
			// firing events
			fireKeyPressedSignal( actionKey );
			fireKeySequenceFoundSignal( _lastSequence, actionKey );
		}	
		public function keyUp ( e : KeyboardEvent ) : void
		{
			if( !_enabled ) return;
			
			var keyCode : Number = e.keyCode;
			
			// removing all non-valid cases
			if( !isValidKey( keyCode ) ) return;
			
			// getting the corresponding action key
			var actionKey : String = getKeyMap( keyCode );
			
			// computing time
			var time : Number = getTimer();
			var timestep : Number = time - _lastTime;
			
			//BlitDebug.DEBUG( "up keycode " + keyCode + ", " + actionKey + ", " + timestep + " ms" );

			// if the key is released more than one seconds after the press
			// and if it's the last pressed key we trigger a holded sequence
			if( timestep > HOLDED && _lastKey == actionKey )
			{
				_lastSequence += HOLD;
				
				// a new sequence have bben find, so we clear time
				_lastTime = time;
				
				fireKeySequenceFoundSignal( _lastSequence, actionKey );
			}
			
			// updating controller states
			_lastKey = "";
			_keysPressed[ keyCode ] = false;
            _labelPressed[ _filter.getKeyMap(keyCode) ] = false;
			_keysHolded--;
			if( _keysHolded < 0 )
				_keysHolded = 0;
			
			// firing events
			fireKeyReleasedSignal( actionKey );
		}
		
/*-----------------------------------------------------------------------*
 * 	EVENTS DISPATCHING
 *-----------------------------------------------------------------------*/
 		
		protected function fireKeySequenceFoundSignal ( sequence : String, key : String ) : void
		{
			keySequenceFound.dispatch( this, sequence, key );
		}
		protected function fireKeyPressedSignal ( sequence : String ) : void
		{
			keyPressed.dispatch(this, sequence);
		}	
		protected function fireKeyReleasedSignal ( sequence : String ) : void
		{
			keyReleased.dispatch(this, sequence);
		}
	}
}
