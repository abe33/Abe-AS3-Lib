/**
 * @license
 */
package abe.com.mon.geom
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Cloneable;
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
	/**
	 * The <code>Triangle</code> class provides a representation 
	 * of a triangle defined by three objects <code>Point</code>. 
	 * <p>
	 * An instance of the class <code>Triangle</code> provides methods
	 * such as calculating the various angles of the triangle, its area,
	 * lengths of its sides, etc. ... 
	 * </p>
	 * <fr>
	 * La classe <code>Triangle</code> fournie une représentation
	 * d'un triangle définie par trois objets <code>Point</code>.
	 * <p>
	 * Une instance de la classe <code>Triangle</code> fournie
	 * des méthodes permettant notamment le calcul des différents
	 * angles du triangle, de son aire, des longueurs de ses côtés,
	 * etc...
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="a,b,c,pathBasedOnLength")]
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
		/**
		 * @copy abe.com.mon.core.Randomizable#randomSource
		 */
		protected var _randomSource : Random;
		
		[Form(type="point",
			  label="A",
			  order="0")]
		/**
		 * First vertex of this triangle.
		 * <fr>
		 * Le premier sommet du triangle.
		 * </fr>
		 */
		public var a : Point;
		[Form(type="point",
			  label="B",
			  order="1")]
		/**
		 * Second vertex of this triangle.
		 * <fr>
		 * Le second sommet du triangle.
		 * </fr>
		 */
		public var b : Point;
		[Form(type="point",
			  label="C",
			  order="2")]
		/**
		 * Third vertex of this triangle.
		 * <fr>
		 * Le dernier sommet du triangle.
		 * </fr>
		 */
		public var c : Point;
		[Form(type="boolean",
			  label="Path based on length",
			  order="3")]
		/**
		 * A boolean value indicating whether the calculations 
		 * of a position in the path of this <code>Triangle</code>
		 * are based on the length of the perimeter or on the basis
		 * of the edges.
		 * <p>
		 * If the calculations are based on the edges, the path
		 * is divided as follows:
		 * </p>
		 * <ul>
		 * <li>From <code>0</code> to <code>1/3</code> the returned
		 * position is on the edge <code>ab</code> of the triangle.</li>
		 * <li>From <code>1/3</code> to <code>2/3</code> the returned
		 * position is on the edge <code>bc</code> of the triangle.</li>
		 * <li>From <code>2/3</code> to <code>1</code> the returned 
		 * position is on the edge <code>ca</code> of the triangle.</li>
		 * </ul>
		 * <fr>
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
		 * </fr>
		 * @default true
		 */
		public var pathBasedOnLength : Boolean;
        
        protected var _rotation : Number;
		/**
		 * <code>Triangle</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>Triangle</code>.
		 * </fr>
		 * @param	a					first vertex of the triangle
		 * 								<fr>premier sommet du triangle</fr>
		 * @param	b					second vertex of the triangle
		 * 								<fr>second sommet du triangle</fr>
		 * @param	c					third vertex of the triangle
		 * 								<fr>dernier sommet du triangle</fr>
		 * @param	pathBasedOnLength	path computation is it based on the
		 * 								length of the perimeter of the triangle?
		 * 								<fr>le calcul du chemin est-il basé
		 * 								sur la longueur du périmètre du
		 * 								triangle ?</fr>
		 */
		public function Triangle ( a : Point,
								   b : Point,
								   c : Point,
								   pathBasedOnLength : Boolean = true )
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this._rotation = 0;
			this.pathBasedOnLength = pathBasedOnLength;
			_randomSource = RandomUtils;
        }
        /**
		 * A <code>Point</code> representing the vector connecting
		 * the vertices <code>a</code> and <code>b</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant le vecteur
		 * reliant les sommets <code>a</code> et <code>b</code>.
		 * </fr>
		 */
		public function get ab () : Point { return b.subtract( a ); }
		/**
		 * A <code>Point</code> representing the vector connecting
		 * the vertices <code>b</code> and <code>c</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant le vecteur
		 * reliant les sommets <code>b</code> et <code>c</code>.
		 * </fr>
		 */
		public function get bc () : Point { return c.subtract( b ); }
		/**
		 * A <code>Point</code> representing the vector connecting
		 * the vertices <code>c</code> and <code>a</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant le vecteur
		 * reliant les sommets <code>c</code> et <code>a</code>.
		 * </fr>
		 */
		public function get ca () : Point { return a.subtract( c ); }
		/**
		 * The value of the angle formed by the two vectors
		 * sharing the vertex <code>b</code> in radians.
		 * <fr>
		 * La valeur de l'angle formé par les deux vecteurs partageant
		 * le sommet <code>b</code> en radians.
		 * </fr>
		 */
		public function get abc () : Number { return PointUtils.getAngle( ab, bc ); }
		/**
		 * The value of the angle formed by the two vectors
		 * sharing the vertex <code>a</code> in radians.
		 * <fr>
		 * La valeur de l'angle formé par les deux vecteurs partageant
		 * le sommet <code>a</code> en radians.
		 * </fr>
		 */
		public function get bac () : Number { return PointUtils.getAngle( ab, ca ); }
		/**
		 * The value of the angle formed by the two vectors
		 * sharing the vertex <code>c</code> in radians.
		 * <fr>
		 * La valeur de l'angle formé par les deux vecteurs partageant
		 * le sommet <code>c</code> en radians.
		 * </fr>
		 */
		public function get acb () : Number { return PointUtils.getAngle( ca, bc ); }
		/**
		 * A <code>Point</code> representing the center of this triangle.
		 * <fr>
		 * Un objet <code>Point</code> représentant le centre
		 * de ce <code>Triangle</code>.
		 * </fr>
		 */
		public function get center () : Point { return pt( ( a.x + b.x + c.x ) / 3,
														   ( a.y + b.y + c.y ) / 3 ); }
		/**
		 * A boolean value indicating whether this triangle is an equilateral triangle.
		 * <fr>Une valeur booléenne indiquant si ce triangle est un triangle équilatéral.</fr>
		 */
		public function get isEquilateral () : Boolean { return ab.length == ca.length &&
																ab.length == bc.length; }
		/**
		 * A boolean value indicating whether this triangle is an isosceles triangle.
		 * <fr>Une valeur booléenne indiquant si ce triangle est un triangle isocèle.</fr>
		 */
		public function get isIsosceles () : Boolean { return  ab.length == bc.length ||
															   ab.length == ca.length ||
															   ca.length == bc.length; }
		/**
		 * A boolean value indicating whether this triangle is a right triangle.
		 * <fr>Une valeur booléenne indiquant si ce triangle est un triangle rectangle.</fr>
		 */
		public function get isRectangle () : Boolean { return Math.abs( MathUtils.rad2deg( abc ) ) == 90 ||
															  Math.abs( MathUtils.rad2deg( bac ) ) == 90 ||
															  Math.abs( MathUtils.rad2deg( acb ) ) == 90; }
		public function get rotation () : Number { return _rotation; }
		public function set rotation ( a : Number ) : void 
		{ 
		    var d : Number = a - _rotation;
		    rotateAroundCenter( d );
		    _rotation = a; 
		}
		/**
		 * @inheritDoc
		 */
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}
		
		public function get x () : Number { return center.x; }
		public function set x ( nx : Number ) : void
		{ 
	        var d : Number = nx - x;
	        a.x += d;
	        b.x += d;
	        c.x += d;
	    }
		public function get y () : Number { return center.y; }
		public function set y ( ny : Number ) : void
		{ 
	        var d : Number = ny - y;
	        a.y += d;
	        b.y += d;
	        c.y += d;
	    }
	    
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
		 * The length of the perimeter of this triangle.
		 * <fr>La longueur du périmètre de cet objet <code>Triangle</code>.</fr>
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
		/**
		 * @inheritDoc
		 */
		public function getPointAtAngle (a : Number) : Point
		{
			return null;
		}
		/**
		 * Rotates this object <code>Triangle</code> around its center
		 * by an angle of <code>r</code> radians.
		 * <fr>
		 * Effectue une rotation de cet objet <code>Triangle</code> autour
		 * de son centre d'un angle de <code>r</code> radians.
		 * </fr>
		 * @param	r	angle of rotation to perform
		 * 				<fr>angle de la rotation à effectuer</fr>
		 */
		public function rotateAroundCenter ( r : Number ) : void
		{
			var d : Point = center;

			a = PointUtils.rotateAround( a, d, r );
			b = PointUtils.rotateAround( b, d, r );
			c = PointUtils.rotateAround( c, d, r );
			
			_rotation += r;
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
		 * @inheritDoc
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
		public function draw (g : Graphics, color : Color ) : void
		{
			g.lineStyle( 0, color.hexa, color.alpha/255 );
			g.moveTo(a.x, a.y);
			g.lineTo(b.x, b.y);
			g.lineTo(c.x, c.y);
			g.lineTo(a.x, a.y);
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
		 * @inheritDoc
		 */
		public function clone () : *
		{
			return new Triangle( a.clone(),
								 b.clone(),
								 c.clone(),
								 pathBasedOnLength );
		}
		/**
		 * <p>
		 * Two triangles are equal if all their vertices are equal.
		 * <fr>Deux triangles sont égaux si tout leur sommets sont égaux.</fr>
		 * </p>
		 * @inheritDoc
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
		 * @copy Dimension#toString()
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ a:a, b:b, c:c } );
		}
	}
}
