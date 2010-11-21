package aesia.com.ponents.models 
{
	import flash.ui.ContextMenuItem;
	import flash.events.IEventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	public interface SpinnerModel extends IEventDispatcher
	{
		function get displayValue () : String;
		function get value () : *;		function set value ( v : * ) : void;
		function hasNextValue () : Boolean;
		function getNextValue () : *;
		function hasPreviousValue () : Boolean;		function getPreviousValue () : *;
		
		function reset() : void;
		
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			function get modelMenuContext () : Vector.<ContextMenuItem>;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
