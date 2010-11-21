package aesia.com.mon.grids 
{
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public interface StringGrid extends Grid
	{
		function get( x : uint, y : uint ) : String;
		function set( x : uint, y : uint, v : String ) : void;
		
		function getPoint( pt : Point ) : String;
		function setPoint( pt : Point, v : String ) : void;
	}
}
