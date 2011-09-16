/**
 * @license
 */
package abe.com.mon.geom
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Serializable;
    import abe.com.mon.utils.StringUtils;
    import abe.com.mon.utils.magicToReflectionSource;

    import flash.display.Graphics;
    import flash.utils.getQualifiedClassName;
	/**
	 * The <code>LinearSpline</code> class is a concret implementation 
	 * of <code>AbstractSpline</code> with segments of size <code>1</code>. 
	 * <p> 
	 * The number of segments is equal to <code>vertices.length - 1</code>. 
	 * The array containing the vertices are considered valid when it has
	 * two vertices or more.
	 * </p>
	 * <fr>
	 * La classe <code>LinearSpline</code> est une implémentation de
	 * la classe <code>AbstractSpline</code> avec des segments de taille <code>1</code>.
	 * <p>
	 * Le nombre de segments est donc égale à <code>vertices.length - 1</code>. Le tableau
	 * contenant les sommets étant considéré comme valide dès qu'il possède deux sommets
	 * ou plus.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
    [Serialize(constuctorArgs="vertices,drawBias")]
	public class LinearSpline extends AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * <code>LinearSpline</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>LinearSpline</code>.
		 * </fr>
		 * @param	v		array containing the vertices of this curve
		 * 					<fr>tableau contenant les sommets de cette courbe</fr>
		 * @param	bias	parameter refinement for length calculations and drawings
		 * 					of the curve
		 * 					<fr>paramètre de finesse pour les calculs de longueur
		 * 					et les dessins de la courbe</fr>
		 */
		public function LinearSpline (v : Array = null, bias : Number = 1 )
		{
			super( v, 1, bias );
		}
		/**
		 * @inheritDoc
		 */
		override public function get numSegments () : uint
		{
			return _vertices.length - 1;
		}
		/**
		 * @inheritDoc
		 */
		override protected function checkVertices ( v : Array ) : Boolean
		{
			return v.length >= 2;
		}
		/**
		 * <p>In the <code>LinearSpline</code> class, this method do nothing.</p>
		 * 
		 * @inheritDoc
		 */
		override protected function drawVerticesConnections (g : Graphics) : void {}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawSegment ( seg : Array, g : Graphics, c : Color ) : void
		{
			g.lineStyle(0,c.hexa, c.alpha/255);
			g.moveTo(seg[0].x, seg[0].y);
			g.lineTo(seg[1].x, seg[1].y);
		}
		/**
		 * @inheritDoc
		 */
		override public function get points () : Array { return _vertices.concat(); }


	}
}
