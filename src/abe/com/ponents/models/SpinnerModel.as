package abe.com.ponents.models 
{
	import flash.ui.ContextMenuItem;
	
	import org.osflash.signals.Signal;
	
	/**
	 * @author Cédric Néhémie
	 */
	public interface SpinnerModel
	{
		function get displayValue () : String;
		function get value () : *;
		function set value ( v : * ) : void;
		function hasNextValue () : Boolean;
		function getNextValue () : *;
		function hasPreviousValue () : Boolean;
		function getPreviousValue () : *;
		
		function get dataChanged ():Signal;
		function get propertyChanged ():Signal;
		
		function reset() : void;
		
		FEATURES::MENU_CONTEXT { 
		    TARGET::FLASH_9
		    function get modelMenuContext () : Array;
		
		    TARGET::FLASH_10
		    function get modelMenuContext () : Vector.<ContextMenuItem>;
		
		    TARGET::FLASH_10_1 
		    function get modelMenuContext () : Vector.<ContextMenuItem>;
		} 
	}
}
