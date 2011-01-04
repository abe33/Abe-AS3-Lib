/**
 * @license 
 */
package  aesia.com.mands.load
{
	import aesia.com.mands.events.LoadingEstimationEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
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
			TARGET::FLASH_9
			_entries = [];
			
			TARGET::FLASH_10			_entries = new Vector.<LoadEntry>();
			
			TARGET::FLASH_10_1 /*FDT_IGNORE*/			_entries = new Vector.<LoadEntry>();
			
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
				_loaderUI["requestSent"]( null );
			_currentEntry.load();
		}
		
		protected function callMain ( e : RootLoaderEvent ) : void
		{
			( e.loadedEntry as LoaderEntry ).loader.content["main"]( e.rootLoader );
		}

		protected function registerLoaderUI ( e : RootLoaderEvent ) : void
		{
			_loaderUI = ( e.loadedEntry as LoaderEntry ).loader.content;
			if( _loaderUI && _loaderUI.hasOwnProperty( "init" ) )
				_loaderUI["init"]();
		}
		protected function ioError ( e : IOErrorEvent ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "ioError" ) )
				_loaderUI["ioError"]( e );
		}		protected function securityError ( e : SecurityErrorEvent ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "securityError" ) )
				_loaderUI["securityError"]( e );
		}		
		protected function open ( e : Event ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "loadStart" ) )
				_loaderUI["loadStart"]( e );
		}		protected function complete ( e : Event ) : void 
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
					_loaderUI["queueComplete"]( e );
			}
		}
		protected function progress ( e : ProgressEvent ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "loadProgress" ) )
				_loaderUI["loadProgress"]( e );
		}		
		protected function estimationsAvailable ( e : LoadingEstimationEvent ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "estimationsAvailable" ) )
				_loaderUI["estimationsAvailable"]( e );
		}
		protected function newEstimation ( e : LoadingEstimationEvent ) : void 
		{
			if( _loaderUI && _loaderUI.hasOwnProperty( "newEstimation" ) )
				_loaderUI["newEstimation"]( e );
		}
		
		protected function registerToLoadEntryEvent ( entry : LoadEntry ) : void
		{
			entry.addEventListener( Event.OPEN, open );			entry.addEventListener( Event.COMPLETE, complete );
			entry.addEventListener( ProgressEvent.PROGRESS, progress );
			
			entry.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
			entry.addEventListener( IOErrorEvent.IO_ERROR, ioError );

			entry.estimator.addEventListener( LoadingEstimationEvent.ESTIMATIONS_AVAILABLE, estimationsAvailable );
			entry.estimator.addEventListener( LoadingEstimationEvent.NEW_ESTIMATION, newEstimation );
		}
		protected function unregisterToLoadEntryEvent ( entry : LoadEntry ) : void
		{
			entry.removeEventListener( Event.OPEN, open );
			entry.removeEventListener( Event.COMPLETE, complete );
			entry.removeEventListener( ProgressEvent.PROGRESS, progress );
			
			entry.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
			entry.removeEventListener( IOErrorEvent.IO_ERROR, ioError );

			entry.estimator.removeEventListener( LoadingEstimationEvent.ESTIMATIONS_AVAILABLE, estimationsAvailable );
			entry.estimator.removeEventListener( LoadingEstimationEvent.NEW_ESTIMATION, newEstimation );
		}
	}
}