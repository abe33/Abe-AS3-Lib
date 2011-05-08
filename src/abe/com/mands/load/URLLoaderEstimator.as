/**
 * @license 
 */
package  abe.com.mands.load
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	public class URLLoaderEstimator extends AbstractLoaderEstimator
	{
		protected var _loader : URLLoader;
		
		public function URLLoaderEstimator( loader : URLLoader, 
									 	  	rateSmoothness : Number = 10,
									 	  	remainSmoothness : Number = 1 )
		{
			super( rateSmoothness, remainSmoothness );
			_loader = loader;
			registerToLoaderEvent( _loader );
		}

		protected function registerToLoaderEvent ( loader : URLLoader ) : void
		{
			loader.addEventListener( Event.OPEN, open );
			loader.addEventListener( Event.COMPLETE, complete );
			loader.addEventListener( ProgressEvent.PROGRESS, progress );
		}
		protected function unregisterToLoaderEvent ( loader : URLLoader ) : void
		{
			loader.removeEventListener( Event.OPEN, open );
			loader.removeEventListener( Event.COMPLETE, complete );
			loader.removeEventListener( ProgressEvent.PROGRESS, progress );
		}
	}
}