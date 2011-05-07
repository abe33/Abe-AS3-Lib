package abe.com.mon.grids 
{
	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public interface IntGrid extends Grid
	{
		function get( x : uint, y : uint ) : int;
		function set( x : uint, y : uint, v : int ) : void;
		
		function getPoint( pt : Point ) : int;
		function setPoint( pt : Point, v : int ) : void;
	}
}
