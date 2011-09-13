package abe.com.mands.load 
{
    import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	public class RootLoaderEvent extends Event 
	{
		public var rootLoader : RootLoader;
		public var loadedEntry : LoadEntry;
		public function RootLoaderEvent ( rootLoader : RootLoader,
										  loadedEntry : LoadEntry,
										  bubbles : Boolean = false, 
										  cancelable : Boolean = false )
		{
			super( "", bubbles, cancelable );
			this.rootLoader = rootLoader;
			this.loadedEntry = loadedEntry;
		}
	}
}
