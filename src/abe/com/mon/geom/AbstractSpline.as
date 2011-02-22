/**
 * @license
 */
package abe.com.mon.geom
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.GeometryUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * La classe <code>AbstractSpline</code> fournie un certains nombre de méthodes
	 * communes à toutes les implémentations de l'interface <code>Spline</code>.
	 * <p>
	 * La classe <code>AbstractSpline</code> gère notamment les segments en établissant
	 * un principe de taille de segments. Ce principe permet au classes filles de
	 * déterminer le nombre de sommets nécessaires à la constitution d'un segment, sans
	 * avoir à implémenter directement les fonctions de validation, de récupération ou
	 * de contrôle des segments.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * Un tableau contenant les objets <code>Point</code> représentant
		 * les sommets de cette <code>Spline</code>.
		 */
		protected var _vertices : Array;
		/**
		 * Un entier définissant la longueur d'un segment pour cette <code>Spline</code>.
		 *
		 * @default 2
		 */
		protected var _segmentSize : uint;
		/**
		 * Un entier définissant la finesse de dessin de cette <code>Spline</code>.
		 *
		 * @default 20
		 */
		public var drawBias : uint;
		/**
		 * Une valeur booléenne indiquant si la méthode <code>draw</code> dessine
		 * aussi les sommets de la <code>Spline</code>.
		 *
		 * @default false
		 */
		public var drawVertices : Boolean;
		/**
		 * Une valeur booléenne indiquant si la méthode <code>draw</code> ne dessine
		 * que les sommets placés le long de la <code>Spline</code>, les joitures de
		 * somments ne seront pas dessinés.
		 *
		 * @default false
		 */
		public var drawOnlySegmentVertices : Boolean;

		/**
		 * Constructeur de la classe <code>AbstractSpline</code>
		 *
		 * @param	v			un tableau d'objets <code>Point</code> représentant les sommets
		 * 						de cette <code>Spline</code>
		 * @param	segmentSize	le nombre de sommets nécessaires pour constituer un segment
		 * @param	bias		la finesse de dessin de cette <code>Spline</code>
		 */
		public function AbstractSpline ( v : Array = null, segmentSize : uint = 2, bias : uint = 20 )
		{
			this._segmentSize = segmentSize;
			this.vertices = v;
			this.drawBias = bias;
			this.drawVertices = false;
			this.drawOnlySegmentVertices = false;
		}
		/**
		 * Une référence vers le tableau contenant les objets <code>Point</code>
		 * représentant les sommets de cette <code>Spline</code>.
		 */
		public function get vertices () : Array { return _vertices; }
		public function set vertices ( v : Array ) : void
		{
			if( !v )
			{
				_vertices = new Array();
				return;
			}
			if( checkVertices( v ) )
				_vertices = v;
		}
		/**
		 * Un entier représentant le nombre de segments dans cette <code>Spline</code>.
		 */
		public function get numSegments () : uint
		{
			return _vertices.length == 0 ? 0 : ( _vertices.length - 1 ) / _segmentSize;
		}
		/**
		 * Un nombre représentant la longueur de cette <code>Spline</code> calculée
		 * en utilisant la valeur de <code>drawBias</code> de cette instance.
		 */
		public function get length () : Number { return getLength( drawBias );	}
		/**
		 * Un entier indiquant le nombre de sommets nécessaires pour constituer
		 * un segment pour cette <code>Spline</code>.
		 */
		public function get segmentSize () : uint { return _segmentSize; }
		/**
		 * @inheritDoc
		 */
		public function get points () : Array
		{
			var a : Array = [];
			for( var i : int = 0; i <= drawBias;i++)
				a.push ( getPathPoint( ( i / drawBias ) ) );
			return a;
		}
		/**
		 * @inheritDoc
		 */
		public function get isClosedSpline () : Boolean { return (_vertices[0] as Point).equals( _vertices[_vertices.length-1] ); }

		/**
		 * Renvoie les coordonnées du point à la position <code>path</code>
		 * dans cette <code>Spline</code>.
		 *
		 * @param	path	position dans la courbe
		 * @return	les coordonnées du point à la position <code>path</code>
		 * 			dans cette <code>Spline</code>
		 */
		public function getPathPoint (path : Number) : Point
		{
			var p : Number = path * numSegments;
			var seg : uint = Math.floor( p );

			if( seg == numSegments )
				seg--;

			var inseg : Number = p - seg;
			return getInnerSegmentPoint( inseg, getSegment( seg ) );
		}
		/**
		 * @inheritDoc
		 */
		public function getPathOrientation (path : Number) : Number
		{
			var p : Point = getTangentAt ( path );
			return Math.atan2( p.y, p.x );
		}
		/**
		 * Renvoie <code>true</code> si le tableau <code>v</code> est un
		 * tableau valide pour cette <code>Spline</code>.
		 * <p>
		 * Le nombre de coordonnées que doit contenir un tableau valide
		 * est fonction de la taille des segments de cette <code>Spline</code>.
		 * </p>
		 * @param	v	le tableau à vérifier
		 * @return	<code>true</code> si le tableau <code>v</code> est un
		 * 			tableau valide pour cette <code>Spline</code>
		 */
		protected function checkVertices (v : Array ) : Boolean
		{
			return v.length % _segmentSize == 1 && v.length >= _segmentSize+1;
		}
		/**
		 * Renvoie la tangeante de la courbe aux coordonnées situées à la position
		 * <code>pos</code> du chemin de cette <code>Spline</code>.
		 *
		 * @param	pos	position à laquelle calculée la tangeante
		 * @param 	posDetail	finesse de calcul de la position pour le calcul
		 * 						de la tangeante
		 * @return	la tangeante de la courbe aux coordonnées situées à la position
		 * 			transmise en argument
		 */
		public function getTangentAt ( pos : Number, posDetail : Number = 0.01 ) : Point
		{
			var tan : Point = getPathPoint( Math.min( 1, pos + posDetail ) ).subtract(
							  getPathPoint( Math.max( 0, pos - posDetail ) ) );
			tan.normalize(1);

			return tan;
		}
		/**
		 * Renvoie un tableau contenants les objets <code>Point</code> correspondant
		 * aux sommets du segment à l'index <code>n</code> si il en existe un, autrement
		 * <code>null</code>.
		 *
		 * @param	n	index du segment à récupérer, les index commencent à 0
		 * @return	un tableau contenants les objets <code>Point</code> correspondant
		 * 			aux sommets du segment correspondant
		 */
		public function getSegment ( n : Number ) : Array
		{
			if( n < numSegments )
				return _vertices.slice( n * _segmentSize, ( n + 1 ) * _segmentSize + 1 );
			else
				return null;
		}
		/**
		 * Renvoie la longueur de cette <code>Spline</code> calculée sur la base
		 * du paramètre de finesse <code>bias</code> passé en paramètre.
		 *
		 * @param	bias	finesse du calcul de longueur
		 * @return	la longueur de cette <code>Spline</code>
		 */
		public function getLength ( bias : uint ) : Number
		{
			var l : uint = numSegments;
			var _length : Number = 0;
			var i : Number;

			for( i=0; i < l; i++ )
				_length += getSegmentLength ( getSegment( i ), bias );

			return _length;
		}
		/**
		 * Renvoie un objet <code>Point</code> située à la position <code>path</code>
		 * relativement au segment <code>seg</code>.
		 *
		 * @param	path	position dans le chemin du segment
		 * @param	seg		segment dans lequel calculée la coordonnée
		 * @return	un objet <code>Point</code>
		 */
		protected function getInnerSegmentPoint ( path : Number, seg : Array ) : Point
		{
			var t1 : Number = 1 - path;
			return new Point( seg[0].x * t1 + seg[1].x * path,
										seg[0].y * t1 + seg[1].y * path );
		}
		/**
		 * Renvoie la longueur du segment <code>seg</code> calculée sur la base
		 * du paramètre de finesse <code>bias</code> transmis à la fonction.
		 *
		 * @param	seg		segment	à mesurer
		 * @param	bias	finesse du calcul
		 * @return	la longueur du segment
		 */
		protected function getSegmentLength ( seg : Array, bias : Number ) : Number
		{
			var l : Number = bias;
			var step : Number = 1/bias;
			var i : Number;
			var _length : Number = 0;

			for( i=1; i <= l; i++ )
				_length += Point.distance(getInnerSegmentPoint( (i-1)*step , seg ), getInnerSegmentPoint( (i)*step , seg ));

			return _length;
		}
		/**
		 * Renvoie une copie parfaite de cet objet <code>AbstractSpline</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>AbstractSpline</code>
		 */
		public function clone () : *
		{
			return new AbstractSpline( _vertices.concat(), _segmentSize, drawBias );
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
			return "";
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this);
		}
		/**
		 * @inheritDoc
		 */
		public function draw ( g : Graphics, c : Color ) : void
		{
			var l : Number = numSegments;
			var i : Number;

			g.lineStyle(0,c.hexa, c.alpha/255);

			for( i=0; i < l; i++ )
				drawSegment( getSegment( i ), g, c );

			g.lineStyle();

			if( drawVertices )
			{
				drawVerticesDot( g );
				if( !drawOnlySegmentVertices )
					drawVerticesConnections( g );
			}
		}
		/**
		 * <p>
		 * <strong>Note :</strong> Cette fonction n'est pas supportée pour les courbes non fermées.
		 * </p>
		 * @inheritDoc
		 */
		public function fill ( g : Graphics, c : Color ) : void
		{
			if( !isClosedSpline )
				throw new Error ("La méthode fill n'est supportée que pour les courbes fermées.");
			else
			{
				var l : Number = numSegments;
				var i : Number;

				g.beginFill(c.hexa, c.alpha/255);

				for( i=0; i < l; i++ )
					drawSegment( getSegment( i ), g, c );

				g.endFill();

				if( drawVertices )
				{
					drawVerticesDot( g );
					if( !drawOnlySegmentVertices )
						drawVerticesConnections( g );
				}
			}
		}
		/**
		 * Dessine les sommets de cette <code>Spline</code> dans l'objet <code>Graphics</code>
		 * transmis en paramètre.
		 *
		 * @param	g	objet <code>Graphics</code> dans lequel dessiné
		 */
		protected function drawVerticesDot ( g : Graphics ) : void
		{
			var l : Number = _vertices.length;
			var i : Number;

			g.lineStyle();
			for( i=0; i<l; i++ )
			{
				var pt : Point = _vertices[i];
				if( i % _segmentSize == 0 )
				{
					g.beginFill(0xffffff);
					g.drawCircle(pt.x, pt.y, 3 );
					g.endFill();
				}
				else if( !drawOnlySegmentVertices )
				{
					g.beginFill(0xffffff,.5);
					g.drawRect(pt.x-2, pt.y-2, 4, 4);
					g.endFill();
				}
			}
		}
		/**
		 * Dessine les connexions entre les sommets de cette <code>Spline</code>
		 * dans l'objet <code>Graphics</code> transmis en paramètre.
		 * <p>
		 * Dans le cas d'une <code>Spline</code> linéaire, le résultat est le même
		 * que la courbe elle même, cependant, dans le cas de courbes de bézier,
		 * cette fonction permet de mettre en évidence les points de contrôle
		 * de la courbe.
		 * </p>
		 *
		 * @param	g	objet <code>Graphics</code> dans lequel dessiné
		 */
		protected function drawVerticesConnections ( g : Graphics ) : void
		{
			var l : Number = _vertices.length;
			var i : Number;

			g.lineStyle(0,0xffffff,0.5);
			for( i=1; i<l; i++ )
			{
				var pt1 : Point = _vertices[i-1];
				var pt2 : Point = _vertices[i];
				g.moveTo(pt1.x, pt1.y);
				g.lineTo(pt2.x, pt2.y);
			}
			g.lineStyle();
		}
		/**
		 * Dessine le segment <code>seg</code> dans l'objet <code>Graphics</code>
		 * transmis en paramètre avec la couleur <code>c</code>.
		 *
		 * @param	seg	segment à dessiner
		 * @param	g	objet <code>Graphics</code> dans lequel dessiné
		 * @param	c	couleur avec laquelle dessiné le segment
		 */
		protected function drawSegment ( seg : Array, g : Graphics, c : Color ) : void
		{
			var l : Number = drawBias;
			var step : Number = 1/l;
			var i : Number;

			for( i=1; i <= l; i++ ) 
			{
				var pt1 : Point = getInnerSegmentPoint( ( i - 1 ) * step , seg );				var pt2 : Point = getInnerSegmentPoint( ( i ) * step , seg );

				g.moveTo( pt1.x, pt1.y );				g.lineTo( pt2.x, pt2.y );
			}
		}
		
	}
}
