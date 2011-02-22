package abe.com.ponents.dnd.gestures 
{
	import abe.com.ponents.dnd.DragSource;

	/**
	 * @author cedric
	 */
	public interface DragGesture 
	{
		function get target () : DragSource;
		function set target ( source : DragSource ) : void;
		
		function get enabled () : Boolean;
		function set enabled ( b : Boolean ) : void;
		
		function get isDragging () : Boolean;
	}
}
