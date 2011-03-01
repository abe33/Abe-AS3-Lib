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
	 * Une courbe de bezier quadratique est une une courbe où chaque
	 * segment possède un sommet de contrôle supplémentaire.
	 * Chaque segment est donc constitué de <code>3</code> sommets.
	 * <p>
	 * La longueur du tableau doit être égale à <code>numSeg * 2 + 1</code>.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class QuadBezier extends AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * Constructeur de la classe <code>QuadBezier</code>.
		 *
		 * @param	v		un tableau d'objets <code>Point</code> représentant les sommets
		 * 					de la courbe. La longueur du tableau doit être égale à
		 * 					<code>numSeg * 2 + 1</code> pour être considéré comme valide.
		 * @param	bias	paramètre de finesse pour les calculs et les dessins de la courbe
		 */
		public function QuadBezier ( v : Array = null, bias : Number = 20 )
		{
			super( v, 2, bias );
		}

		/**
		 * @inheritDoc
		 */
		override protected function getInnerSegmentPoint ( t : Number, seg : Array ) : Point
		{
			var pt : Point = new Point();
			pt.x = ( seg[0].x * b1 ( t ) ) + ( seg[1].x * b2 ( t ) ) + ( seg[2].x * b3 ( t ) );
			return pt;
		}
		/**
		 * Fonction de Bezier pour le premier sommet d'un segment.
		 *
		 * @param	t	valeur de bias courante
		 * @return	une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet
		 */
		public function b1 ( t : Number ) : Number { return ( ( 1 - t ) * ( 1 - t ) ) ; }
		/**
		 * Fonction de Bezier pour le second sommet d'un segment.
		 *
		 * @param	t	valeur de bias courante
		 * @return	une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet
		 */
		public function b2 ( t : Number ) : Number { return ( 2 * t * ( 1 - t ) ) ; }
		/**
		 * Fonction de Bezier pour le dernier sommet d'un segment.
		 *
		 * @param	t	valeur de bias courante
		 * @return	une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet
		 */
		public function b3 ( t : Number ) : Number { return ( t * t ) ; }
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace(	"new $0 ($1,$2)",
						getQualifiedClassName ( this ),
						magicToReflectionSource ( _vertices ),
						drawBias );
		}
	}
}