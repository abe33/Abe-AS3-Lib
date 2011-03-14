package abe.com.mands.load 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	/**
	 * @author Cédric Néhémie
	 */
	public class LoaderEntry extends AbstractLoadingEntry
	{
		protected var _loader : Loader;
		protected var _request : URLRequest;
		protected var _context : LoaderContext;
		protected var _parent : DisplayObjectContainer;
		protected var _depth : Number;

		public function LoaderEntry ( request : URLRequest, 
									  context : LoaderContext = null,
									  callback : Function = null,
									  parent : DisplayObjectContainer = null, 
									  depth : Number = 0 )
		{
			super( callback );
			_request = request;
			_context = context;
			_parent = parent;			
			_depth = depth;
			_loader = new Loader();
			_estimator = new LoaderEstimator( _loader );
			registerToLoaderEvent ( _loader );
		}
		override public function get request() : URLRequest
		{
			return _request;
		}
		override public function load () : void
		{
			if( _parent )
			{
				if( _depth >= _parent.numChildren )
					_parent.addChild( _loader );
				else
					_parent.addChildAt(_loader, _depth );
			}
			
			_loader.load( _request, _context );
		}
		
		public function get loader () : Loader { return _loader; }
		protected function open ( e : Event ) : void { fireOpenEvent(); }
		protected function complete ( e : Event ) : void { fireCompleteEvent(); }
		protected function progress ( e : ProgressEvent ) : void { fireProgressEvent( e.bytesLoaded, e.bytesTotal ); }
		protected function ioerror ( e : IOErrorEvent ) : void { fireIOErrorEvent( e.text ); fireCommandFailed( e.text ); }
		
		protected function registerToLoaderEvent ( loader : Loader ) : void
		{
			loader.contentLoaderInfo.addEventListener( Event.OPEN, open );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, complete );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progress );			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioerror );
		}
		protected function unregisterToLoaderEvent ( loader : Loader ) : void
		{
			loader.contentLoaderInfo.removeEventListener( Event.OPEN, open );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, complete );
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progress );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, ioerror );
		}
	}
}
