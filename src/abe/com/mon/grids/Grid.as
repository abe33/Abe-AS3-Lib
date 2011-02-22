package abe.com.mon.grids 
{
	import flash.geom.Rectangle;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public interface Grid 
	{
		function get width () : uint;
		function get height () : uint;
		
		function swap( x1 : uint, y1 : uint, x2 : uint, y2 : uint ) : void;		function swapPoint( pt1 : Point, pt2 : Point ) : void;
		
		function pushRowToLeft( row : uint ) : void;		function pushRowToRight( row : uint ) : void;		function pushColToTop( col : uint ) : void;		function pushColToBottom( col : uint ) : void;
		
		function isValidCoordinates ( x : uint, y : uint ) : Boolean;				function isValidPoint ( pt : Point ) : Boolean;
		function isValidRow ( row : uint ) : Boolean;		function isValidCol ( col : uint ) : Boolean;
		
		function subGrid ( r : Rectangle ) : Grid;
		
		function toArray() : Array;
	}
}
