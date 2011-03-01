package abe.com.ponents.models 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	public interface BoundedRangeModel extends IEventDispatcher
	{
		function get maximum () : Number;
		
		
		function get displayValue () : String;
		
		
		function get extent () : Number;
		function set extent ( v : Number ) : void;
		
		function get valuePositionInRange() : Number;
	}
}