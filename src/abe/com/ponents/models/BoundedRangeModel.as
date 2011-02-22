package abe.com.ponents.models 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	public interface BoundedRangeModel extends IEventDispatcher
	{
		function get maximum () : Number;		function set maximum ( n : Number ) : void;
				function get minimum () : Number;		function set minimum ( n : Number ) : void;
		
		function get displayValue () : String;
				function get value () : Number;		function set value ( v : Number ) : void;
		
		function get extent () : Number;
		function set extent ( v : Number ) : void;
		
		function get valuePositionInRange() : Number;
	}
}
