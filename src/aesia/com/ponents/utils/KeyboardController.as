/**
 * @license
 */
package aesia.com.ponents.utils
{
	import aesia.com.mands.Command;
	import aesia.com.mands.NullCommand;
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.core.Cancelable;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class KeyboardController extends EventDispatcher
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
			delete _oKeyStrokes[ keyStroke ];			delete _aCurrentKeyStrokesContext[ keyStroke ];
		}
		public function setKeyStrokesContext ( o : Component ) : void
		{
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
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
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		public function printGlobalKeyStrokes () : void 
		{
			for(var o : * in _oKeyStrokes)
				Log.debug( o + " : " + _oKeyStrokes[o] );
		}
		public function printContext () : void
		{
			Log.info( "Current Keyboard Context" );
			for( var i : * in _aCurrentKeyStrokesContext )
			{
				Log.debug(  i + " : " + _aCurrentKeyStrokesContext[ i ] );
			}
		}
		protected function keyDown ( e : KeyboardEvent ) : void
		{			
			var k : KeyStroke = KeyStroke.getKeyStroke( e.keyCode, KeyStroke.getModifiers( e.ctrlKey, e.shiftKey, e.altKey ) );
			
			if( _aCurrentKeyStrokesContext[ k ] != null && !_oCurrentCommand.isRunning() )
			{
				
				_oCurrentCommand = _aCurrentKeyStrokesContext[ k ] as Command;				
				registerToCommandEvents( _oCurrentCommand );
				
				_oCurrentCommand.execute( e );
			}
		}
		protected function keyUp ( e : KeyboardEvent ) : void
		{}
		protected function focusIn ( e : FocusEvent ) : void
		{
			var d : DisplayObject = e.target as DisplayObject;
			 
			restoreDefaultContext();
			
			while( d.parent )
			{
				var c : Component = d as Component;
				if( c != null )
				{
					setKeyStrokesContext( c );
					return;
				}
				d = d.parent;
			}			restoreDefaultContext();
		}
		protected function focusOut (event : FocusEvent) : void 
		{
		}
		protected function commandEnd ( e : CommandEvent ) : void
		{
			unregisterToCommandEvents( _oCurrentCommand );
		}
		protected function commandFailed ( e : CommandEvent ) : void
		{
			unregisterToCommandEvents( _oCurrentCommand );
		}		
		protected function commandCancelled ( e : CommandEvent ) : void
		{
			unregisterToCommandEvents( _oCurrentCommand );
		}
		
		protected function registerToEventProviderEvents ( eventProvider : InteractiveObject ) : void
		{
			eventProvider.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );	
			eventProvider.addEventListener( KeyboardEvent.KEY_UP, keyUp );					eventProvider.addEventListener( FocusEvent.FOCUS_IN, focusIn );					eventProvider.addEventListener( FocusEvent.FOCUS_OUT, focusOut );		
		}

		protected function unregisterToEventProviderEvents ( eventProvider : InteractiveObject ) : void
		{
			eventProvider.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );	
			eventProvider.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
			eventProvider.removeEventListener( FocusEvent.FOCUS_IN, focusIn );					eventProvider.removeEventListener( FocusEvent.FOCUS_OUT, focusOut );		
		}
		
		/**
		 * Enregistre l'instance courante comme écouteur pour les évènements
		 * diffusé par la commande <code>c</code> passée en paramètre. 
		 * <p>
		 * La fonction s'enregistre pour les évènements suivant : 
		 * </p>
		 * <ul>
		 * <li><code>CommandEvent.COMMAND_END</code> : 
		 * la fonction réceptrice est <code>commandEnd</code></li>
		 * <li><code>CommandEvent.COMMAND_FAIL</code> : 
		 * la fonction réceptrice est <code>commandFailed</code></li>
		 * <li><code>CommandEvent.COMMAND_CANCEL</code> : 
		 * la fonction réceptrice est <code>commandCancelled</code>.
		 * <p>
		 * Cet évènement est écouté uniquement si <code>c</code> implémente
		 * l'interface <code>Cancelable</code>.</p>
		 * </li></ul>
		 * @param	c	commande à laquelle on souhaite s'enregistrer
		 */
		protected function registerToCommandEvents ( c : Command ) : void
		{
			c.addEventListener( CommandEvent.COMMAND_END, commandEnd );
			c.addEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			
			if( c is Cancelable )
				c.addEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}
		
		/**
		 * Enlève l'instance courante de la liste des écouteurs pour la commande
		 * <code>c</code> passée en paramètre.
		 * <p>
		 * La fonction réalise la suppression des écouteurs enregistrés par la 
		 * fonction <code>registerToCommandEvents</code>.
		 * </p>
		 * @param	c	commande à laquelle on souhaite se désinscrire
		 */
		protected function unregisterToCommandEvents ( c : Command ) : void
		{
			c.removeEventListener( CommandEvent.COMMAND_END, commandEnd );
			c.removeEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			
			if( c is Cancelable )
				c.removeEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
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
		 	if ( hasEventListener( evt.type ) || evt.bubbles ) 
		 	{
		  		return super.dispatchEvent(evt);
		  	}
		 	return true;
		}
	}
}
