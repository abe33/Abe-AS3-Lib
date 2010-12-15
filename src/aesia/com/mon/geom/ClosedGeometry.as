package aesia.com.mon.geom 
{
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public interface ClosedGeometry extends Geometry 
	{
		function getPointAtAngle( a : Number ) : Point;
	}
}
