
package abe.com.ponents.utils
{
    import abe.com.mands.Command;
    import abe.com.mands.NullCommand;
    import abe.com.mon.core.Cancelable;
    import abe.com.mon.core.ITextField;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Keys;
    import abe.com.ponents.core.*;

    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.text.TextFieldType;
    import flash.utils.Dictionary;
    
    public class KeyboardController
    {
        protected var _oKeyStrokes : Dictionary;
        protected var _aCurrentKeyStrokesContext : Dictionary;
        protected var _oCurrentCommand : Command;
        protected var _oEventProvider : InteractiveObject;

        public function KeyboardController ( eventProvider : InteractiveObject = null )
        {
            _oKeyStrokes = new Dictionary();
            _aCurrentKeyStrokesContext = new Dictionary( true );
            _oCurrentCommand = new NullCommand();
            
            if( eventProvider != null )
            {
                _oEventProvider = eventProvider;
                registerToEventProviderEvents( _oEventProvider );
            }
        }
        public function get eventProvider () : InteractiveObject { return _oEventProvider; }
        public function set eventProvider ( c : InteractiveObject ) : void
        {
            _oEventProvider = c;
            registerToEventProviderEvents( _oEventProvider );
        }
        public function restoreDefaultContext () : void
        {
            _aCurrentKeyStrokesContext = new Dictionary( true );
            appendToKeyStrokesContext( _oKeyStrokes, true );
        }
        protected function appendToKeyStrokesContext ( d : Dictionary, allowOverride : Boolean ) : void
        {
            for( var i : * in d )
            {
                if( allowOverride || !_aCurrentKeyStrokesContext[ i ] )
                    _aCurrentKeyStrokesContext[ i ] = d[ i ];
            }
        }
        public function addGlobalKeyStroke ( keyStroke : KeyStroke, c : Command ) : void
        {
            _oKeyStrokes[ keyStroke ] = c;
            _aCurrentKeyStrokesContext[ keyStroke ] = c ;
        }
        public function removeGlobalKeyStroke ( keyStroke : KeyStroke ) : void
        {
            delete _oKeyStrokes[ keyStroke ];
            delete _aCurrentKeyStrokesContext[ keyStroke ];
        }
        public function setKeyStrokesContext ( o : Component ) : void
        {
            FEATURES::KEYBOARD_CONTEXT { 
                _aCurrentKeyStrokesContext = new Dictionary( true );
                appendToKeyStrokesContext( _oKeyStrokes, true );
            
                var p : Container;
                var a : Array = [];
                var co : Component = o;
                
                if( !o )
                    return;
                    
                while( o )
                {
                    p = o.parentContainer;
                    if( p )
                        a.unshift(p);
                    o = p;
                }
                
                for each( var c : Container in a )
                {
                    if( !c.interactive )
                        return;
                    
                    appendToKeyStrokesContext( c.keyboardContext, true );
                    
                    if( !c.childrenContextEnabled )
                        return;
                }
                appendToKeyStrokesContext( co.keyboardContext, true );
            } 
        }
        protected function keyDown ( e : KeyboardEvent ) : void
        {            
            var k : KeyStroke = KeyStroke.getKeyStroke( e.keyCode, KeyStroke.getModifiers( e.ctrlKey, e.shiftKey, e.altKey ) );
            
            if( _aCurrentKeyStrokesContext[ k ] != null && !_oCurrentCommand.isRunning() )
            {
                var act : UserActionContext = new UserActionContext( UserActionContext.KEYBOARD_ACTION,
                                                                     e.keyCode, 
                                                                     e.ctrlKey,
                                                                     e.shiftKey,
                                                                     e.altKey );
                
                _oCurrentCommand = _aCurrentKeyStrokesContext[ k ] as Command;
                registerToCommandEvents( _oCurrentCommand );
                
                _oCurrentCommand.execute( act );
            }
        }
        protected function keyUp ( e : KeyboardEvent ) : void {}
        protected function focusIn ( e : FocusEvent ) : void
        {
            restoreDefaultContext();
            
            var d : DisplayObject = e.target as DisplayObject;
            
            while( d.parent )
            {
                var c : Component = d as Component;
                if( c != null )
                {
                    setKeyStrokesContext( c );
                    if( e.target is ITextField && ( e.target as ITextField).type == TextFieldType.INPUT )
                    {
                        for(var k : * in _aCurrentKeyStrokesContext )
                        {
                            var ks : KeyStroke = k as KeyStroke;
                            if( ( ks.modifiers & KeyStroke.CTRL_MASK ) == 0 && 
                                    [ 
                                      Keys.BACKSPACE,
                                      Keys.ENTER,
                                      Keys.ESCAPE,
                                      Keys.DOWN,
                                      Keys.UP,
                                      Keys.LEFT,
                                      Keys.RIGHT,
                                      Keys.F1,
                                      Keys.F2,
                                      Keys.F3,
                                      Keys.F4,
                                      Keys.F5,
                                      Keys.F6,
                                      Keys.F7,
                                      Keys.F8,
                                      Keys.F9,
                                      Keys.F10,
                                      Keys.F11,
                                      Keys.F12
                                    ].indexOf(ks.keyCode) == -1 )
                                delete _aCurrentKeyStrokesContext[ks];
                        }
                    }
                    return;
                }
                d = d.parent;
            }
            restoreDefaultContext();
        }
        protected function focusOut (event : FocusEvent) : void 
        {
        }
        protected function commandEnded ( command : Command ) : void
        {
            unregisterToCommandEvents( _oCurrentCommand );
        }
        protected function commandFailed ( command : Command, msg : String ) : void
        {
            unregisterToCommandEvents( _oCurrentCommand );
        }        
        protected function commandCancelled ( command : Command ) : void
        {
            unregisterToCommandEvents( _oCurrentCommand );
        }
        protected function registerToEventProviderEvents ( eventProvider : InteractiveObject ) : void
        {
            eventProvider.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );    
            eventProvider.addEventListener( KeyboardEvent.KEY_UP, keyUp );        
            eventProvider.addEventListener( FocusEvent.FOCUS_IN, focusIn );        
            eventProvider.addEventListener( FocusEvent.FOCUS_OUT, focusOut );        
        }
        protected function unregisterToEventProviderEvents ( eventProvider : InteractiveObject ) : void
        {
            eventProvider.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );    
            eventProvider.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
            eventProvider.removeEventListener( FocusEvent.FOCUS_IN, focusIn );        
            eventProvider.removeEventListener( FocusEvent.FOCUS_OUT, focusOut );        
        }
        protected function registerToCommandEvents ( c : Command ) : void
        {
            c.commandEnded.add( commandEnded );
            c.commandFailed.add( commandFailed );
            
            if( c is Cancelable )
              ( c as Cancelable ).commandCancelled.add( commandCancelled );
        }
        protected function unregisterToCommandEvents ( c : Command ) : void
        {
            c.commandEnded.remove( commandEnded );
            c.commandFailed.remove( commandFailed );
            
            if( c is Cancelable )
              ( c as Cancelable ).commandCancelled.remove( commandCancelled );
        }    
    }
}
