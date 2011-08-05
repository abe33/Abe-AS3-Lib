/**
 * @license
 */
package abe.com.mon.geom
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.GeometryUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * The <code>AbstractSpline</code> class provide a number of methods common
	 * to all implementations of the interface <code>Spline</code>.
	 * <p>
	 * The <code>AbstractSpline</code> manages particular segments by establishing
	 * a principle of sized segments. This principle allows the subclasses to determine
	 * the number of vertices needed to create a segment, without having to directly
	 * implement the validation functions, recovery or control segments.</p>
	 * 
	 * <fr>
	 * La classe <code>AbstractSpline</code> fournie un certains nombre de méthodes
	 * communes à toutes les implémentations de l'interface <code>Spline</code>.
	 * <p>
	 * La classe <code>AbstractSpline</code> gère notamment les segments en établissant
	 * un principe de taille de segments. Ce principe permet au classes filles de
	 * déterminer le nombre de sommets nécessaires à la constitution d'un segment, sans
	 * avoir à implémenter directement les fonctions de validation, de récupération ou
	 * de contrôle des segments.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class AbstractSpline implements Spline, Path, Geometry, Cloneable, Serializable
	{
		/**
		 * An array containing <code>Point</code> objects representing the vertices
		 * of the <code>Spline</code>.
		 * 
		 * <fr>
		 * Un tableau contenant les objets <code>Point</code> représentant
		 * les sommets de cette <code>Spline</code>.
		 * </fr>
		 */
		protected var _vertices : Array;
		/**
		 * An integer defining the length of a segment for this <code>Spline</code>.
		 * <fr>
		 * Un entier définissant la longueur d'un segment pour cette <code>Spline</code>.
		 * </fr>
		 * @default 2
		 */
		protected var _segmentSize : uint;
		/**
		 * An integer defining the drawing bias of this <code>Spline</code>.
		 * <fr>
		 * Un entier définissant la finesse de dessin de cette <code>Spline</code>.
		 * </fr>
		 * @default 20
		 */
		public var drawBias : uint;
		/**
		 * A boolean value indicating whether the <code>draw</code> method
		 * draws also the vertices of the spline.
		 * <fr>
		 * Une valeur booléenne indiquant si la méthode <code>draw</code> dessine
		 * aussi les sommets de la <code>Spline</code>.
		 * </fr>
		 * @default false
		 */
		public var drawVertices : Boolean;
		/**
		 * A boolean value indicating whether the <code>draw</code> method 
		 * draws only the vertices placed along the spline, joins vertices
		 * are not drawn.
		 * <fr>
		 * Une valeur booléenne indiquant si la méthode <code>draw</code> ne dessine
		 * que les sommets placés le long de la <code>Spline</code>, les jointures de
		 * sommets ne seront pas dessinés.
		 * </fr>
		 * @default false
		 */
		public var drawOnlySegmentVertices : Boolean;

		/**
		 * <code>AbstractSpline</code> constructor.
		 * <fr>
		 * Constructeur de la classe <code>AbstractSpline</code>
		 * </fr>
		 * @param	v			an array of objects <code>Point</code> representing the vertices
		 * 						of the spline
		 * 						<fr>un tableau d'objets <code>Point</code> représentant les sommets
		 * 						de cette <code>Spline</code></fr>
		 * @param	segmentSize	the number of vertices required to form a segment
		 * 						<fr>le nombre de sommets nécessaires pour constituer un segment</fr>
		 * @param	bias		the fineness of the drawing for this <code>Spline</code>
		 * 						<fr>la finesse de dessin de cette <code>Spline</code></fr>
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
		 * @inheritDoc
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
		 * An integer representing the number of segments in this <code>Spline</code>.
		 * <fr>
		 * Un entier représentant le nombre de segments dans cette <code>Spline</code>.
		 * </fr>
		 */
		public function get numSegments () : uint
		{
			return _vertices.length == 0 ? 0 : ( _vertices.length - 1 ) / _segmentSize;
		}
		/**
		 * A number representing the length of this <code>Spline</code> computed using
		 * the value of <code>drawBias</code> in this instance.
		 * <fr>
		 * Un nombre représentant la longueur de cette <code>Spline</code> calculée
		 * en utilisant la valeur de <code>drawBias</code> de cette instance.
		 * </fr>
		 */
		public function get length () : Number { return getLength( drawBias );	}
		/**
		 * An integer indicating the number of vertices required to form
		 * a segment for this <code>Spline</code>.
		 * <fr>
		 * Un entier indiquant le nombre de sommets nécessaires pour constituer
		 * un segment pour cette <code>Spline</code>.
		 * </fr>
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
		 * @inheritDoc
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
		 * Returns <code>true</code> if the array <code>v</code> is a valid array for this <code>Spline</code>. 
		 * <p> 
		 * Number of coordinates that must contain the valid array depends of the size of the segments of the spline.
		 * </p>
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si le tableau <code>v</code> est un
		 * tableau valide pour cette <code>Spline</code>.
		 * <p>
		 * Le nombre de coordonnées que doit contenir un tableau valide
		 * est fonction de la taille des segments de cette <code>Spline</code>.
		 * </p>
		 * </fr>
		 * @param	v	the array to check
		 * 				<fr>le tableau à vérifier</fr>
		 * @return	<code>true</code> if the array <code>v</code> is a valid array
		 * 			for this <code>Spline</code>
		 * 			<fr><code>true</code> si le tableau <code>v</code> est un
		 * 			tableau valide pour cette <code>Spline</code></fr>
		 */
		protected function checkVertices (v : Array ) : Boolean
		{
			return v.length % _segmentSize == 1 && v.length >= _segmentSize+1;
		}
		/**
		 * @inheritDoc
		 */
		public function getTangentAt ( pos : Number, posDetail : Number = 0.01 ) : Point
		{
			var tan : Point = getPathPoint( Math.min( 1, pos + posDetail ) ).subtract(
							  getPathPoint( Math.max( 0, pos - posDetail ) ) );
			tan.normalize(1);

			return tan;
		}
		/**
		 * Returns an array containing objects <code>Point</code> corresponding to the vertices
		 * of the segment index <code>n</code> if there is one, otherwise <code>null</code>.
		 * <fr>
		 * Renvoie un tableau contenants les objets <code>Point</code> correspondant
		 * aux sommets du segment à l'index <code>n</code> si il en existe un, autrement
		 * <code>null</code>.
		 * </fr>
		 * @param	n	index segment to retrieve, index start at 0
		 * 				<fr>index du segment à récupérer, les index commencent à 0</fr>
		 * @return	an array containing objects <code>Point</code> corresponding 
		 * 			to the vertices of the corresponding segment
		 * 			<fr>un tableau contenants les objets <code>Point</code> correspondant
		 * 			aux sommets du segment correspondant</fr>
		 */
		public function getSegment ( n : Number ) : Array
		{
			if( n < numSegments )
				return _vertices.slice( n * _segmentSize, ( n + 1 ) * _segmentSize + 1 );
			else
				return null;
		}
		/**
		 * Returns the length of this <code>Spline</code> computed 
		 * based on the <code>bias</code> parameter.
		 * <fr>
		 * Renvoie la longueur de cette <code>Spline</code> calculée sur la base
		 * du paramètre de finesse <code>bias</code> passé en paramètre.
		 * </fr>
		 * @param	bias	fineness of computation of the the length
		 * 					<fr>finesse du calcul de longueur</fr>
		 * @return	the length of this <code>Spline</code>
		 * 			<fr>la longueur de cette <code>Spline</code></fr>
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
		 * Returns an object <code>Point</code> located at position <code>path</code>
		 * relative to the segment  <code>seg</code>.
		 * <fr>
		 * Renvoie un objet <code>Point</code> située à la position <code>path</code>
		 * relativement au segment <code>seg</code>.
		 * </fr>
		 * @param	path	position in the path segment
		 * 					<fr>position dans le chemin du segment</fr>
		 * @param	seg		array containing the segments vertices
		 * 					<fr>segment dans lequel calculer la coordonnée</fr>
		 * @return	a <code>Point</code> object
		 * 			<fr>un objet <code>Point</code></fr>
		 */
		protected function getInnerSegmentPoint ( path : Number, seg : Array ) : Point
		{
			var t1 : Number = 1 - path;
			return new Point( seg[0].x * t1 + seg[1].x * path,
										seg[0].y * t1 + seg[1].y * path );
		}
		/**
		 * Returns the length of the segment <code>seg</code> computed based
		 * on the <code>bias</code> parameter passed to the function.
		 * <fr>
		 * Renvoie la longueur du segment <code>seg</code> calculée sur la base
		 * du paramètre de finesse <code>bias</code> transmis à la fonction.
		 * </fr>
		 * @param	seg		segment to be measured 
		 * 					<fr>segment à mesurer</fr>
		 * @param	bias	fineness of computation of the the length
		 * 					<fr>finesse du calcul</fr>
		 * @return	the length of the segment
		 * 			<fr>la longueur du segment</fr>
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
		 * @inheritDoc
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
			return "";
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
		 * <p><strong>Note:</strong> This feature is not supported for non-closed curves.</p>
		 * <fr>
		 * <p><strong>Note :</strong> Cette fonction n'est pas supportée pour les courbes non fermées.</p>
		 * </fr>
		 * @inheritDoc
		 * @throws Error The fill method is supported only for closed curves.
		 */
		public function fill ( g : Graphics, c : Color ) : void
		{
			if( !isClosedSpline )
				throw new Error ("The fill method is supported only for closed curves.");
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
		 * Draw the vertices of the spline in the <code>Graphics</code> object passed as parameter.
		 * <fr>
		 * Dessine les sommets de cette <code>Spline</code> dans l'objet <code>Graphics</code>
		 * transmis en paramètre.
		 * </fr>
		 * @param	g	<code>Graphics</code> object in which drawn
		 * 				<fr>objet <code>Graphics</code> dans lequel dessiné</fr>
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
		 * Draw connections between the vertices of this <code>Spline</code> 
		 * in the <code>Graphics</code> object passed as parameter. 
		 * <p>
		 * In the case of a linear spline, the result is the same as the curve itself,
		 * however, in the case of bezier curves, this feature allows you to highlight
		 * points curve control.
		 * </p>
		 * <fr>
		 * Dessine les connexions entre les sommets de cette <code>Spline</code>
		 * dans l'objet <code>Graphics</code> transmis en paramètre.
		 * <p>
		 * Dans le cas d'une <code>Spline</code> linéaire, le résultat est le même
		 * que la courbe elle même, cependant, dans le cas de courbes de bézier,
		 * cette fonction permet de mettre en évidence les points de contrôle
		 * de la courbe.
		 * </p>
		 * </fr>
		 * @param	g	<code>Graphics</code> object in which drawn
		 * 				<fr>objet <code>Graphics</code> dans lequel dessiné</fr>
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
		 * Draw the segment  <code>seg</code> in the <code>Graphics</code> object
		 * parameter passed in with the color <code>c</code>.
		 * <fr>
		 * Dessine le segment <code>seg</code> dans l'objet <code>Graphics</code>
		 * transmis en paramètre avec la couleur <code>c</code>.
		 * </fr>
		 * @param	seg	segment to draw
		 * 				<fr>segment à dessiner</fr>
		 * @param	g	<code>Graphics</code> object in which drawn
		 * 				<fr>objet <code>Graphics</code> dans lequel dessiné</fr>
		 * @param	c	color with which the segment drawn
		 * 				<fr>couleur avec laquelle dessiné le segment</fr>
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
