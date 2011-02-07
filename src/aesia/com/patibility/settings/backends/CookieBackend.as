package aesia.com.patibility.settings.backends 
{
	import aesia.com.mon.utils.Cookie;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.settings.events.SettingsBackendEvent;

	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	/**
	 * @author cedric
	 */
	public class CookieBackend extends EventDispatcher implements SettingsBackend 
	{
		static public const BACKEND_CHANNEL : String = "__BACKEND_CHANNEL__";
		
		static public const ID_SEPARATOR : String = "#";
		
		
		protected var _cookie : Cookie;
		protected var _properties : Array;
		
		protected var _channel : String;
		
		public function CookieBackend ( appName : String = null ) 
		{
			_channel = appName ? appName : BACKEND_CHANNEL;
		}
		public function init () : void
		{
			_cookie = new Cookie( _channel );
			fireInitEvent();
		}
		public function sync () : void
		{
			fireSyncEvent();
		}
		public function reset () : void
		{
			fireResetEvent();
		}
		public function clear () : void
		{
			_cookie.clear();
			fireClearEvent();
		}
		
		public function get (o : *, p : String ) : *
		{
			return _cookie[ getQuery(o, p) ];
		}
		public function set (o : *, p : String, v : *) : Boolean
		{
			return _cookie[ setQuery(o, p, v) ] = v;
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
		
		public function fireInitEvent () : void
		{
			dispatchEvent(new SettingsBackendEvent(SettingsBackendEvent.INIT));
		public function fireSyncEvent () : void
		{
			dispatchEvent(new SettingsBackendEvent(SettingsBackendEvent.SYNC));
		public function fireResetEvent () : void
		{
			dispatchEvent(new SettingsBackendEvent(SettingsBackendEvent.RESET));
		{
			dispatchEvent(new SettingsBackendEvent(SettingsBackendEvent.CLEAR));
		}
		public function fireProgressEvent ( loaded : Number, total : Number ) : void
		{
			dispatchEvent(new ProgressEvent ( SettingsBackendEvent.RESET, false, false, loaded, total ));
		}
		override public function toString() : String
		{
			return StringUtils.stringify(this );
		}
	
	}
}