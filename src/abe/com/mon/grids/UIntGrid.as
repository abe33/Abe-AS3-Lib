package abe.com.mon.grids 
{
	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public interface UIntGrid extends Grid 
	{
		function get( x : uint, y : uint ) : uint;		function set( x : uint, y : uint, v : uint ) : void;
				function getPoint( pt : Point ) : uint;
		function setPoint( pt : Point, v : uint ) : void;
	}
}
