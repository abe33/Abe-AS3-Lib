/**
 * @license 
 */
package  abe.com.mands.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	public class LoaderEstimator extends AbstractLoaderEstimator
	{
		protected var _loader : Loader;
		
		public function LoaderEstimator( loader : Loader, 
									 	  rateSmoothness : Number = 10,
									 	  remainSmoothness : Number = 1 )
		{
			super( rateSmoothness, remainSmoothness );
			_loader = loader;
			registerToLoaderEvent( _loader );
		}
		protected function registerToLoaderEvent ( loader : Loader ) : void
		{
			loader.contentLoaderInfo.addEventListener( Event.OPEN, open );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, complete );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progress );
		}
		protected function unregisterToLoaderEvent ( loader : Loader ) : void
		{
			loader.contentLoaderInfo.removeEventListener( Event.OPEN, open );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, complete );
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progress );
		}
	}
}