package aesia.com.patibility.settings.backends 
{
	import flash.events.IEventDispatcher;
	/**
	 * @author cedric
	 */
	public interface SettingsBackend extends IEventDispatcher
	{
		function init () : void;
		function sync () : void;
		function reset () : void;
		
		function get ( o : *, p : String ) : *;
		function set ( o : *, p : String, v : * ) : Boolean;
		
		function getQuery( o : *, p : String ) : String;
		
		function fireInitEvent () : void;
		function fireResetEvent () : void;
		function fireProgressEvent ( loaded :Number, total : Number ) : void;
	}
}