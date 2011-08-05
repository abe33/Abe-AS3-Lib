package abe.com.mands.load 
{

	import org.osflash.signals.Signal;

	import flash.net.URLRequest;
	/**
	 * @author Cédric Néhémie
	 */
	public interface LoadEntry
	{
		function get estimator () : Estimator;
		
		function get callback () : Function;
		function set callback ( f : Function ) : void;
		function get request() : URLRequest;
		
		function get ioErrorOccured () : Signal;
		function get securityErrorOccured () : Signal;
		function get loadOpened () : Signal;
		function get loadProgressed () : Signal;
		function get loadCompleted () : Signal;
		
		function load () : void;
		
	}
}
