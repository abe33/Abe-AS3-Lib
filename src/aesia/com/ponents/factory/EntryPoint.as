package aesia.com.ponents.factory 
{
	import flash.events.IEventDispatcher;
	/**
	 * @author cedric
	 */
	public interface EntryPoint extends IEventDispatcher
	{
		function init( preload : ComponentFactoryPreload ) : void;
		function fireProceedBuild() : void;
	}
}
