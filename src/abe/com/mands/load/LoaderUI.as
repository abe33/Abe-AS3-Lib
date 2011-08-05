package abe.com.mands.load 
{

	/**
	 * @author Cédric Néhémie
	 */
	public interface LoaderUI 
	{
		function init() : void;
		function requestSent ( e : LoadEntry ) : void;
		function loadStart ( e : LoadEntry ) : void;
		function loadComplete ( e : LoadEntry ) : void;
		function loadProgress ( e : LoadEntry, loaded : Number, total : Number ) : void;
		function queueComplete ( loader : RootLoader ) : void;
		function estimationsAvailable ( rate : Number, remain : Number ) : void;
		function estimationsProgressed ( rate : Number, remain : Number ) : void;
		function ioError ( str : String ) : void;
		function securityError( str : String ) : void;
	}
}
