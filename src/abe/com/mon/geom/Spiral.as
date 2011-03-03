/**
 * @license
 */
package abe.com.mon.geom 
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code>Spiral</code> class provides a mathematical representation
	 * of a spiral.
	 * 
	 * @author Cédric Néhémie
	 */
	public class Spiral extends Ellipsis implements  Cloneable,
													 Serializable,
													 Equatable,
													 Geometry,
													 ClosedGeometry,
													 Path,
													 Surface,
													 FormMetaProvider
	{
		[Form(type="floatSpinner",
			  label="Twirl",
			  range="0,Number.POSITIVE_INFINITY",
			  step="1",
			  order="6")]
		/**
		 * The number of twirl made by the spiral around its axis.
		 * <fr>
		 * Le nombre de tour que fait la spirale autour de son axe.
		 * </fr>
		 * @default 1
		 */		
		public var twirl : Number;
		/**
		 * <code>Spiral</code> class constructor.
		 * 
		 * @param	x			x position of the ellipse
		 * 						<fr>position en x de l'ellipse</fr>
		 * @param	y			y position of the ellipse
		 * 						<fr>position en y de l'ellipse</fr>
		 * @param	radius1		first radius of the ellipse
		 * 						<fr>premier rayon de l'ellipse</fr>
		 * @param	radius2		second radius of the ellipse
		 * 						<fr>second rayon de l'ellipse</fr>
		 * @param	twirl		number of twirl made by the spiral
		 * 						around its axis
		 * @param	rotation	rotation of the ellipse in radians
		 * 						<fr>rotation de l'ellipse en radians</fr>
		 * @param	bias		drawing bias of this ellipse
		 * 						<fr>la précision dans le dessin de l'ellipse</fr>
		 */
		public function Spiral ( x : Number = 0, 
								 y : Number = 0, 
								 radius1 : Number = 1, 
								 radius2 : Number = 1, 
								 twirl : Number = 1,
								 rotation : Number = 0, 
								 bias : uint = DRAWING_BIAS )
		{
			super( x, y, radius1, radius2, rotation, bias );
			this.twirl = twirl;
		}
		/**
		 * @inheritDoc
		 */
		override public function getPointAtAngle ( a : Number) : Point 
		{
			var p : Point = new Point ( radius1 * Math.cos( a * twirl ),
										radius2 * Math.sin( a * twirl ) );

			p = PointUtils.rotate( p, rotation );

			p.normalize( p.length * ( a / MathUtils.PI2 ) );
			return new Point( x + p.x, y + p.y );
		}
		/**
		 * <p>
		 * <strong>Note:</strong> The <code>fill</code> method is not supported
		 * by the class <code>Spiral</code>.
		 * <fr>
		 * <strong>Note : </strong> La méthode <code>fill</code> n'est pas supportée
		 * par la classe <code>Spiral</code>. 
		 * </fr>
		 * </p>
		 * @inheritDoc
		 * @throws Error The Spiral class, despite extending Ellipsis, doesn't support the fill method.
		 */
		override public function fill (g : Graphics, c : Color) : void 
		{
			throw new Error( "The Spiral class, despite extending Ellipsis, doesn't support the fill method." );
		}
		/**
		 * <p>
		 * <strong>Note:</strong> The <code>contains</code> method is not supported
		 * by the class <code>Spiral</code>.
		 * <fr>
		 * <strong>Note : </strong> La méthode <code>contains</code> n'est pas supportée
		 * par la classe <code>Spiral</code>.
		 * </fr> 
		 * </p>
		 * @inheritDoc
		 * @throws Error The Spiral class, despite extending Ellipsis, doesn't support the contains method.
		 */
		override public function contains (x : Number, y : Number) : Boolean 
		{
			throw new Error( "The Spiral class, despite extending Ellipsis, doesn't support the contains method." );
		}
		/**
		 * <p>
		 * <strong>Note:</strong> The <code>containsPoint</code> method is not supported
		 * by the class <code>Spiral</code>.
		 * <fr>
		 * <strong>Note : </strong> La méthode <code>containsPoint</code> n'est pas supportée
		 * par la classe <code>Spiral</code>. 
		 * </fr>
		 * </p>
		 * @inheritDoc
		 * @throws Error The Spiral class, despite extending Ellipsis, doesn't support the containsPoint method.
		 */
		override public function containsPoint ( p : Point ) : Boolean 
		{
			throw new Error( "The Spiral class, despite extending Ellipsis, doesn't support the containsPoint method." );
		}
		/**
		 * <p>
		 * <strong>Note:</strong> The <code>containsGeometry</code> method is not supported
		 * by the class <code>Spiral</code>.
		 * <fr>
		 * <strong>Note : </strong> La méthode <code>containsGeometry</code> n'est pas supportée
		 * par la classe <code>Spiral</code>. 
		 * </fr>
		 * </p>
		 * @inheritDoc
		 * @throws Error The Spiral class, despite extending Ellipsis, doesn't support the containsGeometry method.
		 */
		override public function containsGeometry ( g : Geometry ) : Boolean 
		{
			throw new Error( "The Spiral class, despite extending Ellipsis, doesn't support the containsGeometry method." );
		}
		/**
		 * <p>
		 * Two spirals are equal if their radii are equal
		 * and that their twirl is equal.
		 * <fr>
		 * Deux spirales sont égales si leur rayons sont égaux et que
		 * leur tourbillon est égale.
		 * </fr>
		 * </p>
		 * @inheritDoc
		 */
		override public function equals (o : *) : Boolean
		{
			if( o is Spiral )
				return ( o as Spiral ).radius1 == radius1 &&
					   ( o as Spiral ).radius2 == radius2 &&					   ( o as Spiral ).twirl == twirl;

			return false;
		}
		/**
		 * @inheritDoc
		 */
		override public function clone () : * 
		{
			return new Spiral(x, y, radius1, radius2, twirl, rotation, drawBias );
		}
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String 
		{
			return StringUtils.tokenReplace("new $0($1,$2,$3,$4,$5,$6,$7)", 
											getQualifiedClassName( this ),
											x, y, 
											radius1, radius2,
											twirl,
											rotation,
											drawBias );
		}
		/**
		 * @inheritDoc
		 */
		override public function toString () : String 
		{
			return StringUtils.stringify(this,{ radius1:radius1, radius2:radius2, twirl:twirl } );
		}
	}
}
