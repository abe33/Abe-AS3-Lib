/**
 * @license
 */
package abe.com.mon.geom
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Serializable;
    import abe.com.mon.utils.StringUtils;
    import abe.com.mon.utils.magicToReflectionSource;

    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;
	/**
	 * <code>CubicBezier</code> curve is a curve where each segment 
	 * has two vertices of additional controls. Each segment 
	 * is composed of <code>4</code> vertices.
	 * <p>
	 * The length of the array must be equal to <code>numSeg * 3 + 1</code>.
	 * </p>
	 * 
	 * <fr>
	 * Une courbe de bezier cubique est une une courbe où chaque
	 * segment possède deux sommets de contrôles supplémentaires.
	 * Chaque segment est donc constitué de <code>4</code> sommets.
	 * <p>
	 * La longueur du tableau doit être égale à <code>numSeg * 3 + 1</code>.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class CubicBezier extends AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * <code>CubicBezier</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>CubicBezier</code>.
		 * </fr>
		 * @param	v		an array of objects <code>Point</code> representing the vertices
		 * 					of the curve. The length of the array must be equal 
		 * 					to <code>numSeg * 3 + 1</code> to be considered valid.
		 * 					<fr>un tableau d'objets <code>Point</code> représentant les sommets
		 * 					de la courbe. La longueur du tableau doit être égale à
		 * 					<code>numSeg * 3 + 1</code> pour être considéré comme valide.</fr>
		 * @param	bias	refinement parameter in the calculations and drawings of the curve
		 * 					<fr>paramètre de finesse pour les calculs et les dessins de la courbe</fr>
		 */
		public function CubicBezier (v : Array = null, bias : Number = 20)
		{
			super( v, 3, bias );
		}
		/**
		 * @inheritDoc
		 */
		override protected function getInnerSegmentPoint ( t : Number, seg : Array ) : Point
		{
			var pt : Point = new Point();
			pt.x = ( seg[0].x * b1 ( t ) ) + ( seg[1].x * b2 ( t ) ) + ( seg[2].x * b3 ( t ) ) + ( seg[3].x * b4 ( t ) );
			pt.y = ( seg[0].y * b1 ( t ) ) + ( seg[1].y * b2 ( t ) ) + ( seg[2].y * b3 ( t ) ) + ( seg[3].y * b4 ( t ) );
			return pt;
		}
		/**
		 * Bezier function for the first vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le premier sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b1 ( t : Number ) : Number { return ( ( 1 - t ) * ( 1 - t ) * ( 1 - t ) ) ; }
		/**
		 * Bezier function for the second vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le second sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b2 ( t : Number ) : Number { return ( 3 * t * ( 1 - t ) * ( 1 - t ) ) ; }
		/**
		 * Bezier function for the third vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le troisième sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b3 ( t : Number ) : Number { return ( 3 * t * t * ( 1 - t ) ) ; }
		/**
		 * Bezier function for the last vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le dernier sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b4 ( t : Number ) : Number { return ( t * t * t ) ; }
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace( "new $0 ($1,$2)",
						getQualifiedClassName ( this ),
						magicToReflectionSource ( _vertices ),
						drawBias );
		}
	}
}
