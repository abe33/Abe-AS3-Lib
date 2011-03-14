package abe.com.mands.load 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.load.Estimator;
	import abe.com.mands.load.LoadEntry;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractLoadingEntry extends AbstractCommand implements LoadEntry 
	{		
		protected var _estimator : Estimator;
		protected var _callback : Function;
		
		public function AbstractLoadingEntry ( callback : Function = null )
		{
			_callback = callback;
		}

		public function get estimator () : Estimator { return _estimator; }
		
		public function get callback () : Function { return _callback; }
		public function set callback ( f : Function ) : void
		{
			_callback = f;
		}

		override public function execute (e : Event = null) : void 
		{
			load();
		}

		public function load () : void
		{
		}
		
		public function get request() : URLRequest
		{
			return null;
		}
		
		public function fireIOErrorEvent ( msg : String ) : void
		{
			dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR, true, false, msg ) );
		}
		
		public function fireSecurityErrorEvent ( msg : String ) : void
		{
			dispatchEvent( new SecurityErrorEvent( SecurityErrorEvent.SECURITY_ERROR, true, false, msg ) );
		}
		
		public function fireOpenEvent () : void
		{
			dispatchEvent( new Event( Event.OPEN ) );
		}			
		public function fireCompleteEvent () : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
			_callback( this );
			fireCommandEnd();
		}

		public function fireProgressEvent ( loaded : Number, total : Number ) : void
		{
			dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, true, false, loaded, total ) );
		}
			
		override public function dispatchEvent ( event : Event ) : Boolean
		{
			if( hasEventListener ( event.type ) || event.bubbles )
			{
				return super.dispatchEvent( event );
			} 
			return false;
		}
	}
}
