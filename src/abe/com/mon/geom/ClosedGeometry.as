/**
 * @license
 */
package abe.com.mon.geom 
{
    import flash.geom.Point;
	/**
	 * A <code>ClosedGeometry</code> is a geometry which is closed and which can returns
	 * coordinates in its path using an angle.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface ClosedGeometry extends Geometry 
	{
		/**
		 * Returns the coordinates in the geometry path using the
		 * passed-in angle <code>a</code>.
		 * 
		 * @param	a	an angle in radians
		 * @return	the coordinates in the geometry path using the
		 * 			passed-in angle
		 */
		function getPointAtAngle( a : Number ) : Point;
	}
}
