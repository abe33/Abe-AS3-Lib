package abe.com.mon.geom 
{
	/**
	 * La classe <code>SmoothSplineModes</code> contient les constantes
	 * correspondant aux différents modes de lissages fournis par la
	 * classe <code>SmoothSpline</code>.
	 * 
	 * @author Cédric Néhémie
	 * @see SmoothSpline
	 */
	public class SmoothSplineModes 
	{
		/**
		 * Constante correspondant au mode sans lissage pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.noSmoothingMode()</code> implémente le mode de lissage
		 * dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * @see SmoothSpline#noSmoothingMode()
		 */
		static public const NO_SMOOTHING : uint = 0;
		/**
		 * Constante correspondant au mode de lissage absolu pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.absoluteSmoothingMode()</code> implémente le mode de lissage
		 * dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * @see SmoothSpline#absoluteSmoothingMode()
		 */
		static public const ABSOLUTE : uint = 1;
		/**
		 * Constante correspondant au mode de lissage par ratio sur la longueur absolu de la courbe
		 * pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.absoluteCurveRatioSmoothingMode()</code> implémente le mode de lissage
		 * dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * @see SmoothSpline#absoluteCurveRatioSmoothingMode()
		 */
		static public const ABSOLUTE_CURVE_RATIO : uint = 2;
		/**
		 * Constante correspondant au mode de lissage par ratio sur la longueur du segment de la courbe
		 * pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.correspondingSegmentRatioSmoothingMode()</code> implémente 
		 * le mode de lissage dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * @see SmoothSpline#correspondingSegmentRatioSmoothingMode()
		 */
		static public const CORRESPONDING_SEGMENT_RATIO : uint = 3;
		/**
		 * Constante correspondant au mode de lissage par ratio sur la longueur du segment de la courbe
		 * pondéré par la longueur du segment opposé pour la classe <code>SmoothSpline</code>.
		 * <p>
		 * La fonction <code>SmoothSpline.balancedWithOppositeSegmentRatioSmoothingMode()</code> implémente 
		 * le mode de lissage dans la classe <code>SmoothSpline</code>.
		 * </p>
		 * @see SmoothSpline#balancedWithOppositeSegmentRatioSmoothingMode()
		 */		static public const BALANCED_WITH_OPPOSITE_SEGMENT_RATIO : uint = 4;
		/**
		 * 
		 */
		static public const BY_VERTEX_SMOOTHING_MODE : uint = 5;
	}
}
