/**
 * @license 
 */
package  abe.com.mands.load
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.net.URLRequest;
    import flash.net.URLVariables;

	[SWF(backgroundColor="#000000")]
	public class RootLoader extends Sprite
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9		protected var _entries : Array;
		
		TARGET::FLASH_10		protected var _entries : Vector.<LoadEntry>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _entries : Vector.<LoadEntry>;
		
		protected var _entryIndex : Number;
		protected var _loading : Boolean;
		protected var _currentEntry : LoadEntry;
		protected var _loaderUI : DisplayObject;
		
		public function RootLoader()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _entries = []; }
			TARGET::FLASH_10 { _entries = new Vector.<LoadEntry>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/			_entries = new Vector.<LoadEntry>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_entryIndex = -1;
			_loading = false;
			prepareAndLoad();
		}
		protected function prepareAndLoad() : void
		{
			var parameters : Object = this.loaderInfo.parameters;
			
			var ui : String = parameters.ui != undefined ? parameters.ui : null;			var url : String = parameters.url;
			var nocache : Boolean = parameters.nocache != undefined;
			
			delete parameters.ui;			delete parameters.url;
			delete parameters.nocache;
			
			// on ajoute l'anticache, si celui-ci est nécessaire			
			if( nocache ) 
			{
				var nc : String = "?nocache=" + new Date().getTime();
				
				if( ui ) ui += nc;					
				url += nc;
			}
				
			// on copie tout les paramètres reçus concernant le swf a chargé
			var variables : URLVariables = new URLVariables ();
			for ( var i : String in parameters )
			{
				variables[ i ] = parameters[ i ];
			}
			// on prépare la requête pour charger l'apparence du loader
			if( ui )
			{
				var requestUI : URLRequest = new URLRequest( ui );
				addLoadEntry( new LoaderEntry( requestUI, null, registerLoaderUI, this ) );
			}
	
			// on prépare la requête pour charger le swf principal
			var requestMain : URLRequest = new URLRequest( url );
			//requestMain.method = URLRequestMethod.POST;
			requestMain.data = variables;			
			addLoadEntry( new LoaderEntry( requestMain, null, callMain, this ) );
			
			loadNext ();
		}
		
		public function isLoading () : Boolean
		{
			return _loading;
		}
		
		public function addLoadEntry ( le : LoadEntry ) : void
		{
			_entries.push( le );
		}
		
		public function hasNext () : Boolean
		{
			return _entryIndex + 1 < _entries.length;
		}

		public function loadNext () : void
		{		
			if( !hasNext () )
				return;
			
			_loading = true;
			_entryIndex++;
			_currentEntry = _entries[ _entryIndex ];
			registerToLoadEntryEvent( _currentEntry );
			
			if( _loaderUI && _loaderUI.hasOwnProperty( "requestSent" ) )
				_loaderUI["requestSent"](_currentEntry);
			_currentEntry.load();
		}
		
		protected function callMain ( e : LoadEntry ) : void
		{
			( e as LoaderEntry ).loader.content["main"]( this );
		}

		protected function registerLoaderUI ( e : LoadEntry ) : void
		{
			_loaderUI = ( e as LoaderEntry ).loader.content;
			if( _loaderUI && _loaderUI.hasOwnProperty( "init" ) )
				_loaderUI["init"]();
		}
		protected function ioErrorOccured ( str : String ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "ioError" ) )
				_loaderUI["ioError"]( str );
		}		protected function securityErrorOccured (  str : String) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "securityError" ) )
				_loaderUI["securityError"]( str );
		}		
		protected function loadOpened ( e : LoadEntry ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "loadStart" ) )
				_loaderUI["loadStart"]( e );
		}		protected function loadCompleted ( e : LoadEntry ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "loadComplete" ) )
				_loaderUI["loadComplete"]( e );
			/*	
			if( _currentEntry.callback != null )
				_currentEntry.callback.call( null, new RootLoaderEvent( this, _currentEntry) );
			*/	
			unregisterToLoadEntryEvent( _currentEntry );
			
			if( hasNext() )
				loadNext();
			else
			{
				_loading = false;	
				if( _loaderUI && _loaderUI.hasOwnProperty( "queueComplete" ) )
					_loaderUI["queueComplete"]( this );
			}
		}
		protected function loadProgressed ( e : LoadEntry, loaded : Number, total : Number ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "loadProgress" ) )
				_loaderUI["loadProgress"]( e, loaded, total );
		}		
		protected function estimationsAvailable ( rate : Number, remain : Number ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "estimationsAvailable" ) )
				_loaderUI["estimationsAvailable"]( rate, remain );
		}
		protected function estimationsProgressed ( rate : Number, remain : Number  ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "newEstimation" ) )
				_loaderUI["estimationsProgressed"]( rate, remain );
		}
		
		protected function registerToLoadEntryEvent ( entry : LoadEntry ) : void
		{
			entry.loadOpened.add( loadOpened );			entry.loadCompleted.add( loadCompleted );
			entry.loadProgressed.add( loadProgressed );
			
			entry.securityErrorOccured.add( securityErrorOccured );
			entry.ioErrorOccured.add( ioErrorOccured );

			entry.estimator.estimationsAvailable.add( estimationsAvailable );
			entry.estimator.estimationsProgressed.add( estimationsProgressed );
		}
		protected function unregisterToLoadEntryEvent ( entry : LoadEntry ) : void
		{
			entry.loadOpened.remove( loadOpened );
			entry.loadCompleted.remove( loadCompleted );
			entry.loadProgressed.remove( loadProgressed );
			
			entry.securityErrorOccured.remove( securityErrorOccured );
			entry.ioErrorOccured.remove( ioErrorOccured );

			entry.estimator.estimationsAvailable.remove( estimationsAvailable );
			entry.estimator.estimationsProgressed.remove( estimationsProgressed );
		}
	}
}