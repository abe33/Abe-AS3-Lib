package abe.com.ponents.factory 
{
    import abe.com.mands.load.URLLoaderQueue;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.Reflection;
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.url;
    import abe.com.patibility.codecs.MOCodec;
    import abe.com.patibility.codecs.POCodec;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.patibility.lang.GetTextInstance;
    import abe.com.patibility.settings.backends.SettingsBackend;
    import abe.com.patibility.settings.SettingsManagerInstance;
    import abe.com.ponents.events.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    import flash.geom.*;
    
    /**
     * @author cedric
     */
    public class ComponentFactoryPreload extends MovieClip
    {
        static protected var __mainClassName__ : String = CONFIG::MAIN_CLASS;
        
        protected var _langLoader : URLLoaderQueue;
        protected var _app : DisplayObject;
        protected var _numLangFile : int;
        protected var _currentLangFile : int;
        protected var _backendTimeout : uint;
        protected var _timeout : uint;

        public function ComponentFactoryPreload ()
        {
            this.stop();
            
            StageUtils.setup( this );
            StageUtils.flexibleStage();
            
            createProgressPanel();
            
            this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
        }
        
        
        private var _progressText : TextField;    
        private var _progressBar : Shape;    
        private var _progressBarBackground : Shape;    
        private var _progressPanel : Sprite;    
        private var _progressPercent : TextField;    
            
        protected function createProgressPanel () : void
        {
            _progressPanel = new Sprite();
            _progressPanel.graphics.beginFill (0xf7f5ef);
            _progressPanel.graphics.drawRoundRect( 0, 0, 170, 46, 5 );
            _progressPanel.graphics.endFill();
            _progressPanel.filters = [ new DropShadowFilter(1,90,0x1b3338,1,4,4,1,3)];
            
            _progressBarBackground = new Shape();
            
            _progressBarBackground.graphics.beginFill(0x8ea5ac);
            _progressBarBackground.graphics.drawRoundRect( 0, 0, 160, 16, 3 );
            _progressBarBackground.graphics.drawRoundRect( 1, 1, 158, 14, 2 );
            _progressBarBackground.graphics.endFill();
            
            _progressBarBackground.graphics.beginFill(0xa9bfc6);
            _progressBarBackground.graphics.drawRoundRect( 1, 1, 158, 14, 2 );
            _progressBarBackground.graphics.endFill();
            
            _progressBar = new Shape();
            
            _progressText = new TextField();
            _progressText.width = 160;
            _progressText.height = 20;
            _progressText.defaultTextFormat = new TextFormat("Verdana", 10);
            _progressText.text = getMessage( "load" );
            
            _progressPercent = new TextField();
            _progressPercent.autoSize="left";
            _progressPercent.defaultTextFormat = new TextFormat("Verdana", 10, false, false, false, null, null, "center");
            _progressPercent.blendMode = "invert";
            
            _progressText.x = 5;
            _progressText.y = 5;
            
            _progressBarBackground.x = 5;
            _progressBarBackground.y = 25;
            
            _progressBar.x = 5;
            _progressBar.y = 25; 
            _progressPercent.x = 5;
            _progressPercent.y = 24;
            
            _progressPanel.addChild( _progressText );
            _progressPanel.addChild( _progressBarBackground );
            _progressPanel.addChild( _progressBar );
            _progressPanel.addChild( _progressPercent );
            
            addChild( _progressPanel );
            
            StageUtils.lockToStage( _progressPanel, StageUtils.X_ALIGN_CENTER + StageUtils.Y_ALIGN_CENTER );
            
            setProgressValue(0);
        }
        protected function releaseProgressPanel() : void
        {
            StageUtils.unlockFromStage( _progressPanel );
            removeChild( _progressPanel );
        }
        public function setProgressLabel( s : String ) : void
        {
            _progressText.text = s;
        }
        public function setProgressValue( n : Number ) : void
        {
            var m : Matrix = new Matrix();
            var w : Number = 160 * n / 100;
            
            m.createGradientBox( 160, 14, Math.PI/2, 0, 1 );
           
            _progressBar.graphics.clear();
            _progressBar.graphics.beginFill(0x8ea5ac);
            _progressBar.graphics.drawRoundRect( 0, 0, w, 16, 3 );
            _progressBar.graphics.drawRoundRect( 1, 1, w-2, 14, 2 );
            _progressBar.graphics.endFill();
            
            _progressBar.graphics.beginGradientFill( "linear", [0xd7e2c0, 0xb7d8cc, 0xd7e2c0], [1,1,1],[125,127,255], m, "repeat" );
            _progressBar.graphics.drawRoundRect( 1, 1, w-2, 14, 2 );
            _progressBar.graphics.endFill();
            
            _progressPercent.text = n+"%";
            _progressPercent.x = 5 + ( 160 - _progressPercent.width ) / 2; 
        }
        
        protected function initMain () : void
        {
            setProgressLabel( "Looking for a backend" );
            
              var be : SettingsBackend;
            var mainClass:Class = getDefinitionByName(__mainClassName__) as Class;
            
            var settings : XMLList = Reflection.getClassMeta( mainClass, "SettingsBackend" );
            var bck : XML;
            var backend:String;
            var appName : String;
            
            if( settings.length() > 0 )
            {
                bck = settings[0];
                backend = bck.arg.(@key=="backend").@value;
                appName = bck.arg.(@key=="appName").@value;
                _timeout = parseInt( bck.arg.(@key=="timeout").@value ) || 10000;
            }
            
            if( backend && backend != "" )
            {
                setProgressLabel( "Found a backend" );
                try
                {
                    var cls : Class = getDefinitionByName( backend ) as Class;
                    if( cls )
                    {
                        if( appName && appName != "" )
                            be = new cls( appName ) as SettingsBackend;
                        else
                            be = new cls() as SettingsBackend;
                            
                        if(be)
                        {
                            SettingsManagerInstance.backend = be;
                            
                            be.initialized.add( backendInitialized );
                            be.loadingProgressed.add( backendProgressed );

                            setProgressLabel ( getMessage("settings") );
                            _backendTimeout = setTimeout( checkBackendInit, _timeout);
                            
                            setProgressLabel ( "Backend initialize" );
                            be.init();
                        }
                        else 
                        {
                            CONFIG::DEBUG { 
                            Log.error(_$(_("The settings backend '$0' don't implements the SettingsBackend interface."), 
                                          backend ) );
                            } 
                        }
                    }
                    else 
                    {
                        CONFIG::DEBUG { 
                        Log.error( _$(_("The settings backend definition '$0' isn't a Class."), 
                                         backend ) );                                
                        } 
                    }
                }
                catch( e : ReferenceError )
                {
                    CONFIG::DEBUG {                                
                    Log.error( _$(_("The settings backend definition '$0' can't be found in this file."), 
                                     backend ) );
                    } 
                }
                catch( e : Error )
                {       
                    CONFIG::DEBUG {                                
                    Log.error( _$(_("An unespected error occured while creating the following settings backend definition : '$0'\ninstance = $1\n$2"), 
                                  backend, be, e.getStackTrace() ) );
                    }             
                }
            }
            else
                buildMain();
        }
        protected function buildMain() : void
        {
            setProgressLabel( "Start the program" );
            var mainClass:Class = getDefinitionByName(__mainClassName__) as Class;
            
            _app = new mainClass() as DisplayObject;
            if( _app is EntryPoint )
            {
                var ep : EntryPoint = _app as EntryPoint;
                ep.buildSetted.add( proceedBuild );
                ep.init(this);
            }
            else if( _app.hasOwnProperty("init") )
            {
                try
                {
                    _app["init"]( this );
                    if( ComponentFactoryInstance.componentsToBuild > 0 )
                    {
                        ComponentFactoryInstance.buildCompleted.add( buildCompleted );
                        ComponentFactoryInstance.buildProgressed.add( buildProgressed );
                        ComponentFactoryInstance.process();
                        setProgressLabel( getMessage("build") );
                    }
                    else
                        releaseProgressPanel();
                }
                catch( e : Error )
                {
                    CONFIG::DEBUG { 
                        Log.error( e.message + "\n" + e.getStackTrace() );
                    } 
                }
            }
            else
            {
                CONFIG::DEBUG { 
                    Log.warn( _("The main class don't have an init method. The instance will be placed on stage as a regular boot class.") );
                } 
                releaseProgressPanel();
                addChild( _app );
            }
        }
        protected function proceedBuild ( e : EntryPoint ) : void 
        {
            e.buildSetted.remove( proceedBuild );
            
            if( ComponentFactoryInstance.componentsToBuild > 0 )
            {
                ComponentFactoryInstance.buildCompleted.add( buildCompleted );
                ComponentFactoryInstance.buildProgressed.add( buildProgressed );
                ComponentFactoryInstance.process();
                setProgressLabel( getMessage("build") );
            }
            
            else
                releaseProgressPanel();
        }
        protected function checkBackendInit () : void 
        {
            CONFIG::DEBUG {             
            Log.error( _$( _( "Seems like the settings backend $0 haven't respond after $1ms. The settings backend will be discarded and no backend will be used" ), 
                               SettingsManagerInstance.backend ) );
            
            SettingsManagerInstance.backend.initialized.remove( backendInitialized );
            SettingsManagerInstance.backend.loadingProgressed.remove( backendProgressed );
            SettingsManagerInstance.discardBackend();
            buildMain();
            } 
            
        }
        protected function backendInitialized ( be : SettingsBackend ) : void 
        {
            setProgressLabel( "Backend Initialized" );
            SettingsManagerInstance.backend.initialized.remove( backendInitialized );
            SettingsManagerInstance.backend.loadingProgressed.remove( backendProgressed );
            
            clearTimeout( _backendTimeout );
            
            CONFIG::DEBUG { 
            Log.info( _$(_("Settings backend $0 initialized." ), SettingsManagerInstance.backend ) );
            } 
            
            buildMain();
        }
        protected function backendProgressed ( be : SettingsBackend, loaded : Number, total : Number ) : void 
        {
            setProgressValue(  Math.round( loaded / total * 100 ) );
        }
        protected function buildProgressed ( f : ComponentFactory, current : Number, total : Number ) : void 
        {
            setProgressValue( Math.round( current / total * 100 ) );
        }
        protected function buildCompleted ( f : ComponentFactory, current : Number, total : Number ) : void 
        {
            ComponentFactoryInstance.buildCompleted.remove( buildCompleted );
            ComponentFactoryInstance.buildProgressed.remove( buildProgressed );
            releaseProgressPanel();
        }
        CONFIG::WITHOUT_SERVER
        protected var _n : uint = 0;
        
        protected function enterFrame(event:Event):void
        {
            setProgressValue( Math.round( this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal * 100 ) );
            CONFIG::WITHOUT_SERVER { 
            if ( _n >= 100 ) 
            {
               this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
               this.nextFrame();
               setProgressLabel( "Loading complete" );
               loadLang();
            }
            else
            {
                _n++;
                setProgressValue( _n );    
            }
            } 
            
            CONFIG::WITH_DISTANT_SERVER { 
            if (this.framesLoaded >= this.totalFrames) 
            {
               this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
               this.nextFrame();
               setProgressLabel( "Loading complete" );
               loadLang();
            }
            } 
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
                _langLoader.commandEnded.add( langLoadingComplete );
                _numLangFile = _langLoader.size;
                _currentLangFile = 0;
                _langLoader.execute();
                setProgressLabel( getMessage("lang") + " " + _currentLangFile + "/" + _numLangFile );
            }
            else initMain();
        }
        protected function langLoadingProgress (event : ProgressEvent) : void 
        {
            setProgressValue( Math.round( event.bytesLoaded / event.bytesTotal * 100 ) );
        }
        protected function langCallBack ( loader : URLLoader, request : URLRequest ) : void
        {
            _currentLangFile++;
            setProgressLabel( getMessage("lang") + " " + _currentLangFile + "/" + _numLangFile );
            loader.removeEventListener( ProgressEvent.PROGRESS, langLoadingProgress );
            if( loader.dataFormat == URLLoaderDataFormat.TEXT )
            {
                try
                {
                    var poc : POCodec = new POCodec ();
                    GetTextInstance.addTranslations ( poc.decode ( loader.data ) );
                    
                    CONFIG::DEBUG { 
                    Log.info( _$(_("Language in file '$0' successfully loaded."), request.url ) );
                    } 
                }
                catch( e : Error )
                {
                    CONFIG::DEBUG { 
                    Log.error( _$(_("The content of the file '$0' seems not valid.\n$1"), request.url, e.getStackTrace() ) );
                    } 
                }
            }
            else
            {
                try
                {
                    var moc : MOCodec = new MOCodec ();
                    ( loader.data as ByteArray ).endian = Endian.LITTLE_ENDIAN;
                    GetTextInstance.addTranslations ( moc.decode ( loader.data ) );
                    
                    CONFIG::DEBUG { 
                    Log.info( _$(_("Language in file '$0' successfully loaded."), request.url ) );
                    } 
                }
                catch( e : Error )
                {
                    CONFIG::DEBUG { 
                    Log.error( _$(_("The content of the file '$0' seems not valid.\n$1"), request.url, e.getStackTrace() ) );
                    } 
                }
            }
        }

        protected function langLoadingComplete ( ... args ) : void
        {
            CONFIG::DEBUG { 
            Log.info( _("Languages loading completed.") );
            } 
            _langLoader.commandEnded.remove( langLoadingComplete );
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
