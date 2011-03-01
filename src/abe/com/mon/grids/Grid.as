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
		
		function swap( x1 : uint, y1 : uint, x2 : uint, y2 : uint ) : void;
		
		function pushRowToLeft( row : uint ) : void;
		
		function isValidCoordinates ( x : uint, y : uint ) : Boolean;		
		function isValidRow ( row : uint ) : Boolean;
		
		function subGrid ( r : Rectangle ) : Grid;
		
		function toArray() : Array;
	}
}