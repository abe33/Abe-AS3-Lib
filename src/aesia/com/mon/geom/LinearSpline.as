/**
 * @license
 */
package aesia.com.mon.geom
{
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.mon.utils.magicToReflectionSource;

	import flash.display.Graphics;
	import flash.utils.getQualifiedClassName;

	/**
	 * La classe <code>LinearSpline</code> est une implémentation de
	 * la classe <code>AbstractSpline</code> avec des segments de taille <code>1</code>.
	 * <p>
	 * Le nombre de segments est donc égale à <code>vertices.lenght - 1</code>. Le tableau
	 * contenant les sommets étant considéré comme valide dès qu'il possède deux sommets
	 * ou plus.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class LinearSpline extends AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * Constructeur de la classe <code>LinearSpline</code>.
		 *
		 * @param	v		tableau contenant les sommets de cette courbe
		 * @param	bias	paramètre de finesse pour les calculs de longueur
		 * 					et les dessins de la courbe
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
		 * @inheritDoc
		 */
		override protected function drawVerticesConnections (g : Graphics) : void
		{}
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
