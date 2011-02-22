/**
 * @license
 */
package abe.com.ponents.allocators 
{
	import flash.utils.setTimeout;
	import abe.com.mands.load.LoaderQueue;
	import abe.com.mon.utils.RandomUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author Cédric Néhémie
	 */
	public class ExternalBitmapAllocator extends LoaderQueue
	{
		protected var _bitmaps : Object;		protected var _loadersDict : Object;
		protected var _bitmapsRefCounts : Object;
		protected var _bitmapsSuccesCallbacks : Object;		protected var _bitmapsFailureCallbacks : Object;		
		public function ExternalBitmapAllocator ()
		{
			_bitmaps = {};			_loadersDict = {};
			_bitmapsRefCounts = {};
			_bitmapsSuccesCallbacks = {};			_bitmapsFailureCallbacks = {};
		}

		public function get ( url : URLRequest, success : Function = null, failure : Function = null ) : Bitmap
		{
			var surl : String = url.url;
			if( !_bitmapsRefCounts.hasOwnProperty( surl ) )
				_bitmapsRefCounts[ surl ] = 0;
				
			
			if( !_bitmapsSuccesCallbacks.hasOwnProperty( surl ) )			
				_bitmapsSuccesCallbacks[ surl ] = [];
			
			if( !_bitmapsFailureCallbacks.hasOwnProperty( surl ) )			
				_bitmapsFailureCallbacks[ surl ] = [];
			
			if( _bitmaps.hasOwnProperty( surl ) )
			{
				_bitmapsRefCounts[ surl ]++;
				
				return new Bitmap(  _bitmaps[ surl ] as BitmapData );
			}				
			else
			{
				if( success != null )
					_bitmapsSuccesCallbacks[ surl ].push( success );
				
				if( failure != null )
					_bitmapsFailureCallbacks[ surl ].push( failure );
				
				if( !_loadersDict.hasOwnProperty( surl ) )
				{
					var loader : Loader = new Loader();
					addLoader( loader, url );				
					
					_loadersDict[ surl ] = loader;
					
					if( size > 0 && !_isRunning )
						execute();
				}
				_bitmapsRefCounts[ surl ]++;
			}
			
			return null;
		}

		override public function complete (e : Event) : void
		{
			var loaderInfo : LoaderInfo = e.target as LoaderInfo;
			var loader : Loader = loaderInfo.loader;
			var url : String = getURLAssociatedWithLoader( loaderInfo.loader );
			var fs : Array = _bitmapsSuccesCallbacks[ url ];
			var l : uint = fs.length;
			
			_bitmaps[ url ] = ( loaderInfo.content as Bitmap ).bitmapData.clone();
			
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				var t : Number = RandomUtils.rangeAB(250, 750);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			for( var i : int = 0; i < l; i++ )
			{
				var f : Function = fs[ i ] as Function;
				
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					setTimeout(f, t, new Bitmap( _bitmaps[ url ] as BitmapData ) );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				/*FDT_IGNORE*/ CONFIG::RELEASE { /*FDT_IGNORE*/
					f( new Bitmap( _bitmaps[ url ] as BitmapData ) );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			}
			( loaderInfo.content as Bitmap ).bitmapData.dispose();
			loader.unload();
			super.complete( e );
		}

		override public function ioerror (e : IOErrorEvent) : void
		{
			var loaderInfo : LoaderInfo = e.target as LoaderInfo;
			notifyFailure( loaderInfo );
			loadNext();
		}

		override public function securityError (e : SecurityErrorEvent ) : void
		{
			var loaderInfo : LoaderInfo = e.target as LoaderInfo;
			notifyFailure( loaderInfo );
			loadNext();
		}

		protected function notifyFailure (loaderInfo : LoaderInfo) : void
		{
			var url : String = getURLAssociatedWithLoader( loaderInfo.loader );
			var fs : Array = _bitmapsFailureCallbacks[ url ];
			var l : uint = fs.length;
			
			for( var i : int = 0; i < l; i++ )
			{
				var f : Function = fs[ i ] as Function;
				f();	
			}
		}

		public function release ( o : * ) : void
		{
			if( o is Bitmap )
			  	o = (o as Bitmap).bitmapData;		
			
			var url : String = getURLAssociatedWithBitmap(o);
			
			if( url )
				_bitmapsRefCounts[ url ]--;
		}
		public function getURLAssociatedWithLoader ( o : Loader ) : String
		{
			for( var i : String in _loadersDict )
				if( o == _loadersDict[i] )
					return i;
			
			return null;
		}
		public function getURLAssociatedWithBitmap ( o : BitmapData ) : String
		{
			for( var i : String in _bitmaps )
				if( o == _bitmaps[i] )
					return i;
			
			return null;
		}
	}
}
