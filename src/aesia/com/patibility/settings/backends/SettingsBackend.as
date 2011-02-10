package aesia.com.patibility.settings.backends 
{
	import flash.events.IEventDispatcher;
	/**
	 * @author cedric
	 */
	public interface SettingsBackend extends IEventDispatcher
	{
		function init () : void;		function clear () : void;
		function sync () : void;
		function reset () : void;
		
		function get ( o : *, p : String ) : *;
		function set ( o : *, p : String, v : * ) : Boolean;
		
		function getQuery( o : *, p : String ) : String;		function setQuery( o : *, p : String, v : * ) : String;
		
		function get settingsList () : Array;
		
		function fireInitEvent () : void;		function fireClearEvent () : void;		function fireSyncEvent () : void;
		function fireResetEvent () : void;
		function fireProgressEvent ( loaded :Number, total : Number ) : void;
		function getWithQuery (s : String) : *;		function setWithQuery (s : String, v : * ) : Boolean;
	}
}
