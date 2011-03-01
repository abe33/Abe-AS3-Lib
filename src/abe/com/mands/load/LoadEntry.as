package abe.com.mands.load 
{

	import flash.net.URLRequest;
	import flash.events.IEventDispatcher;
	/**
	 * @author Cédric Néhémie
	 */
	public interface LoadEntry extends IEventDispatcher 
	{
		function get estimator () : Estimator;
		
		
		function load () : void;
		
		function get request() : URLRequest;
		
		function fireIOErrorEvent ( msg : String ) : void;
		function fireOpenEvent () : void;
		function fireCompleteEvent () : void;
	}
}