package abe.com.mands.load 
{
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	/**
	 * @author Cédric Néhémie
	 */
	public interface LoadEntry extends IEventDispatcher 
	{
		function get estimator () : Estimator;
				function get callback () : Function;		function set callback ( f : Function ) : void;
		
		function load () : void;
		
		function get request() : URLRequest;
		
		function fireIOErrorEvent ( msg : String ) : void;		function fireSecurityErrorEvent ( msg : String ) : void;		
		function fireOpenEvent () : void;		function fireProgressEvent ( loaded : Number, total : Number ) : void;
		function fireCompleteEvent () : void;
	}
}
