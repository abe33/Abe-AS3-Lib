/**
 * @license
 */
package aesia.com.mon.geom
{
	/**
	 * Une <code>Spline</code> est une géométrie courbe constituée de plusieurs
	 * segments, ces segments étant eux-mêmes constitués à l'aide de sommets (vertex).
	 * <p>
	 * Une <code>Spline</code> est donc la courbe reliant tout les sommets entre
	 * eux.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public interface Spline extends Geometry, Path
	{
		/**
		 * Une référence vers le tableau contenant les objets <code>Point</code>
		 * figurant les différents sommets de la <code>Spline</code>
		 */
		function get vertices () : Array;
		function set vertices ( v : Array ) : void;
		/**
		 * Une valeur booléenne indiquant si la spline est fermée ou non.
		 * <p>
		 * Une spline est considérée comme fermée lorsque son premier et
		 * son dernier sommet ont les mêmes coordonnées.
		 * </p>
		 */
		function get isClosedSpline () : Boolean;
	}
}
