package abe.com.patibility.settings.backends 
{
    import abe.com.mon.utils.Cookie;
    import abe.com.mon.utils.Reflection;
    import abe.com.mon.utils.StringUtils;

    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public class CookieBackend implements SettingsBackend 
    {
        static public const BACKEND_CHANNEL : String = "__BACKEND_CHANNEL__";
        
        static public const ID_SEPARATOR : String = "#";
        static public const PROPERTY_SEPARATOR : String = "_";
        
        protected var _cookie : Cookie;
        protected var _channel : String;
        
        protected var _initialized : Signal;
        protected var _cleared : Signal;
        protected var _synchronized : Signal;
        protected var _ressetted : Signal;
        protected var _loadingProgressed : Signal;
        
        public function CookieBackend ( appName : String = null ) 
        {
            _initialized = new Signal();
            _cleared = new Signal();
            _synchronized = new Signal();
            _ressetted = new Signal();
            _loadingProgressed = new Signal();
        
            _channel = appName ? appName : BACKEND_CHANNEL;
        }
        public function get settingsList () : Array { return _cookie.propertiesTable.concat(); }
        
        public function get initialized () : Signal { return _initialized; }
        public function get cleared () : Signal { return _cleared; }
        public function get synchronized () : Signal { return _synchronized; }
        public function get resetted () : Signal { return _ressetted; }
        public function get loadingProgressed (): Signal  { return _loadingProgressed; }
        
        public function init () : void
        {
            _cookie = new Cookie( _channel );
            fireInitSignal();
        }
        public function sync () : void
        {
            fireSyncSignal();
        }
        public function reset () : void
        {
            fireResetSignal();
        }
        public function clear () : void
        {
            _cookie.clear();
            fireClearSignal();
        }
        
        public function get (o : *, p : String ) : *
        {
            return _cookie[ getQuery(o, p) ];
        }
        public function set (o : *, p : String, v : *) : Boolean
        {
            return _cookie[ setQuery(o, p, v) ] = v;
        }
        public function getWithQuery (s : String) : *
        {
            return _cookie[ s ];
        }
        public function setWithQuery (s : String, v : * ) : Boolean
        {
            return _cookie[ s ] = v; 
        }
        public function getQuery (o : *, p : String) : String
        {
            if( o is String )
                return o + "." + p;
            
            var cls : String = Reflection.getClassName( o );
            var id : String = (o as Object).hasOwnProperty("id") ? ID_SEPARATOR + o["id"] : 
                                (o as Object).hasOwnProperty("name") ? ID_SEPARATOR + o["name"] : "";
            
            return cls + id + PROPERTY_SEPARATOR + p;
        }
        public function setQuery (o : *, p : String, v : *) : String
        {
            return getQuery(o, p);
        }
        
        public function fireInitSignal () : void
        {
            _initialized.dispatch(this);
        }
        public function fireSyncSignal () : void
        {
            _synchronized.dispatch(this);
        }
        public function fireResetSignal () : void
        {
            _ressetted.dispatch(this);
        }
        public function fireClearSignal () : void
        {
            _cleared.dispatch(this);
        }
        public function fireProgressSignal ( loaded : Number, total : Number ) : void
        {
            _loadingProgressed.dispatch( this, loaded, total );
        }
        public function toString() : String
        {
            return StringUtils.stringify(this );
        }
    }
}
