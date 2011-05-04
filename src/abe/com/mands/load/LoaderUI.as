package abe.com.mands.load 
{
	import abe.com.mands.events.LoadingEstimationEvent;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * @author Cédric Néhémie
	 */
	public interface LoaderUI 
	{
		function init() : void;
		function requestSent ( e : Event ) : void;
		function loadStart ( e : Event ) : void;		function loadComplete ( e : Event ) : void;
		function loadProgress ( e : ProgressEvent ) : void;		function queueComplete ( e : Event ) : void;
		function estimationsAvailable ( e : LoadingEstimationEvent ) : void;		function newEstimation ( e : LoadingEstimationEvent ) : void;
		function ioError ( e : IOErrorEvent ) : void;
		function securityError( e : SecurityErrorEvent ) : void;
	}
}
