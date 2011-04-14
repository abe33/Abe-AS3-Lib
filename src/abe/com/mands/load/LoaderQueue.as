/**
 * @license 
 */
package  abe.com.mands.load
{
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	[Event(type="flash.events.ProgressEvent", name="progress")]
	public class LoaderQueue extends AbstractCommand implements Command, Runnable
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9 {
			protected var _loaders : Array;
			protected var _requests : Array;
			protected var _contexts : Array;
			protected var _callbacks : Array;
		}		TARGET::FLASH_10 {
			protected var _loaders : Vector.<Loader>;
			protected var _requests : Vector.<URLRequest>;
			protected var _contexts : Vector.<LoaderContext>;
			protected var _callbacks : Vector.<Function>;
		}		TARGET::FLASH_10_1 {
		/*FDT_IGNORE*/
		protected var _loaders : Vector.<Loader>;
		protected var _requests : Vector.<URLRequest>;		protected var _contexts : Vector.<LoaderContext>;		protected var _callbacks : Vector.<Function>;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		protected var _currentLoader : Loader;		protected var _currentRequest : URLRequest;
		
		public function LoaderQueue()
		{
			super();
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {
				_loaders = [];
				_requests = [];
				_contexts = [];
				_callbacks = [];
			}
			TARGET::FLASH_10 {
				_loaders = new Vector.<Loader>();
				_requests = new Vector.<URLRequest>();
				_contexts = new Vector.<LoaderContext>();
				_callbacks = new Vector.<Function>();
			}
			TARGET::FLASH_10_1 {
			/*FDT_IGNORE*/
			_loaders = new Vector.<Loader>();
			_requests = new Vector.<URLRequest>();			_contexts = new Vector.<LoaderContext>();
			_callbacks = new Vector.<Function>();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		override public function execute( ... args ) : void
		{
			_isRunning = true;
			
			loadNext( );
		}
		
		public function get size () : int
		{
			return _loaders.length;
		}

		public function loadNext () : void
		{
			if( _currentLoader != null )
			{
				_unregisterToLoaderEvent( _currentLoader );
				_currentLoader = null;
			}
			if( _loaders.length != 0 )
			{
				var loader : Loader = _loaders.shift();
				_currentRequest = _requests.shift();				var context : LoaderContext = _contexts.shift( );
				
				_currentLoader = loader;
				_registerToLoaderEvent( _currentLoader );
				_currentLoader.load( _currentRequest, context );
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
				f( _currentLoader, _currentRequest );
			
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
		protected function progress (event : ProgressEvent) : void 
		{
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, event.bytesLoaded, event.bytesTotal))
		}
		
		public function addLoader ( loader : Loader, request : URLRequest, context : LoaderContext = null, callback : Function = null ) : void
		{
			if( request.url == "" )
				return;
				
			if( _loaders.indexOf( loader ) == -1 )
			{
				_loaders.push( loader );
				_requests.push( request );				_contexts.push( context );
				_callbacks.push( callback );
			}
		}
		public function removeLoader ( loader : Loader ) : void
		{
			var index : Number = _loaders.indexOf( loader );
			if( index != -1 )
			{
				_loaders.splice( index, 1 );
				_requests.splice( index, 1 );
			}
		}
		protected function _registerToLoaderEvent ( loader : Loader ) : void
		{
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, complete );			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progress );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioerror );			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
		}
		protected function _unregisterToLoaderEvent ( loader : Loader ) : void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, complete );
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progress );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, ioerror );			loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
		}
	}
}