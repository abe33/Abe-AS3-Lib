package abe.com.mon.grids 
{
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public interface UIntGrid extends Grid 
	{
		function get( x : uint, y : uint ) : uint;
		
		function setPoint( pt : Point, v : uint ) : void;
	}
}