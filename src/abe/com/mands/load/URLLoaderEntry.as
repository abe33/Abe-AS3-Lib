package abe.com.mands.load 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Cédric Néhémie
	 */
	public class URLLoaderEntry extends AbstractLoadingEntry 
	{
		protected var _request : URLRequest;
		protected var _urlloader : URLLoader;
		
		public function URLLoaderEntry ( request : URLRequest, callback : Function = null )
		{
			super( callback );
			_request = request;
			_urlloader = new URLLoader();
			_estimator = new URLLoaderEstimator( _urlloader );
			registerToLoaderEvent( _urlloader );
		}
		override public function get request() : URLRequest
		{
			return _request;
		}
		override public function load () : void
		{
			_urlloader.load( _request );
		}
		
		public function get loader () : URLLoader { return _urlloader; }

		protected function open ( e : Event ) : void { fireLoadOpenedSignal(); }
		protected function complete ( e : Event ) : void { fireLoadCompletedSignal(); }
		protected function progress ( e : ProgressEvent ) : void { fireLoadProgressedSignal( e.bytesLoaded, e.bytesTotal ); }
		protected function ioerror ( e : IOErrorEvent ) : void { fireIOErrorOccuredSignal( e.text ); }
		
		protected function registerToLoaderEvent ( loader : URLLoader ) : void
		{
			loader.addEventListener( Event.OPEN, open );
			loader.addEventListener( Event.COMPLETE, complete );
			loader.addEventListener( ProgressEvent.PROGRESS, progress );
			loader.addEventListener( IOErrorEvent.IO_ERROR, ioerror );
		}
		protected function unregisterToLoaderEvent ( loader : Loader ) : void
		{
			loader.removeEventListener( Event.OPEN, open );
			loader.removeEventListener( Event.COMPLETE, complete );
			loader.removeEventListener( ProgressEvent.PROGRESS, progress );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, ioerror );
		}
	}
}
