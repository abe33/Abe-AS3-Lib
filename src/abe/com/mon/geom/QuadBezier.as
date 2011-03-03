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
	 * A quadratic Bezier curve is a curve where each segment
	 * has an additionnal control vertex. Each segment is composed
	 * of <code>3</code> vertices.
	 * <p>
	 * The length of the array must be equal to <code>numSeg * 2 + 1</code>.
	 * </p>
	 * <fr>
	 * Une courbe de bezier quadratique est une une courbe où chaque
	 * segment possède un sommet de contrôle supplémentaire.
	 * Chaque segment est donc constitué de <code>3</code> sommets.
	 * <p>
	 * La longueur du tableau doit être égale à <code>numSeg * 2 + 1</code>.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class QuadBezier extends AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * <code>QuadBezier</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>QuadBezier</code>.
		 * </fr>
		 * @param	v		an array of objects <code>Point</code> representing the vertices
		 * 					of the curve. The length of the array must be equal to 
		 * 					<code>numSeg * 2 + 1 </code> to be considered valid.
		 * 					<fr>un tableau d'objets <code>Point</code> représentant les sommets
		 * 					de la courbe. La longueur du tableau doit être égale à
		 * 					<code>numSeg * 2 + 1</code> pour être considéré comme valide.</fr>
		 * @param	bias	parameter refinement in the calculations and drawings of the curve
		 * 					<fr>paramètre de finesse pour les calculs et les dessins de la courbe</fr>
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
			pt.x = ( seg[0].x * b1 ( t ) ) + ( seg[1].x * b2 ( t ) ) + ( seg[2].x * b3 ( t ) );			pt.y = ( seg[0].y * b1 ( t ) ) + ( seg[1].y * b2 ( t ) ) + ( seg[2].y * b3 ( t ) );
			return pt;
		}
		/**
		 * @copy CubicBezier#b1()
		 */
		public function b1 ( t : Number ) : Number { return ( ( 1 - t ) * ( 1 - t ) ) ; }
		/**
		 * @copy CubicBezier#b2()
		 */
		public function b2 ( t : Number ) : Number { return ( 2 * t * ( 1 - t ) ) ; }
		/**
		 * @copy CubicBezier#b4()
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
