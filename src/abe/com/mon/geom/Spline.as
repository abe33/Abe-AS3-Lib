/**
 * @license
 */
package abe.com.mon.geom
{
	/**
	 * A <code>Spline</code> is a curved geometry consists of several
	 * segments, these segments are themselves constituted by vertices.
	 * <p>
	 * A <code>Spline</code> is the curve connecting all the vertices.
	 * </p>
	 * 
	 * <fr>
	 * Une <code>Spline</code> est une géométrie courbe constituée de plusieurs
	 * segments, ces segments étant eux-mêmes constitués à l'aide de sommets (vertex).
	 * <p>
	 * Une <code>Spline</code> est donc la courbe reliant tout les sommets entre
	 * eux.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface Spline extends Geometry
	{
		/**
		 * A reference to the array containing the objects <code>Point</code>
		 * which represent the different vertices of the spline.
		 * <fr>
		 * Une référence vers le tableau contenant les objets <code>Point</code>
		 * figurant les différents sommets de la <code>Spline</code>
		 * </fr>
		 */
		function get vertices () : Array;
		function set vertices ( v : Array ) : void;
		/**
		 * A boolean value indicating whether the spline is closed or not.
		 * <p>
		 * A spline is considered closed when her first and last vertex have the same coordinates.
		 * </p>
		 * 
		 * <fr>
		 * Une valeur booléenne indiquant si la spline est fermée ou non.
		 * <p>
		 * Une spline est considérée comme fermée lorsque son premier et
		 * son dernier sommet ont les mêmes coordonnées.
		 * </p>
		 * </fr>
		 */
		function get isClosedSpline () : Boolean;
	}
}
