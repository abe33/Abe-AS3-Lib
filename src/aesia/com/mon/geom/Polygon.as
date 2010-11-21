package aesia.com.mon.geom
{
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Equatable;
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.GeometryUtils;
	import aesia.com.mon.utils.MathUtils;
	import aesia.com.mon.utils.PointUtils;
	import aesia.com.mon.utils.RandomUtils;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.mon.utils.magicToReflectionSource;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	/**
	 * La classe <code>Polygon</code> permet de représenter des géométries planes,
	 * fermées, constituées d'un nombre indéfini de sommets.
	 * <p>
	 * Un objet <code>Polygon</code> valide est constitué par au minimum trois sommets.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class Polygon implements Serializable, Cloneable, Equatable, Geometry, Path, Surface, FormMetaProvider
	{
		/**
		 * Une instance globale de la classe <code>Triangulate</code> utilisée
		 * pour réaliser la triangulation des objets <code>Polygon</code>.
		 *
		 * @default	new Triangulate()
		 */
		static protected var triangulator : Triangulate = new Triangulate();
		/**
		 * Un tableau contenant l'ensemble des sommets de ce polygone.
		 */
		protected var _vertices : Array;
		/**
		 * Un tableau contenant l'ensemble des objets <code>Triangle</code>
		 * résultants de la triangulation de ce polygone.
		 */
		protected var _triangles : Array;
		/**
		 * Un tableau contenant l'ensemble des longueurs de segments additionnés
		 * afin de réaliser les opérations de calculs de chemins basé sur la
		 * longueur des arrêtes de ce polygones.
		 * <p>
		 * Pour un polygone <code>ABC</code>, le tableau contient les
		 * données suivantes :
		 * </p>
		 * <listing>
		 * [
		 * 	AB.length,
		 * 	AB.Length + BC.length,
		 * 	AB.length + BC.length + CA.length
		 * ]</listing>
		 */		protected var _pathSteps : Array;
		/**
		 * Un tableau contenant les aires accumulées des
		 * différents triangles constituant ce polygone.
		 * <p>
		 * Pour un polygone <code>ABCD</code>, le tableau contient les
		 * données suivantes :
		 * </p>
		 * <listing>
		 * [
		 * 	ABC.acreage,
		 * 	ABC.acreage + BCD.acreage
		 * ]</listing>
		 */
		protected var _acreageSteps : Array;
		/**
		 * Un nombre contenant la valeur précalculée
		 * de l'aire de ce polygone en <code>px²</code>.
		 */
		protected var _acreage : Number;
		/**
		 * Un nombre contenant la valeur précalculée du périmètre
		 * de ce polygone.
		 */
		protected var _length : Number;
		/**
		 * Une valeur booléenne indiquant si les calculs d'une position
		 * dans le chemin de ce <code>Polygon</code> se font sur la
		 * base de la longueur du périmètre ou sur la base du nombre
		 * d'arrêtes.
		 * <p>
		 * Dans le cas d'un chemin basé sur les longeurs des arrêtes,
		 * les données contenues dans le tableau <code>_pathSteps</code>
		 * sont utilisées.
		 * </p>
		 * @default	true
		 */
		public var pathBasedOnLength : Boolean;
		/**
		 * Une valeur booléenne indiquant si les triangles issus
		 * de la triangulation de ce polygone doivent être dessinés
		 * dans le cadre de la méthode <code>draw</code>.
		 *
		 * @default	false
		 */
		public var drawTriangles : Boolean;

		/**
		 * Constructeur de la classe <code>Polygon</code>.
		 *
		 * @param	vertices			un tableau d'objets <code>Point</code>
		 * 								représentant les sommets de ce polygone
		 * @param	pathBasedOnLength	le calcul du chemin est-il basé
		 * 								sur la longueur du périmètre du
		 * 								triangle ?
		 * @throws	Error	Un polygone doit posséder au minimum trois sommets pour être valide.
		 */
		public function Polygon ( vertices : Array,
								  pathBasedOnLength : Boolean = true )
		{
			this.vertices = vertices;
			this.pathBasedOnLength = pathBasedOnLength;
		}
		/**
		 * Un tableau contenant l'ensemble des sommets de ce polygone.
		 * <p>
		 * Le tableau doit avoir au mininum trois sommets pour être valide,
		 * sinon un exception est levée.
		 * </p>
		 * @throws	Error	Un polygone doit posséder au minimum trois sommets pour être valide.
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
		 * Une copie du tableau contenant les objets <code>Triangle</code> résultant
		 * de la triangulation de ce polygone.
		 */
		public function get triangles () : Array { return _triangles.concat(); }
		/**
		 * Un nombre représentant la longueur du périmètre de ce polygone.
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
					step = _pathSteps[i] / le;					if( path < step )
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
		public function getRandomPointInSurface () : Point
		{
			if( _triangles )
			{
				return ( RandomUtils.inArrayWithRatios ( _triangles, _acreageSteps, true, _acreage ) as Triangle ).getRandomPointInSurface ();
			}
			else
				return null;
		}
		/**
		 * Renvoie une copie parfaite de cet objet <code>Polygon</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>Polygon</code>
		 */
		public function clone () : *
		{
			return new Polygon( vertices.concat(), pathBasedOnLength);
		}
		/**
		 * Renvoie <code>true</code> si <code>o</code> est égal à
		 * cette instance.
		 * <p>
		 * Deux polygones sont égaux si tout leur sommets sont égaux.
		 * </p>
		 *
		 * @param 	o	instance à comparer avec l'instance courante
		 * @return	<code>true</code> si <code>o</code> est égal à
		 * 			cette instance
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
		 * Renvoie <code>true</code> si le point <code>p</code>
		 * est situé à l'intérieur de cet objet <code>Polygon</code>.
		 *
		 * @param	p	point dont on souhait savoir si il se situe
		 * 				à l'intérieur du polygone
		 * @return	<code>true</code> si le point est situé à l'intérieur
		 * 			de ce polygone
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
		 */
		public function updatePolygonData () : void
		{
			updateTriangles ();
			updateAcreage ();
			updatePathSteps ();
			updateLength ();
		}
		/**
		 * Calcul la longueur du périmètre de ce polygone.
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
		 * Calculs des longueurs de chaque arrête afin de constituer le tableau
		 * <code>_pathSteps</code>.
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
		 * Réalise la triangulation de ce polygone et stocke le résultat
		 * dans la propriété <code>_triangles</code>.
		 */
		protected function updateTriangles () : void
		{
			_triangles = triangulator.toTriangles( _vertices );

			if( !_triangles )
				Log.info( "This Polygon cannot be triangulate." );
		}
		/**
		 * Réalise le calcul de l'aire de ce polygone à l'aide des
		 * objets <code>Triangle</code> obtenus lors de la triangulation
		 * de ce dernier.
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
