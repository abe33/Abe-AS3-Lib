/**
 * @license
 */
package  aesia.com.mon.geom
{
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Equatable;
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.GeometryUtils;
	import aesia.com.mon.utils.MathUtils;
	import aesia.com.mon.utils.PointUtils;
	import aesia.com.mon.utils.RandomUtils;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	/**
	 * La classe <code>Ellipsis</code> fournie une représentation mathématique
	 * d'une géométrie elliptique.
	 *
	 * @author Cédric Néhémie
	 */
	public class Ellipsis implements Cloneable,
									 Serializable,
									 Equatable,
									 Geometry,
									 Path,
									 Surface,
									 FormMetaProvider
	{
		/**
		 * Un entier définissant la finesse de dessin de la géométrie
		 * par défaut.
		 */
		static public const DRAWING_BIAS : uint = 30;

		[Form(type="floatSpinner",
			  label="X",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * Position en x du centre de l'ellipse.
		 */
		public var x : Number;
		[Form(type="floatSpinner",
			  label="Y",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="1")]
		/**
		 * Position en y du centre de l'ellipse
		 */		public var y : Number;

		[Form(type="floatSpinner",
			  label="Radius 1",
			  range="0,Number.POSITIVE_INFINITY",
			  step="1",
			  order="2")]
		/**
		 * Le premier diamètre de cette ellipse.
		 */
		public var radius1 : Number;

		[Form(type="floatSpinner",
			  label="Radius 2",
			  range="0,Number.POSITIVE_INFINITY",
			  step="1",
			  order="3")]
		/**
		 * Le second diamètre de cette ellipse.
		 */		public var radius2 : Number;

		[Form(type="floatSpinner",
			  label="Rotation",
			  range="0,aesia.com.mon.utils::MathUtils.PI2",
			  step="1",
			  order="4")]
		/**
		 * L'orientation de cette ellipse.
		 */		public var rotation : Number;

		[Form(type="boolean",
			  label="Clockwise Path",
			  order="5")]
		/**
		 * Le chemin sur cette ellipse se fait dans le sens des aiguilles
		 * d'une montre.
		 */
		public var clockWisePath : Boolean;

		[Form(type="boolean",
			  label="Clockwise Path",
			  order="5")]
		/**
		 * Le décalage opéré sur le chemin de l'ellipse.
		 */
		public var pathOffset : Number;
		public var drawBias : Number;

		/**
		 * Constructeur de la classe <code>Ellipsis</code>.
		 *
		 * @param	x		position en x de l'ellipse
		 * @param	y		position en y de l'ellipse
		 * @param	radius1	premier rayon de l'ellipse
		 * @param	radius2	second rayon de l'ellipse
		 * @param	rotation	rotation de l'ellipse en radians
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
		 * Renvoie les coordonnées de l'ellipse à la position dans le chemin.
		 *
		 * @param	pathPercent	position dans le chemin dans la plage 0-1
		 * @return	les coordonnées de l'ellipse au pourcentage du chemin
		 */
		public function getPathPoint ( path : Number) : Point
		{
			return getPointAtAngle( clockWisePath ? ( pathOffset + path ) * MathUtils.PI2 :
													( MathUtils.PI2 - ( pathOffset + path ) * MathUtils.PI2 ) );
		}
		/**
		 * @inheritDoc
		 */
		public function getPathOrientation (path : Number) : Number
		{
			var p1 : Point = getPathPoint( path-.01 );			var p2 : Point = getPathPoint( path+.01 );
			var d : Point = p2.subtract(p1);

			return Math.atan2( d.y, d.x );
		}

		/**
		 * Renvoie les coordonnées de l'ellipse à l'rotation spécifié.
		 *
		 * @param	a	rotation des coordonnées à récupérer
		 * @return	les coordonnées de l'ellipse à l'rotation spécifié
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
			var p1 : Point = getPointAtAngle( RandomUtils.random() * MathUtils.PI2 );
			var p2 : Point = pt(x,y);
			var d:Point = p1.subtract(p2);

			return p2.add( PointUtils.scaleNew( d, Math.sqrt( RandomUtils.random() ) ) );
		}
		/**
		 * Dessine les contours de l'ellipse dans l'objet <code>g</code>
		 * avec la couleur <code>c</code>.
		 *
		 * @param	g	objet <code>Graphics</code> dans lequel dessiné
		 * @param	c	couleur avec laquelle dessiner l'ellipse
		 */
		public function draw ( g : Graphics, c : Color ) : void
		{
			var p : Point;
			var pend : Point;

			p = pend = getPointAtAngle( 0 );

			g.lineStyle( 0, c.hexa, c.alpha/255 );
			g.moveTo( p.x, p.y);

			for( var n : Number = 1; n < DRAWING_BIAS; n++ )
			{
				p = getPointAtAngle( n / DRAWING_BIAS * Math.PI * 2 );
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
		 * Renvoie une copie parfaite de cet objet <code>Ellipsis</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>Ellipsis</code>
		 */
		public function clone () : *
		{
			return new Ellipsis( x, y, radius1, radius2, rotation );
		}
		/**
		 * Renvoie <code>true</code> si <code>o</code> est égal à
		 * cette instance.
		 * <p>
		 * Deux ellipses sont égales si leur rayons sont égaux.
		 * </p>
		 *
		 * @param 	o	instance à comparer avec l'instance courante
		 * @return	<code>true</code> si <code>o</code> est égal à
		 * 			cette instance
		 */
		public function equals (o : *) : Boolean
		{
			if( o is Ellipsis )
				return ( o as Ellipsis ).radius1 == radius1 &&
					   ( o as Ellipsis ).radius2 == radius2;

			return false;
		}
		/**
		 * Renvoie une nouvelle ellipse représentant le point <code>normValue</code>
		 * de l'interpolation entre l'ellipse courante et celle transmise en paramètre.
		 *
		 * @param	ellipsis	l'ellipse à interpoler avec l'ellipse courante
		 * @param 	normValue	position dans l'interpolation entre les deux ellipse
		 * @return	nouvelle ellipse représentant le point <code>normValue</code>
		 * 			de l'interpolation entre l'ellipse courante et celle transmise
		 * 			en paramètre
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
		 * Renvoie la représentation du code source permettant
		 * de recréer l'instance courante.
		 *
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 */
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		/**
		 * Renvoie la représentation du code source permettant
		 * de recréer l'instance courante à l'aide de la méthode
		 * <code>Reflection.get</code>.
		 *
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 * @see	Reflection#get()
		 */
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) +"(" + x + ", " + y + ", " + radius1 + ", " + radius2 + ", " + rotation + ")";
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString() : String
		{
			return getQualifiedClassName ( this );
		}
	}
}
