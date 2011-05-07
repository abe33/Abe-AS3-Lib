/**
 * @license
 */
package abe.com.edia.text.fx 
{
	import abe.com.edia.text.core.Char;
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Clearable;
	import abe.com.mon.core.Suspendable;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;

	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractCharEffect extends EventDispatcher implements CharEffect, 
																	   ImpulseListener, 
																	   Suspendable, 
																	   Allocable,
																	   Clearable
	{
		public var autoStart : Boolean;

		protected var chars : Vector.<Char>;
		protected var _isRunning : Boolean;
		
		
		public function AbstractCharEffect ( autoStart : Boolean = true )
		{
			this.autoStart = autoStart;
			this.chars = new Vector.<Char>();
			_isRunning = false;
		}
		public function addChar (l : Char) : void
		{
			if( l is DisplayObject )
				chars.push( l );
		}
		public function init () : void
		{
			if( autoStart )
				start();
		}
		public function dispose () : void
		{
			stop();
			chars = new Vector.<Char>();
		}
		public function clear () : void
		{
			stop();
			dispose();
		}
		public function start () : void
		{
			if( !_isRunning )
			{
				Impulse.register( tick );
				_isRunning = true;
			}
		}
		public function stop () : void
		{
			if ( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister( tick );
			}
		}
		
		public function tick ( e : ImpulseEvent ) : void {}		
		public function isRunning () : Boolean { return _isRunning; }
	}
}
