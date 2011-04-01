package abe.com.mon.geom
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.logs.Log;
	import abe.com.mon.colors.Color;
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
	 * The Class <code>Polygon</code> is used to represent planar, closed geometries,
	 * consisting of an indefinite number of vertices. 
	 * <p>
	 * A valid <code>Polygon</code> object contains at least three vertices.
	 * </p>
	 * <fr>
	 * La classe <code>Polygon</code> permet de représenter des géométries planes,
	 * fermées, constituées d'un nombre indéfini de sommets.
	 * <p>
	 * Un objet <code>Polygon</code> valide est constitué par au minimum trois sommets.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Polygon implements Serializable, Cloneable, Equatable, Geometry, ClosedGeometry, Path, Surface, FormMetaProvider, Randomizable
	{
		/**
		 * A global instance of the class <code>Triangulate</code>
		 * used to perform the triangulation of <code>Polygon</code> objects.
		 * <fr>
		 * Une instance globale de la classe <code>Triangulate</code> utilisée
		 * pour réaliser la triangulation des objets <code>Polygon</code>.
		 * </fr>
		 * @default	new Triangulate()
		 */
		static protected var triangulator : Triangulate = new Triangulate();
		/**
		 * An array containing all the vertices of the polygon.
		 * <fr>
		 * Un tableau contenant l'ensemble des sommets de ce polygone.
		 * </fr>
		 */
		protected var _vertices : Array;
		/**
		 * An array containing all objects <code>Triangle</code> 
		 * resulting from the triangulation of this polygon.
		 * <fr>
		 * Un tableau contenant l'ensemble des objets <code>Triangle</code>
		 * résultants de la triangulation de ce polygone.
		 * </fr>
		 */
		protected var _triangles : Array;
		/**
		 * An array containing all the lengths of segments added
		 * together to perform the operations of path computation
		 * based on the length of the edges of polygons.
		 * <p>
		 * For a polygon <code>ABC</code>, the array contains 
		 * the following data : 
		 * </p>
		 * <fr>
		 * Un tableau contenant l'ensemble des longueurs de segments additionnés
		 * afin de réaliser les opérations de calculs de chemins basé sur la
		 * longueur des arrêtes de ce polygones.
		 * <p>
		 * Pour un polygone <code>ABC</code>, le tableau contient les
		 * données suivantes :
		 * </p>
		 * </fr>
		 * <listing>
		 * [
		 * 	AB.length,
		 * 	AB.length + BC.length,
		 * 	AB.length + BC.length + CA.length
		 * ]</listing>
		 */		protected var _pathSteps : Array;
		/**
		 * An array containing the accumulated acreages of different triangles
		 * constituting the polygon. 
		 * <p>
		 * For a polygon <code>ABCD</code>, the array contains the following data:
		 * </p>
		 * <fr>
		 * Un tableau contenant les aires accumulées des
		 * différents triangles constituant ce polygone.
		 * <p>
		 * Pour un polygone <code>ABCD</code>, le tableau contient les
		 * données suivantes :
		 * </p>
		 * </fr>
		 * <listing>
		 * [
		 * 	ABC.acreage,
		 * 	ABC.acreage + BCD.acreage
		 * ]</listing>
		 */
		protected var _acreageSteps : Array;
		/**
		 * A number containing the precomputed value
		 * of the acreage of this polygon in <code>px²</code>.
		 * <fr>
		 * Un nombre contenant la valeur précalculée
		 * de l'aire de ce polygone en <code>px²</code>.
		 * </fr>
		 */
		protected var _acreage : Number;
		/**
		 * A number containing the precomputed value of the perimeter
		 * of the polygon.
		 * <fr>
		 * Un nombre contenant la valeur précalculée du périmètre
		 * de ce polygone.
		 * </fr>
		 */
		protected var _length : Number;
		/**
		 * @copy abe.com.mon.core.Randomizable#randomSource
		 */
		protected var _randomSource : Random;
		/**
		 * A boolean value indicating whether the calculations 
		 * of a position in the path of this <code>Polygon</code>
		 * are based on the length of the perimeter or on the basis
		 * of the number of edges. 
		 * <p>
		 * In the case a path based on the lengths of edges, 
		 * the data contained in the array <code>_pathSteps</code> 
		 * are used.
		 * </p>
		 * <fr>
		 * Une valeur booléenne indiquant si les calculs d'une position
		 * dans le chemin de ce <code>Polygon</code> se font sur la
		 * base de la longueur du périmètre ou sur la base du nombre
		 * d'arrêtes.
		 * <p>
		 * Dans le cas d'un chemin basé sur les longeurs des arrêtes,
		 * les données contenues dans le tableau <code>_pathSteps</code>
		 * sont utilisées.
		 * </p>
		 * </fr>
		 * @default	true
		 */
		public var pathBasedOnLength : Boolean;
		/**
		 * A boolean value indicating whether the triangles
		 * from the triangulation of this polygon must be
		 * drawn during the <code>draw</code> process.
		 * <fr>
		 * Une valeur booléenne indiquant si les triangles issus
		 * de la triangulation de ce polygone doivent être dessinés
		 * dans le cadre de la méthode <code>draw</code>.
		 * </fr>
		 * @default	false
		 */
		public var drawTriangles : Boolean;

		/**
		 * <code>Polygon</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>Polygon</code>.
		 * </fr>
		 * @param	vertices			an array of objects <code>Point</code> representing
		 * 								the vertices of the polygon
		 * 								<fr>un tableau d'objets <code>Point</code>
		 * 								représentant les sommets de ce polygone</fr>
		 * @param	pathBasedOnLength	path computation is it based on the length of 
		 * 								the perimeter of the triangle?
		 * 								<fr>le calcul du chemin est-il basé
		 * 								sur la longueur du périmètre du
		 * 								triangle ?</fr>
		 * @throws Error A polygon must have at least three vertices to be valid.
		 * 				 <fr>Un polygone doit posséder au minimum trois sommets pour être valide.</fr>
		 */
		public function Polygon ( vertices : Array,
								  pathBasedOnLength : Boolean = true )
		{
			this.vertices = vertices;
			this.pathBasedOnLength = pathBasedOnLength;
			_randomSource = RandomUtils.RANDOM;
		}
		
		/**
		 * An array containing all the vertices of the polygon.
		 * <p>
		 * The table must have a mininum three vertices to be valid, 
		 * otherwise an exception is thrown.
		 * </p>
		 * <fr>
		 * Un tableau contenant l'ensemble des sommets de ce polygone.
		 * <p>
		 * Le tableau doit avoir au mininum trois sommets pour être valide,
		 * sinon un exception est levée.
		 * </p>
		 * </fr>
		 * @throws Error A Polygon must have at least three vertices
		 * 				 to be a valid polygon.
		 * 				 <fr>Un polygone doit posséder au minimum
		 * 				 trois sommets pour être valide.</fr>
		 */
		public function get vertices () : Array { return _vertices; }
		public function set vertices (vertices : Array) : void
		{
			if( vertices.length < 3 )
				throw new Error( "A Polygon must have at least three vertices to be a valid polygon." );

			_vertices = vertices;
			updatePolygonData();
		}
		/**
		 * A copy of the array containing objects <code>Triangle</code> 
		 * resulting from the triangulation of this polygon.
		 * <fr>
		 * Une copie du tableau contenant les objets <code>Triangle</code> résultant
		 * de la triangulation de ce polygone.
		 * </fr>
		 */
		public function get triangles () : Array { return _triangles.concat(); }
		/**
		 * Number representing the length of the perimeter of the polygon.
		 * <fr>
		 * Un nombre représentant la longueur du périmètre de ce polygone.
		 * </fr>
		 */
		public function get length () : Number { return _length; }
		/**
		 * @inheritDoc
		 */
		public function get acreage () : Number { return _acreage; }
		/**
		 * @inheritDoc
		 */
		public function get points () : Array { return _vertices.concat ( _vertices[0] ); }
		/**
		 * @inheritDoc
		 */
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void	{ _randomSource = randomSource; }
		/**
		 * @inheritDoc
		 */
		public function getPathPoint (path : Number) : Point
		{
			var startIndex : uint;			var endIndex : uint;
			var pathStep1 : Number;			var pathStep2 : Number;

			if( pathBasedOnLength )
			{
				var le : Number = _length;
				var l : uint = _pathSteps.length;
				var step : Number;
				for( var i : int = 0; i < l; i++ )
				{
					step = _pathSteps[i] / le;					if( path <= step )
					{
						if( i == 0 )
							pathStep1 = 0;
						else
							pathStep1 = _pathSteps[i-1] / le;
						startIndex = i;
						endIndex = i+1;
						pathStep2 = _pathSteps[i] / le;
						break;
					}
				}
			}
			else
			{
				if( path == 1 )
				{
					startIndex = _vertices.length-1;
					endIndex = 0;
					pathStep1 = (_vertices.length-1) / _vertices.length;
					pathStep2 = 1;
				}
				else
				{
					startIndex = Math.floor( path * _vertices.length );
					endIndex = startIndex + 1;
					pathStep1 = startIndex / _vertices.length;					pathStep2 = endIndex / _vertices.length;
				}
			}
			if( endIndex >= _vertices.length )
				endIndex = 0;

			var pt1 : Point = _vertices[startIndex];
			var pt2 : Point = _vertices[endIndex];
			var d : Point = PointUtils.scaleNew( pt2.subtract(pt1), MathUtils.map( path, pathStep1, pathStep2, 0, 1) );
			return pt( pt1.x + d.x, pt1.y + d.y );
		}
		/**
		 * @inheritDoc
		 */
		public function getPathOrientation (path : Number) : Number
		{
			var startIndex : uint;
			var endIndex : uint;
			var pathStep1 : Number;
			var pathStep2 : Number;

			if( pathBasedOnLength )
			{
				var le : Number = _length;
				var l : uint = _pathSteps.length;
				var step : Number;
				for( var i : int = 0; i < l; i++ )
				{
					step = _pathSteps[i] / le;
					if( path < step )
					{
						if( i == 0 )
							pathStep1 = 0;
						else
							pathStep1 = _pathSteps[i-1] / le;

						startIndex = i;
						endIndex = i+1;

						pathStep2 = _pathSteps[i] / le;
						break;
					}
				}
			}
			else
			{
				if( path == 1 )
				{
					startIndex = _vertices.length-1;
					endIndex = 0;
					pathStep1 = (_vertices.length-1) / _vertices.length;
					pathStep2 = 1;
				}
				else
				{
					startIndex = Math.floor( path * _vertices.length );
					endIndex = startIndex + 1;
					pathStep1 = startIndex / _vertices.length;
					pathStep2 = endIndex / _vertices.length;
				}
			}
			if( endIndex >= _vertices.length )
				endIndex = 0;

			var pt1 : Point = _vertices[startIndex];
			var pt2 : Point = _vertices[endIndex];

			var d : Point = pt2.subtract(pt1);

			return Math.atan2(d.y, d.x);
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
			if( _triangles )
			{
				return ( _randomSource.inArrayWithRatios ( _triangles, _acreageSteps, true, _acreage ) as Triangle ).getRandomPointInSurface ();
			}
			else
				return null;
		}
		/**
		 * @inheritDoc
		 */
		public function getPointAtAngle (a : Number) : Point
		{
			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function clone () : *
		{
			return new Polygon( vertices.concat(), pathBasedOnLength);
		}
		/**
		 * <p>Two polygons are equal if all their vertices are equal.</p>
		 * <fr>
		 * <p>Deux polygones sont égaux si tout leur sommets sont égaux.</p>
		 * </fr>
		 * @inheritDoc
		 */
		public function equals (o : *) : Boolean
		{
			if( o is Polygon )
			{
				return _vertices.every(
					function( pt : Point, i : Number, ... args ) : Boolean
					{
						return o.vertices[i].equals(pt);
					} );
			}
			return false;
		}
		/**
		 * @inheritDoc
		 */
		public function draw (g : Graphics, c : Color) : void
		{
			var s : Point = _vertices[0];
			var l : uint = _vertices.length;

			if( drawTriangles && _triangles )
				_triangles.forEach( function( t : Triangle, ... args) : void { t.draw(g, c); } );

			g.lineStyle(0, c.hexa, c.alpha/255 );
			g.moveTo( s.x, s.y );

			for(var i:int=1;i<l;i++ )
			{
				var p : Point = _vertices[i];
				g.lineTo( p.x, p.y );

			}			g.lineTo( s.x, s.y );
			g.lineStyle();
		}
		/**
		 * @inheritDoc
		 */
		public function fill ( g : Graphics, c : Color ) : void
		{
			var s : Point = _vertices[0];
			var l : uint = _vertices.length;

			if( drawTriangles && _triangles )
				_triangles.forEach( function( t : Triangle, ... args) : void { t.draw(g, c); } );

			g.beginFill( c.hexa, c.alpha/255 );
			g.moveTo( s.x, s.y );

			for(var i:int=1;i<l;i++ )
			{
				var p : Point = _vertices[i];
				g.lineTo( p.x, p.y );

			}
			g.lineTo( s.x, s.y );
			g.endFill();
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
		public function containsPoint ( p : Point ) : Boolean
		{
			var counter : int = 0;
			var i : int;
			var xinters : Number;
			var p1 : Point;
			var p2 : Point;
			var n : int = _vertices.length;

			p1 = _vertices[0];
			for (i = 1; i <= n; i++)
			{
				p2 = _vertices[i % n];
				if (p.y > Math.min( p1.y, p2.y ))
				{
					if (p.y <= Math.max( p1.y, p2.y ))
					{
						if (p.x <= Math.max( p1.x, p2.x ))
						{
							if (p1.y != p2.y)
							{
								xinters = (p.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
								if (p1.x == p2.x || p.x <= xinters)
							counter++;
							}
						}
					}
				}
				p1 = p2;
			}
			if (counter % 2 == 0)
			{
				return(false);
			}
			else
			{
				return(true);
			}
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
		 * Updates to this data precomputed polygon.
		 * <p>
		 * The update perform the following operations:
		 * </p>
		 * <ul>
		 * <li>Triangulation of this polygon.</li>
		 * <li>Calculating the area of this polygon.</li>
		 * <li>Calculations of the length of each edge
		 * that form the array <code>_pathSteps</code>.</li>
		 * <li>Calculating the length of the perimeter of the polygon.</li>
		 * </ul>
		 * <p>
		 * This method is automatically called when the <code>vertex</code>
		 * property is modified. However, if a change is made on this array,
		 * or on the coordinates it contains, the call to <code>updatePolygonData</code>
		 * must be done manually. That's why this method is public.
		 * </p>
		 * <fr>
		 * Met à jour les données précalculées pour ce polygone.
		 * <p>
		 * Lors de la mise à jour sont effectuées les opérations
		 * suivantes :
		 * </p>
		 * <ul>
		 * <li>Triangulation de ce polygone.</li>		 * <li>Calcul de l'aire de ce polygone.</li>		 * <li>Calculs des longueurs de chaque arrête afin de constituer le tableau
		 * <code>_pathSteps</code>.</li>		 * <li>Calcul de la longueur du périmètre de ce polygone.</li>
		 * </ul>
		 * <p>
		 * Cette méthode est automatiquement appelée lorsque la propriété
		 * <code>vertices</code> est appelée en écriture. Cepedant, si une
		 * modification est faite sur ce tableau, ou sur l'une des coordonnées
		 * qu'il contient, l'appel à la méthode <code>updatePolygonData</code>
		 * devra être fait manuellement. C'est la raison pour laquelle cette
		 * méthode est publique.
		 * </p>
		 * </fr>
		 */
		public function updatePolygonData () : void
		{
			updateTriangles ();
			updateAcreage ();
			updatePathSteps ();
			updateLength ();
		}
		/**
		 * Calculating the length of the perimeter of the polygon.
		 * <fr>
		 * Calcul la longueur du périmètre de ce polygone.
		 * </fr>
		 */
		protected function updateLength () : void
		{
			var n : Number = 0;
			var l : uint = _vertices.length;
			for( var i : int = 1; i < l; i++ )
			{
				n += Point.distance( _vertices[i-1], _vertices[i] );
				_pathSteps.push( n );
			}
			n += Point.distance( _vertices[l-1], _vertices[0] );

			_length = n;
		}
		/**
		 * Calculations of the lengths of each edge to form
		 * the array <code>_pathSteps</code>.
		 * <fr>
		 * Calculs des longueurs de chaque arrête afin de constituer le tableau
		 * <code>_pathSteps</code>.
		 * </fr>
		 */
		protected function updatePathSteps () : void
		{
			_pathSteps = [];
			var l : uint = _vertices.length;
			var n : Number = 0;
			for( var i : int = 1; i < l; i++ )
			{
				n += Point.distance( _vertices[i-1], _vertices[i] );
				_pathSteps.push( n );
			}
			n += Point.distance( _vertices[_vertices.length-1], _vertices[0] );
			_pathSteps.push( n );
		}
		/**
		 * Realizes the triangulation of this polygon and stores
		 * the result in the <code>_triangles</code> property.
		 * <fr>
		 * Réalise la triangulation de ce polygone et stocke le résultat
		 * dans la propriété <code>_triangles</code>.
		 * </fr>
		 */
		protected function updateTriangles () : void
		{
			_triangles = triangulator.toTriangles( _vertices );

			if( !_triangles )
				Log.info( "This Polygon cannot be triangulate." );
		}
		/**
		 * Performs the calculation of the area of this polygon objects
		 * using <code>Triangle</code> obtained from the triangulation
		 * of the latter.
		 * <fr>
		 * Réalise le calcul de l'aire de ce polygone à l'aide des
		 * objets <code>Triangle</code> obtenus lors de la triangulation
		 * de ce dernier.
		 * </fr>
		 */
		protected function updateAcreage () : void
		{
			var n : Number = 0;
			_acreageSteps = [];
			if( _triangles )
				_triangles.forEach( function( t : Triangle, ... args ) : void
				{
					n += t.acreage;
					_acreageSteps.push( n );
			} );
			_acreage = n;
		}
		/**
		 * @inheritDoc
		 */
		public function toSource () : String
		{
			return toReflectionSource ().replace("::", ".");
		}
		/**
		 * @inheritDoc
		 */
		public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace( "new $0($1,$2)",
						getQualifiedClassName(this ),
						magicToReflectionSource( _vertices ),
						pathBasedOnLength );
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
			return getQualifiedClassName ( this );
		}
	}
}
