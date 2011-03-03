/**
 * @license
 */
package abe.com.mon.geom 
{
	/**
	 * The <code>SmoothSplineModes</code> class contains the constants
	 * corresponding to the different modes of smoothing provided
	 * by the class <code>SmoothSpline</code>.
	 * <fr>
	 * La classe <code>SmoothSplineModes</code> contient les constantes
	 * correspondant aux différents modes de lissages fournis par la
	 * classe <code>SmoothSpline</code>.
	 * </fr>
	 * @author Cédric Néhémie
	 * @see SmoothSpline
	 */
	public class SmoothSplineModes 
	{
		/**
		 * Constant for the no-smoothing mode of the class <code>SmoothSpline</code>.
		 * <p>
		 * The <code>SmoothSpline.noSmoothingMode()</code> method implements the
		 * smoothing mode in the class <code>SmoothSpline</code>.
		 * </p>
		 * <fr>
		 * Constante correspondant au mode sans lissage pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.noSmoothingMode()</code> implémente le mode de lissage
		 * dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * </fr>
		 * @see SmoothSpline#noSmoothingMode()
		 */
		static public const NO_SMOOTHING : uint = 0;
		/**
		 * Constant for the absolute smoothing mode of the class <code>SmoothSpline</code>.
		 * <p>
		 * The <code>SmoothSpline.absoluteSmoothingMode()</code> method implements the
		 * smoothing mode in the class <code>SmoothSpline</code>.
		 * </p>
		 * <fr>
		 * Constante correspondant au mode de lissage absolu pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.absoluteSmoothingMode()</code> implémente le mode de lissage
		 * dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * </fr>
		 * @see SmoothSpline#absoluteSmoothingMode()
		 */
		static public const ABSOLUTE : uint = 1;
		/**
		 * Constant for the absolute ratio smoothing mode of the class <code>SmoothSpline</code>.
		 * <p>
		 * The <code>SmoothSpline.absoluteCurveRatioSmoothingMode()</code> method implements the
		 * smoothing mode in the class <code>SmoothSpline</code>.
		 * </p>
		 * <fr>
		 * Constante correspondant au mode de lissage par ratio sur la longueur absolu de la courbe
		 * pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.absoluteCurveRatioSmoothingMode()</code> implémente le mode de lissage
		 * dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * </fr>
		 * @see SmoothSpline#absoluteCurveRatioSmoothingMode()
		 */
		static public const ABSOLUTE_CURVE_RATIO : uint = 2;
		/**
		 * Constant for the relative ratio smoothing mode of the class <code>SmoothSpline</code>.
		 * <p>
		 * The <code>SmoothSpline.correspondingSegmentRatioSmoothingMode()</code> method implements the
		 * smoothing mode in the class <code>SmoothSpline</code>.
		 * </p>
		 * <fr>
		 * Constante correspondant au mode de lissage par ratio sur la longueur du segment de la courbe
		 * pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.correspondingSegmentRatioSmoothingMode()</code> implémente 
		 * le mode de lissage dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * </fr>
		 * @see SmoothSpline#correspondingSegmentRatioSmoothingMode()
		 */
		static public const CORRESPONDING_SEGMENT_RATIO : uint = 3;
		/**
		 * Constant for the balanced segment ratio smoothing mode of the class <code>SmoothSpline</code>.
		 * <p>
		 * The <code>SmoothSpline.balancedWithOppositeSegmentRatioSmoothingMode()</code> method implements the
		 * smoothing mode in the class <code>SmoothSpline</code>.
		 * </p>
		 * <fr>
		 * Constante correspondant au mode de lissage par ratio sur la longueur du segment de la courbe
		 * pondéré par la longueur du segment opposé pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.balancedWithOppositeSegmentRatioSmoothingMode()</code> implémente 
		 * le mode de lissage dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * </fr>
		 * @see SmoothSpline#balancedWithOppositeSegmentRatioSmoothingMode()
		 */		static public const BALANCED_WITH_OPPOSITE_SEGMENT_RATIO : uint = 4;
		/**
		 * Constant for the by vertex smoothing mode of the class <code>SmoothSpline</code>.
		 * <p>
		 * The <code>SmoothSpline.byVertexSmoothingMode()</code> method implements the
		 * smoothing mode in the class <code>SmoothSpline</code>.
		 * </p>
		 * 
		 * @see SmoothSpline#byVertexSmoothingMode()
		 */
		static public const BY_VERTEX_SMOOTHING_MODE : uint = 5;
	}
}
