/**
 * @license
 */
package  abe.com.mon.geom
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Copyable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Serializable;

	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.GeometryUtils;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * The <code>Ellipsis</code> class provides a mathematical representation
	 * of an elliptical geometry.
	 * <fr>
	 * La classe <code>Ellipsis</code> fournit une représentation mathématique
	 * d'une géométrie elliptique.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Ellipsis implements Cloneable,
									 Copyable,
									 Serializable,
									 Equatable,
									 Geometry,
									 ClosedGeometry,
									 Path,
									 Surface,
									 FormMetaProvider, 
									 Randomizable
	{
		/**
		 * An integer defining the fine drawing of the geometry by default.
		 * <fr>
		 * Un entier définissant la finesse de dessin de la géométrie
		 * par défaut.
		 * </fr>
		 */
		static public const DRAWING_BIAS : uint = 30;

		[Form(type="floatSpinner",
			  label="X",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * X position of the ellipse center.
		 * <fr>Position en x du centre de l'ellipse.</fr>
		 */
		public var x : Number;
		[Form(type="floatSpinner",
			  label="Y",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="1")]
		/**
		 * Y position of the ellipse center.
		 * <fr>Position en y du centre de l'ellipse.</fr>
		 */
		public var y : Number;

		[Form(type="floatSpinner",
			  label="Radius 1",
			  range="0,Number.POSITIVE_INFINITY",
			  step="1",
			  order="2")]
		/**
		 * First radius for this ellipse.
		 * <fr>Le premier rayon de cette ellipse.</fr>
		 */
		public var radius1 : Number;

		[Form(type="floatSpinner",
			  label="Radius 2",
			  range="0,Number.POSITIVE_INFINITY",
			  step="1",
			  order="3")]
		/**
		 * Second radius for this ellipse.
		 * <fr>Le second rayon de cette ellipse.</fr>
		 */
		public var radius2 : Number;

		[Form(type="floatSpinner",
			  label="Rotation",
			  range="0,abe.com.mon.utils::MathUtils.PI2",
			  step="1",
			  order="4")]
		/**
		 * Rotation of this ellipse.
		 * <fr>L'orientation de cette ellipse.</fr>
		 */
		public var rotation : Number;

		[Form(type="boolean",
			  label="Clockwise Path",
			  order="5")]
		/**
		 * The path on the ellipse is in the direction of clockwise.
		 * 
		 * <fr>Le chemin sur cette ellipse se fait dans le sens des aiguilles
		 * d'une montre.</fr>
		 */
		public var clockWisePath : Boolean;

		[Form(type="boolean",
			  label="Clockwise Path",
			  order="5")]
		/**
		 * The offset made on the path of the ellipse.
		 * <fr>Le décalage opéré sur le chemin de l'ellipse.</fr>
		 */
		public var pathOffset : Number;
		
		/**
		 * The drawing bias of this ellipse
		 */
		public var drawBias : Number;

		/**
		 * <code>Ellipsis</code> class constructor.
		 * 
		 * <fr>Constructeur de la classe <code>Ellipsis</code>.</fr>
		 *
		 * @param	x			x position of the ellipse
		 * 						<fr>position en x de l'ellipse</fr>
		 * @param	y			y position of the ellipse
		 * 						<fr>position en y de l'ellipse</fr>
		 * @param	radius1		first radius of the ellipse
		 * 						<fr>premier rayon de l'ellipse</fr>
		 * @param	radius2		second radius of the ellipse
		 * 						<fr>second rayon de l'ellipse</fr>
		 * @param	rotation	rotation of the ellipse in radians
		 * 						<fr>rotation de l'ellipse en radians</fr>
		 * @param	bias		drawing bias of this ellipse
		 * 						<fr>la précision dans le dessin de l'ellipse</fr>
		 */
		public function Ellipsis ( x : Number = 0,
								   y : Number = 0,
								   radius1 : Number = 1,
								   radius2 : Number = 1,
								   rotation : Number = 0,
								   bias : uint = DRAWING_BIAS )
		{
			this.x = x;
			this.y = y;
			this.radius1 = radius1;
			this.radius2 = radius2;
			this.rotation = rotation;
			this.drawBias = bias;

			clockWisePath = true;
			pathOffset = 0;
			_randomSource = RandomUtils.RANDOM;
		}
		/**
		 * Reference to the internal <code>Random</code> object used in random based methods.
		 */
		protected var _randomSource : Random;
		/**
		 * Reference to the internal <code>Random</code> object used in random based methods.
		 */
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}
		/**
		 * @inheritDoc
		 */
		public function get acreage () : Number { return Math.PI * radius1 * radius2; }
		/**
		 * @inheritDoc
		 */
		public function get points () : Array
		{
			var a : Array = [];
			for( var i : int = 0; i <= drawBias;i++)
				a.push ( getPointAtAngle ( ( i / drawBias ) * MathUtils.PI2 ) );
			return a;
		}
		/**
		 * A <code>Point</code> object containing the center coordinates of this ellipsis.
		 */
		public function get center () : Point{ return pt(x,y); }
		/**
		 * @inheritDoc
		 */
		public function get length () : Number 
		{ 
			return Math.PI * ( 3 * (radius1 + radius2) - Math.sqrt( (3 * radius1 + radius2 ) * ( radius1 + radius2 * 3) ) ); 
		}
		/**
		 * @inheritDoc
		 */
		public function getPathPoint ( path : Number) : Point
		{
			return getPointAtAngle( clockWisePath ? ( pathOffset + path ) * MathUtils.PI2 :
													( MathUtils.PI2 - ( pathOffset + path ) * MathUtils.PI2 ) );
		}
		/**
		 * @inheritDoc
		 */
		public function getTangentAt ( pos : Number, posDetail : Number = 0.01 ) : Point
		{
			var tan : Point = getPathPoint( ( pos + posDetail ) % 1 ).subtract(
							  getPathPoint( ( 1 + pos - posDetail ) % 1 ) );
			tan.normalize(1);

			return tan;
		}
		/**
		 * @inheritDoc
		 */
		public function getPathOrientation (path : Number) : Number
		{
			var p1 : Point = getPathPoint( path-.01 );
			var p2 : Point = getPathPoint( path+.01 );
			var d : Point = p2.subtract(p1);

			return Math.atan2( d.y, d.x );
		}
		/**
		 * @return
		 */
		public function getPointAtAngle ( a : Number ) : Point
		{
			var p : Point = new Point ( radius1 * Math.cos( a ),
										radius2 * Math.sin( a ) );

			p = PointUtils.rotate( p, rotation );

			return new Point( x + p.x, y + p.y );
		}
		/**
		 * @inheritDoc
		 */
		public function getRandomPointInSurface () : Point
		{
			var p1 : Point = getPointAtAngle( _randomSource.random() * MathUtils.PI2 );
			var p2 : Point = pt(x,y);
			var d:Point = p1.subtract(p2);

			return p2.add( PointUtils.scaleNew( d, Math.sqrt( _randomSource.random() ) ) );
		}
		/**
		 * @inheritDoc
		 */
		public function draw ( g : Graphics, c : Color ) : void
		{
			var p : Point;
			var pend : Point;

			p = getPointAtAngle( 0 );
			pend = getPointAtAngle( MathUtils.PI2 );

			g.lineStyle( 0, c.hexa, c.alpha/255 );
			g.moveTo( p.x, p.y);

			for( var n : Number = 1; n < drawBias; n++ )
			{
				p = getPointAtAngle( n / drawBias * Math.PI * 2 );
				g.lineTo( p.x, p.y);
			}
			g.lineTo( pend.x, pend.y);
			g.lineStyle();
		}
		/**
		 * @inheritDoc
		 */
		public function fill ( g : Graphics, c : Color ) : void
		{
			var p : Point;
			var pend : Point;

			p = pend = getPointAtAngle( 0 );

			g.beginFill ( c.hexa, c.alpha/255 );
			g.moveTo( p.x, p.y);

			for( var n : Number = 1; n < DRAWING_BIAS; n++ )
			{
				p = getPointAtAngle( n / DRAWING_BIAS * Math.PI * 2 );
				g.lineTo( p.x, p.y);
			}
			g.lineTo( pend.x, pend.y);
			g.endFill();
		}
		/**
		 * @inheritDoc
		 */
		public function clone () : *
		{
			return new Ellipsis( x, y, radius1, radius2, rotation );
		}
		/**
		 * @inheritDoc
		 */
		public function copyTo (o : Object) : void
		{
			o["x"] = x;
			o["y"] = y;
			o["radius1"] = radius1;
			o["radius2"] = radius2;
			o["rotation"] = rotation;
		}
		/**
		 * @inheritDoc
		 */
		public function copyFrom (o : Object) : void
		{
			x = o["x"];
			y = o["y"];
			radius1 = o["radius1"];
			radius2 = o["radius2"];
			rotation = o["rotation"];
		}
		/**
		 * <p>
		 * Two ellipses are equal if their radii are equal.
		 * </p>
		 * <fr>
		 * <p>
		 * Deux ellipses sont égales si leur rayons sont égaux.
		 * </p>
		 * </fr>
		 * @inheritDoc
		 */
		public function equals (o : *) : Boolean
		{
			if( o is Ellipsis )
			{
				var e : Ellipsis = o as Ellipsis;
				return e.radius1 == radius1 &&
					   e.radius2 == radius2 && 
					   e.rotation == rotation &&
					   e.x == x && 
					   e.y == y;
			}
			return false;
		}
		/**
		 * Returns a new ellipse representing the point <code>normValue</code> from the interpolation
		 * between the ellipse passed as parameter and the current instance.
		 * <fr>
		 * Renvoie une nouvelle ellipse représentant le point <code>normValue</code>
		 * de l'interpolation entre l'ellipse courante et celle transmise en paramètre.
		 * </fr>
		 * @param	ellipsis	ellipse to interpolate with the current instance
		 * 						<fr>l'ellipse à interpoler avec l'ellipse courante</fr>
		 * @param 	normValue	position in the interpolation between the two ellipse
		 * 						<fr>position dans l'interpolation entre les deux ellipse</fr>
		 * @return	a new ellipse representing the point <code>normValue</code> 
		 * 			from the interpolation between the ellipse passed as parameter 
		 * 			and the current instance
		 * 			<fr>une nouvelle ellipse représentant le point <code>normValue</code>
		 * 			de l'interpolation entre l'ellipse courante et celle transmise
		 * 			en paramètre</fr>
		 */
		public function interpolate ( ellipsis: Ellipsis, normValue : Number) : Ellipsis
		{
			return new Ellipsis(
								 MathUtils.interpolate(normValue, x, ellipsis.x ),
								 MathUtils.interpolate(normValue, y, ellipsis.y ),
								 MathUtils.interpolate(normValue, radius1, ellipsis.radius1 ),
								 MathUtils.interpolate(normValue, radius2, ellipsis.radius2 ),
								 MathUtils.interpolate(normValue, rotation, ellipsis.rotation )
								);
		}
		/**
		 * @inheritDoc
		 */
		public function intersections ( geom : Geometry ) : Array
		{
			return GeometryUtils.geometriesIntersections( this, geom );
		}
		/**
		 * @inheritDoc
		 */
		public function intersectGeometry ( geom : Geometry ) : Boolean
		{
			return GeometryUtils.geometriesIntersects( this, geom );
		}
		/**
		 * @inheritDoc
		 */
		public function containsPoint (p : Point) : Boolean
		{
			var c : Point = pt(x,y);
			var d1 : Point = p.subtract(c);
			var a : Number = Math.atan2(d1.y, d1.x);
			var p2 : Point = getPointAtAngle(a);

			return Point.distance(c, p2) >= Point.distance(c, p);
		}
		/**
		 * @inheritDoc
		 */
		public function contains (x : Number, y : Number) : Boolean
		{
			return containsPoint(pt(x,y));
		}
		/**
		 * @inheritDoc
		 */
		public function containsGeometry ( geom : Geometry ) : Boolean
		{
			return GeometryUtils.surfaceContainsGeometry(this, geom);
		}
		/**
		 * @inheritDoc
		 */
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		/**
		 * @inheritDoc
		 */
		public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace( "new $0($1,$2,$3,$4,$5,$6)", 
											  getQualifiedClassName(this), 
											  x, 
											  y, 
											  radius1, 
											  radius2, 
											  rotation, 
											  drawBias );
		}
		/**
		 * Returns the representation of the object as a string.
		 * <fr>
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * </fr>
		 * @return	the representation of the object as a string
		 * 			<fr>la représentation de l'objet sous forme de chaîne</fr>
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ radius1:radius1, radius2:radius2 } );
		}
	}
}
