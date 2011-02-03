package aesia.com.ponents.factory 
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mands.load.URLLoaderQueue;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.url;
	import aesia.com.patibility.codecs.MOCodec;
	import aesia.com.patibility.codecs.POCodec;
	import aesia.com.patibility.lang.GetTextInstance;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.patibility.settings.backends.SettingsBackend;
	import aesia.com.patibility.settings.events.SettingsBackendEvent;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.events.ComponentFactoryEvent;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.progress.ProgressBar;
	import aesia.com.ponents.skinning.decorations.NoDecoration;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.tools.DebugPanel;
	import aesia.com.ponents.utils.Corners;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	/**
	 * @author cedric
	 */
	public class ComponentFactoryPreload extends MovieClip
	{
		static protected var __mainClassName__ : String /*FDT_IGNORE*/= CONFIG::MAIN_CLASS/*FDT_IGNORE*/;
		
		protected var _langLoader : URLLoaderQueue;
		protected var _progressPanel : Panel;
		protected var _progressLabel : Label;		protected var _progressBar : ProgressBar;
		protected var _app : DisplayObject;
		protected var _numLangFile : int;
		protected var _currentLangFile : int;
		protected var _backendTimeout : uint;		protected var _timeout : uint;

		public function ComponentFactoryPreload ()
		{
			this.stop();
			
			StageUtils.setup( this );
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				KeyboardControllerInstance.eventProvider = stage;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			createProgressPanel();
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		/*FDT_IGNORE*/CONFIG::DEBUG/*FDT_IGNORE*/
		protected function createDebugTools () : void
		{
			var p : DebugPanel = new DebugPanel();
			p.id = p.name = "debugPanel";
			ToolKit.popupLevel.addChild(p);
			p.visible = false;
		}
		protected function createProgressPanel () : void
		{
			_progressBar = new ProgressBar(new DefaultBoundedRangeModel(0, 0, 100, 1), true );
			_progressLabel = new Label( getMessage("load" ) );
			_progressPanel = new Panel( );
			_progressPanel.childrenLayout = new InlineLayout( _progressPanel, 3, "left", "top", "topToBottom", true );
			_progressPanel.styleKey = "DefaultComponent";
			_progressPanel.style.setForAllStates("insets", new Insets(4)
						 ).setForAllStates("corners", new Corners(3)
						 ).setForAllStates("outerFilters", [new DropShadowFilter(1, 45, 0, .6, 3, 3)]
						 ).setForAllStates("foreground", new NoDecoration() );
			_progressPanel.addComponents( _progressLabel, _progressBar );
			
			StageUtils.lockToStage( _progressPanel, StageUtils.X_ALIGN_CENTER + StageUtils.Y_ALIGN_CENTER );
			ToolKit.mainLevel.addChild( _progressPanel );
		}
		protected function releaseProgressPanel() : void
		{
			StageUtils.unlockFromStage( _progressPanel );
			ToolKit.mainLevel.removeChild( _progressPanel );
		}
		protected function initMain () : void
		{
			_progressLabel.value = "Looking for a backend";
			
  			var be : SettingsBackend;
			var mainClass:Class = getDefinitionByName(__mainClassName__) as Class;
			var bck : XML = Reflection.getClassMeta( mainClass, "SettingsBackend" )[0];
            var backend:String = bck.arg.(@key=="backend").@value;
            var appName : String = bck.arg.(@key=="appName").@value;            _timeout = parseInt( bck.arg.(@key=="timeout").@value ) || 10000;
            
            if( backend && backend != "" )
            {
            	_progressLabel.value = "Found a backend";
            	try
            	{
            		var cls : Class = getDefinitionByName( backend ) as Class;
            		if( cls )
            		{
            			if( appName && appName != "" )
            				be = new cls( appName ) as SettingsBackend;            			else
            				be = new cls() as SettingsBackend;
            				
            			if(be)
            			{
							SettingsManagerInstance.backend = be;
							
            				be.addEventListener( SettingsBackendEvent.INIT, backendInit );            				be.addEventListener( SettingsBackendEvent.PROGRESS, backendProgress );

							_progressLabel.value = getMessage("settings");
            				_backendTimeout = setTimeout( checkBackendInit, _timeout);
            				
            				_progressLabel.value = "Backend initialize";
            				be.init();
						}
            			else 
            			{
            				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
            				Log.error(_$(_("The settings backend '$0' don't implements the SettingsBackend interface."), 
            						 	 backend ) );
            				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
            			}
            		}
            		else 
            		{
            			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
            			Log.error( _$(_("The settings backend definition '$0' isn't a Class."), 
            					   	  backend ) );            					
            			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
            		}
            	}
            	catch( e : ReferenceError )
            	{
            		/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/            					
            		Log.error( _$(_("The settings backend definition '$0' can't be found in this file."), 
            				   	  backend ) );
            		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
            	}            	catch( e : Error )
            	{       
            		/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/            					
            		Log.error( _$(_("An unespected error occured while creating the following settings backend definition : '$0'\ninstance = $1\n$2"), 
            				      backend, be, e.getStackTrace() ) );
            		/*FDT_IGNORE*/ } /*FDT_IGNORE*/     		
            	}
            }
            else
            	buildMain();
		}
		protected function buildMain() : void
		{
			_progressLabel.value = "Start the program";
			var mainClass:Class = getDefinitionByName(__mainClassName__) as Class;
			
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				createDebugTools();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	            
            _app = new mainClass() as DisplayObject;
            if( _app.hasOwnProperty("init") )
            {
            	try
            	{
            		_app["init"]( this );
            		if( ComponentFactoryInstance.componentsToBuild > 0 )
            		{
            			ComponentFactoryInstance.addEventListener( ComponentFactoryEvent.BUILD_COMPLETE, buildComplete );
            			ComponentFactoryInstance.addEventListener( ComponentFactoryEvent.BUILD_PROGRESS, buildProgress );
            			ComponentFactoryInstance.process();
						_progressLabel.value = getMessage("build");
					}
            		else
            			releaseProgressPanel();
            	}
            	catch( e : Error )
            	{
            		/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
            		Log.error( e.message + "\n" + e.getStackTrace() );
            		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
            	}
            }
            else
            {
            	/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
            		Log.warn( _("The main class don't have an init method. The instance will be placed on stage as a regular boot class.") );
            	/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	            releaseProgressPanel();
				ToolKit.mainLevel.addChild( _app );
			}
		}
		protected function checkBackendInit () : void 
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/			
			Log.error( _$( _( "Seems like the settings backend $0 haven't respond after $1ms. The settings backend will be discarded and no backend will be used" ), 
							   SettingsManagerInstance.backend ) );
			
			SettingsManagerInstance.backend.removeEventListener(SettingsBackendEvent.INIT, backendInit );
			SettingsManagerInstance.backend.removeEventListener(SettingsBackendEvent.PROGRESS, backendProgress );
			SettingsManagerInstance.discardBackend();
			buildMain();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
		}
		protected function backendInit (event : SettingsBackendEvent) : void 
		{
			_progressLabel.value = "Backend Initialized";
			SettingsManagerInstance.backend.removeEventListener(SettingsBackendEvent.INIT, backendInit );
			SettingsManagerInstance.backend.removeEventListener(SettingsBackendEvent.PROGRESS, backendProgress );
			
			clearTimeout( _backendTimeout );
			
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
			Log.info( _$(_("Settings backend $0 initialized." ), SettingsManagerInstance.backend ) );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			buildMain();
		}
		protected function backendProgress (event : ProgressEvent ) : void 
		{
			_progressBar.value = Math.round( event.bytesLoaded / event.bytesTotal * 100 );
		}
		protected function buildProgress (event : ComponentFactoryEvent ) : void 
		{
			_progressBar.value = Math.round( event.current / event.total * 100 );
		}
		protected function buildComplete (event : ComponentFactoryEvent ) : void 
		{
			ComponentFactoryInstance.removeEventListener(ComponentFactoryEvent.BUILD_COMPLETE, buildComplete);			ComponentFactoryInstance.removeEventListener(ComponentFactoryEvent.BUILD_PROGRESS, buildProgress );
			releaseProgressPanel();
		}
		/*FDT_IGNORE*/ CONFIG::WITHOUT_SERVER { /*FDT_IGNORE*/
		protected var _n : uint = 0;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		protected function enterFrame(event:Event):void
	    {
			_progressBar.value = Math.round( this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal * 100 );
			/*FDT_IGNORE*/ CONFIG::WITHOUT_SERVER { /*FDT_IGNORE*/
			if ( _n >= 100 ) 
	        {
	           this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
	           this.nextFrame();
	           _progressLabel.value = "Loading complete";
	           loadLang();
	        }
	        else
	        {
	        	_n++;
				_progressBar.value = _n;	
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ CONFIG::WITH_DISTANT_SERVER { /*FDT_IGNORE*/
			if (this.framesLoaded >= this.totalFrames) 
	        {
	           this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
	           this.nextFrame();
	           _progressLabel.value = "Loading complete";
	           loadLang();
	        }
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		private function loadLang () : void
		{
			var lang : String = this.loaderInfo.parameters.lang;
			if( lang && lang != "" )
			{
				_langLoader = new URLLoaderQueue();
				var langs : Array = lang.split(",");
				var l : uint = langs.length;
				for( var i : uint = 0; i < l; i++ )
				{
					var loader : URLLoader = new URLLoader();
					var request : URLRequest = url( langs[i] );
					loader.dataFormat = request.url.indexOf ( ".po" ) != -1 ? URLLoaderDataFormat.TEXT : URLLoaderDataFormat.BINARY;
					loader.addEventListener(ProgressEvent.PROGRESS, langLoadingProgress );
					
					_langLoader.addURLLoader( loader, request, langCallBack );
				}
				_langLoader.addEventListener( CommandEvent.COMMAND_END, langLoadingComplete );
				_numLangFile = _langLoader.size;
				_currentLangFile = 0;
				_langLoader.execute();
				_progressLabel.value = getMessage("lang") + " " + _currentLangFile + "/" + _numLangFile;
			}
			else initMain();
		}
		protected function langLoadingProgress (event : ProgressEvent) : void 
		{
			_progressBar.value = Math.round( event.bytesLoaded / event.bytesTotal * 100 );
		}
		protected function langCallBack ( loader : URLLoader, request : URLRequest ) : void
		{
			_currentLangFile++;
			_progressLabel.value = getMessage("lang") + " " + _currentLangFile + "/" + _numLangFile;
			loader.removeEventListener( ProgressEvent.PROGRESS, langLoadingProgress );
			if( loader.dataFormat == URLLoaderDataFormat.TEXT )
			{
				try
				{
					var poc : POCodec = new POCodec ();
					GetTextInstance.addTranslations ( poc.decode ( loader.data ) );
					
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.info( _$(_("Language in file '$0' successfully loaded."), request.url ) );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
				catch( e : Error )
				{
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.error( _$(_("The content of the file '$0' seems not valid.\n$1"), request.url, e.getStackTrace() ) );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
			}
			else
			{
				try
				{
					var moc : MOCodec = new MOCodec ();
					( loader.data as ByteArray ).endian = Endian.LITTLE_ENDIAN;
					GetTextInstance.addTranslations ( moc.decode ( loader.data ) );
					
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.info( _$(_("Language in file '$0' successfully loaded."), request.url ) );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
				catch( e : Error )
				{
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.error( _$(_("The content of the file '$0' seems not valid.\n$1"), request.url, e.getStackTrace() ) );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
			}
		}

		protected function langLoadingComplete ( event : Event ) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
			Log.info( _("Languages loading completed.") );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			_langLoader.removeEventListener( CommandEvent.COMMAND_END, langLoadingComplete );
			initMain();
		}
		protected function getMessage ( messageId : String ) : String
		{
			switch( messageId )
			{
				case "load" :
					if( loaderInfo.parameters.loadingMessage )
						return loaderInfo.parameters.loadingMessage
					else
						return "Loading";
					break;
				case "lang" :
					if( loaderInfo.parameters.loadingLangMessage )
						return loaderInfo.parameters.loadingLangMessage
					else
						return "Loading languages";
					break;
				case "build" :
					if( loaderInfo.parameters.constructionMessage )
						return loaderInfo.parameters.constructionMessage
					else
						return "Building scene";
					break;
				case "settings" :
					if( loaderInfo.parameters.settingsMessage )
						return loaderInfo.parameters.settingsMessage
					else
						return "Loading settings";
					break;
				default : 
					return "";
			}
		}
	}
}
