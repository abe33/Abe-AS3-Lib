/**
 * @license 
 */
package  aesia.com.mands.load
{
	import aesia.com.mands.AbstractCommand;
	import aesia.com.mands.Command;
	import aesia.com.mon.core.Runnable;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class URLLoaderQueue extends AbstractCommand implements Command, Runnable
	{
		protected var _loaders : Vector.<URLLoader>;
		protected var _requests : Vector.<URLRequest>;
		protected var _callbacks : Vector.<Function>;

		private var _currentURLLoader : URLLoader;
		private var _currentRequest : URLRequest;
		
		public function URLLoaderQueue ()
		{
			super();
			_loaders = new Vector.<URLLoader>();
			_requests = new Vector.<URLRequest>();
			_callbacks = new Vector.<Function>();
		}
		override public function execute( e : Event = null ) : void
		{
			_isRunning = true;
			
			loadNext( );
		}
		
		public function get currentRequest () : URLRequest { return _currentRequest; }
		public function get size () : int { return _loaders.length; }

		public function loadNext () : void
		{
			if( _currentURLLoader != null )
			{
				_unregisterToURLLoaderEvent( _currentURLLoader );
				_currentURLLoader = null;
			}
			if( _loaders.length != 0 )
			{
				var loader : URLLoader = _loaders.shift();
				_currentRequest = _requests.shift();
				
				_currentURLLoader = loader;
				_registerToURLLoaderEvent( _currentURLLoader );
				_currentURLLoader.load( _currentRequest );
			}
			else
			{
				_isRunning = false;
				fireCommandEnd();
			}
		}
		
		public function complete ( e : Event ) : void
		{
			var f : Function = _callbacks.shift();
			if( f != null )
				f( _currentURLLoader, _currentRequest );
			
			loadNext();
		}
		public function ioerror ( e : IOErrorEvent ) : void
		{
			_isRunning = false;
			fireCommandFailed( e.text );
		}
		public function securityError ( e : SecurityErrorEvent ) : void
		{
			_isRunning = false;
			fireCommandFailed( e.text );
		}
		public function addURLLoader ( loader : URLLoader, request : URLRequest, callback : Function = null ) : void
		{
			if( request.url == "" )
				return;
				
			if( _loaders.indexOf( loader ) == -1 )
			{
				_loaders.push( loader );
				_requests.push( request );
				_callbacks.push( callback );
			}
		}
		public function removeURLLoader ( loader : URLLoader ) : void
		{
			var index : Number = _loaders.indexOf( loader );
			if( index != -1 )
			{
				_loaders.splice( index, 1 );
				_requests.splice( index, 1 );
			}
		}
		protected function _registerToURLLoaderEvent ( loader : URLLoader ) : void
		{
			loader.addEventListener( Event.COMPLETE, complete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, ioerror );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
		}
		protected function _unregisterToURLLoaderEvent ( loader : URLLoader ) : void
		{
			loader.removeEventListener( Event.COMPLETE, complete );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, ioerror );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
		}
	}
}