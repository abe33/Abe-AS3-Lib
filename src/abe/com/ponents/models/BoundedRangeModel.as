package abe.com.ponents.models 
{
	import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	public interface BoundedRangeModel
	{
		function get maximum () : Number;
		function set maximum ( n : Number ) : void;
		
		function get minimum () : Number;
		function set minimum ( n : Number ) : void;
		
		function get displayValue () : String;
		
		function get value () : Number;
		function set value ( v : Number ) : void;
		
		function get extent () : Number;
		function set extent ( v : Number ) : void;
		
		function get valuePositionInRange() : Number;
		
		function get dataChanged() : Signal;
	}
}
