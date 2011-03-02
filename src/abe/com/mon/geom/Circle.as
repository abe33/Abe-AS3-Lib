/**
 * @license
 */
package  abe.com.mon.geom
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.StringUtils;

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	[FormList(fields="radius1,radius2,rotation")]
	/**
	 * The <code>Circle</code> class extends the <code>Ellipsis</code> class
	 * to handle the specific case of circles.
	 * <fr>
	 * La classe <code>Circle</code> étend la classe <code>Ellipsis</code> afin de gérer
	 * le cas spécifique des cercles.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Circle extends Ellipsis implements Cloneable,
													Serializable,
													Equatable,
													Geometry,
													Path,
													Surface,
													FormMetaProvider,
													ClosedGeometry
	{
		/**
		 * <code>Circle</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>Circle</code>.
		 * </fr>
		 * @param	x		X position of the circle
		 * 					<fr>position du cercle en X</fr>
		 * @param	y		Y position of the circle
		 * 					<fr>position du cercle en Y</fr>
		 * @param	radius	circle radius
		 * 					<fr>rayon du cercle</fr>
		 */
		public function Circle ( x : Number = 0, y : Number = 0, radius : Number = 1 )
		{
			super( x, y, radius, radius );
		}
		/**
		 * @inheritDoc
		 */
		override public function get acreage () : Number { return Math.PI * radius * radius; }

		/**
		 * @inheritDoc
		 */
		override public function getPointAtAngle ( a : Number ) : Point
		{
			var p : Point = new Point ( radius1 * Math.cos( a ),
										radius1 * Math.sin( a ) );

			return new Point( x + p.x, y + p.y );
		}

		[Form(type="floatSpinner",
			  label="Radius",
			  range="0,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * Radius of this circle.
		 * 
		 * <fr>Le rayon de ce cercle.</fr>
		 */
		public function get radius () : Number { return radius1; }
		public function set radius ( n : Number ) : void
		{
			radius1 = radius2 = n;
		}
		/**
		 * @inheritDoc
		 */
		override public function equals (o : *) : Boolean
		{
			if( o is Circle )
				return ( o as Circle ).radius == radius;

			if( o is Ellipsis )
				return ( o as Ellipsis ).radius1 == radius &&
					   ( o as Ellipsis ).radius2 == radius;

			return false;
		}
		/**
		 * @inheritDoc
		 */
		override public function clone () : *
		{
			return new Circle( x, y, radius1 );
		}
		/**
		 * @inheritDoc
		 */
		override public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this) + "("+ x +", "+ y +", " + radius1 + ")";
		}
		/**
		 * @inheritDoc
		 */
		override public function toString() : String
		{
			return StringUtils.stringify(this,{ radius:radius } );
		}
		
	}
}
