/**
 * @license
 */
package abe.com.mon.geom
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.GeometryUtils;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.mon.utils.StringUtils;
	import abe.com.mon.utils.magicToReflectionSource;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>Triangle</code> fournie une représentation
	 * d'un triangle définie par trois objets <code>Point</code>.
	 * <p>
	 * Une instance de la classe <code>Triangle</code> fournie
	 * des méthodes permettant notamment le calcul des différents
	 * angles du triangle, de son aire, des longueurs de ses côtés,
	 * etc...
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class Triangle implements Serializable,
									 Cloneable,
									 Equatable,
									 FormMetaProvider,
									 Geometry,
									 ClosedGeometry,
									 Path,
									 Surface,
									 Randomizable
	{
		[Form(type="point",
			  label="A",
			  order="0")]
		/**
		 * Le premier sommet du triangle.
		 */
		public var a : Point;
		[Form(type="point",
			  label="B",
			  order="1")]
		/**
		 * Le second sommet du triangle.
		 */		public var b : Point;
		[Form(type="point",
			  label="C",
			  order="2")]
		/**
		 * Le dernier sommet du triangle.
		 */		public var c : Point;
		[Form(type="boolean",
			  label="Path based on length",
			  order="3")]
		/**
		 * Une valeur booléenne indiquant si les calculs d'une position
		 * dans le chemin de ce <code>Triangle</code> se font sur la
		 * base de la longueur du périmètre ou sur la base des arrêtes.
		 * <p>
		 * Dans le cas où les calculs sont basés sur les arrêtes, le
		 * chemin se découpe de la manière suivante :
		 * </p>
		 * <ul>
		 * <li>De <code>0</code> à <code>1/3</code> la position renvoyée
		 * se situe sur l'arrête <code>ab</code> du triangle.</li>
		 * <li>De <code>1/3</code> à <code>2/3</code> la position renvoyée
		 * se situe sur l'arrête <code>bc</code> du triangle.</li>
		 * <li>De <code>2/3</code> à <code>1</code> la position renvoyée
		 * se situe sur l'arrête <code>ca</code> du triangle.</li>
		 * </ul>
		 *
		 * @default true
		 */
		public var pathBasedOnLength : Boolean;

		/**
		 * Constructeur de la classe <code>Triangle</code>.
		 *
		 * @param	a					premier sommet du triangle
		 * @param	b					second sommet du triangle
		 * @param	c					dernier sommet du triangle
		 * @param	pathBasedOnLength	le calcul du chemin est-il basé
		 * 								sur la longueur du périmètre du
		 * 								triangle ?
		 */
		public function Triangle ( a : Point,
								   b : Point,
								   c : Point,
								   pathBasedOnLength : Boolean = true )
		{
			this.a = a;			this.b = b;			this.c = c;
			this.pathBasedOnLength = pathBasedOnLength;
			_randomSource = RandomUtils.RANDOM;
		}

		protected var _randomSource : Random;
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}
		/**
		 * Un objet <code>Point</code> représentant le vecteur
		 * reliant les sommets <code>a</code> et <code>b</code>.
		 */
		public function get ab () : Point { return b.subtract( a ); }
		/**
		 * Un objet <code>Point</code> représentant le vecteur
		 * reliant les sommets <code>b</code> et <code>c</code>.
		 */		public function get bc () : Point { return c.subtract( b ); }
		/**
		 * Un objet <code>Point</code> représentant le vecteur
		 * reliant les sommets <code>c</code> et <code>a</code>.
		 */		public function get ca () : Point { return a.subtract( c ); }
		/**
		 * La valeur de l'angle formé par les deux vecteurs partageant
		 * le sommet <code>b</code> en radians.
		 */
		public function get abc () : Number { return PointUtils.getAngle( ab, bc ); }
		/**
		 * La valeur de l'angle formé par les deux vecteurs partageant
		 * le sommet <code>a</code> en radians.
		 */
		public function get bac () : Number { return PointUtils.getAngle( ab, ca ); }
		/**
		 * La valeur de l'angle formé par les deux vecteurs partageant
		 * le sommet <code>c</code> en radians.
		 */
		public function get acb () : Number { return PointUtils.getAngle( ca, bc ); }
		/**
		 * Un objet <code>Point</code> représentant le centre
		 * de ce <code>Triangle</code>.
		 */
		public function get center () : Point { return pt( ( a.x + b.x + c.x ) / 3,
														   ( a.y + b.y + c.y ) / 3 ); }
		/**
		 * Une valeur booléenne indiquant si ce triangle est un triangle équilatéral.
		 */
		public function get isEquilateral () : Boolean { return ab.length == ca.length &&
																ab.length == bc.length; }
		/**
		 * Une valeur booléenne indiquant si ce triangle est un triangle isocèle.
		 */
		public function get isIsosceles () : Boolean { return  ab.length == bc.length ||
															   ab.length == ca.length ||
															   ca.length == bc.length; }
		/**
		 * Une valeur booléenne indiquant si ce triangle est un triangle rectangle.
		 */		public function get isRectangle () : Boolean { return Math.abs( MathUtils.rad2deg( abc ) ) == 90 ||
															  Math.abs( MathUtils.rad2deg( bac ) ) == 90 ||
															  Math.abs( MathUtils.rad2deg( acb ) ) == 90; }
		/**
		 * @inheritDoc
		 */
		public function get acreage () : Number
		{
			var abl : Number = ab.length;
			var bcl : Number = bc.length;

			return ( abl * bcl * Math.abs(Math.sin(abc)) ) / 2;
		}
		/**
		 * La longueur du périmètre de cet objet <code>Triangle</code>.
		 */
		public function get length () : Number
		{
			return ab.length + ca.length + bc.length;
		}
		/**
		 * @inheritDoc
		 */
		public function get points () : Array	{ return [ a, b, c, a ]; }
		/**
		 * @inheritDoc
		 */
		public function getPathPoint (path : Number) : Point
		{
			var l1 : Number;
			var l2 : Number;
			var v : Point;

			if( pathBasedOnLength )
			{
				var l : Number = length;
				l1 = ab.length / l;
				l2 = l1 + bc.length / l;
			}
			else
			{
				l1 = 1/3;
				l2 = 2/3;
			}

			if( path < l1 )
			{
				v = PointUtils.scaleNew( ab, MathUtils.map(path, 0, l1, 0, 1 ) );
				return pt( a.x + v.x, a.y + v.y );
			}
			else if( path < l2 )
			{
				v = PointUtils.scaleNew( bc, MathUtils.map(path, l1, l2, 0, 1 ) );
				return pt( b.x + v.x, b.y + v.y );
			}
			else
			{
				v = PointUtils.scaleNew( ca, MathUtils.map(path, l2, 1, 0, 1 ) );
				return pt( c.x + v.x, c.y + v.y );
			}
		}
		/**
		 * @inheritDoc
		 */
		public function getPathOrientation (path : Number) : Number
		{
			var l1 : Number;
			var l2 : Number;
			var v : Point;

			if( pathBasedOnLength )
			{
				var l : Number = length;
				l1 = ab.length / l;
				l2 = l1 + bc.length / l;
			}
			else
			{
				l1 = 1/3;
				l2 = 2/3;
			}

			if( path < l1 )
				v = ab;
			else if( path < l2 )
				v = bc;
			else
				v = ca;

			return Math.atan2( v.y, v.x );
		}
		/**
		 * @inheritDoc
		 */
		public function getRandomPointInSurface () : Point
		{
			var a1 : Number = _randomSource.random();
			var a2 : Number = _randomSource.random();
			var p : Point = a.add( PointUtils.scaleNew( ab, a1 ).add( PointUtils.scaleNew( ca, a2 * -1 ) ) );
			if( containsPoint( p ) )
				return p;
			else
			{
				var bcCenter : Point = b.add( PointUtils.scaleNew(bc, .5 ));
				var d : Point = bcCenter.subtract( p );
				p = p.add( PointUtils.scaleNew( d, 2 ) );
				return p;
			}
		}
		public function getPointAtAngle (a : Number) : Point
		{
			return null;
		}
		/**
		 * Effectue une rotation de cet objet <code>Triangle</code> autour
		 * de son centre d'un angle de <code>r</code> radians.
		 *
		 * @param	r	angle de la rotation à effectuer
		 */
		public function rotateAroundCenter ( r : Number) : void
		{
			var d : Point = center;

			a = PointUtils.rotateAround( a, d, r);
			b = PointUtils.rotateAround( b, d, r);
			c = PointUtils.rotateAround( c, d, r);
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
		public function intersections ( geom : Geometry ) : Array
		{
			return GeometryUtils.geometriesIntersections( this, geom );
		}
		/**
		 * Renvoie <code>true</code> si le point <code>p</code>
		 * est situé à l'intérieur de cet objet <code>Triangle</code>.
		 *
		 * @param	p	point dont on souhait savoir si il se situe
		 * 				à l'intérieur du triangle
		 * @return	<code>true</code> si le point est situé à l'intérieur
		 * 			de ce triangle
		 */
		public function containsPoint( p : Point ) : Boolean
		{
			// Compute vectors
			var v0 : Point = c.subtract(a);
			var v1 : Point = b.subtract(a);
			var v2 : Point = p.subtract(a);

			// Compute dot products
			var dot00 : Number = PointUtils.dot(v0, v0);
			var dot01 : Number = PointUtils.dot(v0, v1);
			var dot02 : Number = PointUtils.dot(v0, v2);
			var dot11 : Number = PointUtils.dot(v1, v1);
			var dot12 : Number = PointUtils.dot(v1, v2);

			// Compute barycentric coordinates
			var invDenom : Number = 1 / (dot00 * dot11 - dot01 * dot01);
			var u : Number = (dot11 * dot02 - dot01 * dot12) * invDenom;
			var v : Number = (dot00 * dot12 - dot01 * dot02) * invDenom;

			// Check if point is in triangle
			return (u > 0) && (v > 0) && (u + v < 1);
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
		public function draw (g : Graphics, color : Color) : void
		{
			g.lineStyle( 0, color.hexa, color.alpha/255 );
			g.moveTo(a.x, a.y);			g.lineTo(b.x, b.y);			g.lineTo(c.x, c.y);			g.lineTo(a.x, a.y);
			g.lineStyle();
		}
		/**
		 * @inheritDoc
		 */
		public function fill ( g : Graphics, color : Color ) : void
		{
			g.beginFill( color.hexa, color.alpha/255 );
			g.moveTo(a.x, a.y);
			g.lineTo(b.x, b.y);
			g.lineTo(c.x, c.y);
			g.lineTo(a.x, a.y);
			g.endFill();
		}
		/**
		 * Renvoie une copie parfaite de cet objet <code>Triangle</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>Triangle</code>
		 */
		public function clone () : *
		{
			return new Triangle( a.clone(),
								 b.clone(),
								 c.clone(),
								 pathBasedOnLength );
		}
		/**
		 * Renvoie <code>true</code> si <code>o</code> est égal à
		 * cette instance.
		 * <p>
		 * Deux triangles sont égaux si tout leur sommets sont égaux.
		 * </p>
		 *
		 * @param 	o	instance à comparer avec l'instance courante
		 * @return	<code>true</code> si <code>o</code> est égal à
		 * 			cette instance
		 */
		public function equals (o : *) : Boolean
		{
			if ( o && o is Triangle )
			{
				return 	a.equals( o.a ) &&
						b.equals( o.b ) &&
						c.equals( o.c ) ;
			}
			else return false;
		}
		/**
		 * @inheritDoc
		 */
		public function toSource () : String
		{
			return toReflectionSource ().replace("::", "." );
		}
		/**
		 * @inheritDoc
		 */
		public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace("new $0($1,$2,$3,$4)",
						getQualifiedClassName( this ),
						magicToReflectionSource( a ),						magicToReflectionSource( b ),						magicToReflectionSource( c ),
						pathBasedOnLength );
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ a:a, b:b, c:c } );
		}
	}
}
