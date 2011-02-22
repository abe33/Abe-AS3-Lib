/**
 * @license
 */
package abe.com.mon.geom
{
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.GeometryUtils;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>Rectangle2</code> étend la classe <code>Rectangle</code>
	 * principalement pour fournir un contrôle de la rotation du rectangle.
	 * <p>
	 * De plus, la classe <code>Rectangle2</code> implémentent les interfaces
	 * <code>Geometry</code>, <code>Surface</code> et <code>Path</code> ainsi
	 * qu'un support de la sérialisation tel que définie dans l'interface
	 * <code>Serializable</code>.
	 * </p>
	 * <p>
	 * La plupart des méthodes de la classes <code>Rectangle</code> ont été
	 * réécrites afin de supporter la rotation. Seules les méthodes
	 * <code>union</code> et <code>intersection</code> ne sont pas supportées
	 * par la classe <code>Rectangle2</code>.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class Rectangle2 extends Rectangle implements Serializable,
														 Path,
														 Geometry,
														 ClosedGeometry,
														 Surface,
														 Randomizable
	{
		/**
		 * Une valeur booléenne indiquant si les calculs d'une position
		 * dans le chemin de ce <code>Rectangle2</code> se font sur la
		 * base de la longueur du périmètre ou sur la base des arrêtes.
		 * <p>
		 * Dans le cas où les calculs sont basés sur les arrêtes, le
		 * chemin se découpe de la manière suivante :
		 * </p>
		 * <ul>
		 * <li>De <code>0</code> à <code>0.25</code> la position renvoyée
		 * se situe sur l'arrête supérieure du rectangle.</li>
		 * <li>De <code>0.25</code> à <code>0.5</code> la position renvoyée
		 * se situe sur l'arrête droite du rectangle.</li>
		 * <li>De <code>0.5</code> à <code>0.75</code> la position renvoyée
		 * se situe sur l'arrête inférieure du rectangle.</li>
		 * <li>De <code>0.75</code> à <code>1</code> la position renvoyée
		 * se situe sur l'arrête gauche du rectangle.</li>
		 * </ul>
		 *
		 * @default true
		 */
		public var pathBasedOnLength : Boolean;
		/**
		 * Angle en radians de la rotation de cet objet <code>Rectangle2</code>.
		 */
		public var rotation : Number;
		/**
		 * Constructeur de la classe <code>Rectangle2</code>.
		 *
		 * @param	xOrRect				la position en x de ce rectangle ou un objet <code>Rectangle</code>
		 * 								servant à initialiser cet instance
		 * @param	yOrRotation			position en y de ce rectangle ou la rotation lorsque le premier argument
		 * 								est un objet <code>Rectangle</code>
		 * @param	width				longueur de ce rectangle
		 * @param	height				hauteur de ce rectangle
		 * @param	rotation			rotation de ce rectangle
		 * @param	pathBasedOnLength	le calcul du chemin est-il basé
		 * 								sur la longueur du périmètre du
		 * 								rectangle ?
		 * @example	Création d'une nouvelle instance à partir d'un objet <code>Rectangle</code> :
		 * <listing>var r : Rectangle = new Rectangle( 50, 100, 200, 100 );
		 * var r2 : Rectangle2 = new Rectangle2( r, Math.PI / 4 );</listing>
		 * Création d'une nouvelle instance de manière classique :
		 * <listing>var r : Rectangle2 = new Rectangle2( 50, 100, 200, 100, Math.PI / 4 );</listing>
		 */
		public function Rectangle2 ( xOrRect : * = 0,
									 yOrRotation : Number = 0,
									 width : Number = 0,
									 height : Number = 0,
									 rotation : Number = 0,
									 pathBasedOnLength : Boolean = true )
		{
			super();
			if( xOrRect is Rectangle )
			{
				this.x = xOrRect.x;
				this.y = xOrRect.y;
				this.width = xOrRect.width;
				this.height = xOrRect.height;
				this.rotation = yOrRotation;			}
			else
			{
				this.x = xOrRect;
				this.y = yOrRotation;
				this.width = width;
				this.height = height;
				this.rotation = rotation;
			}
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
		 * Un objet représentant le vecteur de l'arrête supérieur.
		 */
		public function get topEdge () : Point { return pt( Math.cos( rotation ) * width,
															Math.sin( rotation ) * width );}
		/**
		 * Un objet représentant le vecteur de l'arrête inférieur.
		 */
		public function get bottomEdge () : Point { return topEdge; }
		/**
		 * Un objet représentant le vecteur de l'arrête gauche.
		 */
		public function get leftEdge () : Point { return pt( Math.cos( rotation + Math.PI / 2 ) * height,
															 Math.sin( rotation + Math.PI / 2 ) * height );}
		/**
		 * Un objet représentant le vecteur de l'arrête droite.
		 */
		public function get rightEdge () : Point { return leftEdge; }
		/**
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin supérieur gauche de ce <code>Rectangle2</code>.
		 */
		override public function get topLeft () : Point { return pt(x,y ); }
		override public function set topLeft (value : Point) : void
		{
			x = value.x;
			y = value.y;
		}
		/**
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin inférieur droit de ce <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 */
		override public function get bottomRight () : Point { return pt(x,y).add( topEdge ).add( leftEdge ); }
		override public function set bottomRight (value : Point) : void {}
		/**
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin supérieur droit de ce <code>Rectangle2</code>.
		 */
		public function get topRight () : Point { return pt(x,y).add( topEdge ); }
		/**
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin inférieur gauche de ce <code>Rectangle2</code>.
		 */		public function get bottomLeft () : Point { return pt(x,y).add( leftEdge ); }
		/**
		 * La coordonnée sur l'axe y du point le plus haut de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 */
		override public function get top () : Number { return MathUtils.min( y,
																			 topRight.y,
																			 bottomLeft.y,
																			 bottomRight.y ); }
		override public function set top (value : Number) : void {}
		/**
		 * La coordonnée sur l'axe y du point le plus bas de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 */
		override public function get bottom () : Number { return MathUtils.max(  y,
																				 topRight.y,
																				 bottomLeft.y,
																				 bottomRight.y ); }
		override public function set bottom (value : Number) : void {}
		/**
		 * La coordonnée sur l'axe x du point le plus à gauche de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 */
		override public function get left () : Number { return MathUtils.min( x,
																			 topRight.x,
																			 bottomLeft.x,
																			 bottomRight.x ); }
		override public function set left (value : Number) : void {}
		/**
		 * La coordonnée sur l'axe x du point le plus à droite de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 */
		override public function get right () : Number { return MathUtils.max( x,
																			 topRight.x,
																			 bottomLeft.x,
																			 bottomRight.x ); }
		override public function set right (value : Number) : void {}
		/**
		 * La longueur du périmètre de ce <code>Rectangle2</code>.
		 */
		public function get length () : Number
		{
			return width * 2 + height * 2;
		}
		/**
		 * Un objet <code>Point</code> représentant le centre
		 * de cet objet <code>Rectangle</code>.
		 */
		public function get center () : Point
		{
			return pt( ( topLeft.x + bottomRight.x ) / 2,
					   ( topLeft.y + bottomRight.y ) / 2 );
		}
		public function set center ( p : Point ) : void
		{
			var d : Point = p.subtract(center);
			x += d.x;
			y += d.y;
		}
		/**
		 * Un objet <code>Point</code> représentant le centre de l'arrête supérieure.
		 */
		public function get topEdgeCenter () : Point { return topLeft.add( PointUtils.scaleNew( topEdge, .5 ) ); }
		/**
		 * Un objet <code>Point</code> représentant le centre de l'arrête inférieure.
		 */		public function get bottomEdgeCenter () : Point { return bottomLeft.add( PointUtils.scaleNew( bottomEdge, .5 ) ); }
		/**
		 * Un objet <code>Point</code> représentant le centre de l'arrête de gauche.
		 */		public function get leftEdgeCenter () : Point { return topLeft.add( PointUtils.scaleNew( leftEdge, .5 ) ); }
		/**
		 * Un objet <code>Point</code> représentant le centre de l'arrête de droite.
		 */		public function get rightEdgeCenter () : Point { return topRight.add( PointUtils.scaleNew( rightEdge, .5 ) ); }

		/**
		 * @inheritDoc
		 */
		public function get acreage () : Number { return width * height; }
		/**
		 * @inheritDoc
		 */
		public function get points () : Array { return [ topLeft, topRight, bottomRight, bottomLeft, topLeft ];	}
		/**
		 * <p>
		 * Les coordonnées renvoyées peuvent être différentes
		 * pour une même valeur de <code>path</code> selon
		 * que la propriété <code>pathBasedOnLength</code> est
		 * à <code>true</code> ou à <code>false</code>.
		 * </p>
		 *
		 * @inheritDoc
		 */
		public function getPathPoint ( path : Number ) : Point
		{
			var p1 : Number;
			var p2 : Number;
			var p3 : Number;
			if( pathBasedOnLength )
			{
				var l : Number = length;
				p1 = width / l;
				p2 = ( width + height ) / l;
				p3 = p1 + p2;
			}
			else
			{
				p1 = .25;
				p2 = .5;
				p3 = .75;
			}
			if( path < p1 )
				return pt( x, y ).add( PointUtils.scaleNew( topEdge, MathUtils.map( path, 0, p1, 0, 1 ) ) );			else if( path < p2 )
				return topRight.add( PointUtils.scaleNew( rightEdge, MathUtils.map( path, p1, p2, 0, 1 ) ) );			else if( path < p3 )
				return bottomRight.add( PointUtils.scaleNew( bottomEdge, MathUtils.map( path, p2, p3, 0, 1 ) * -1 ) );
			else
				return bottomLeft.add( PointUtils.scaleNew( leftEdge, MathUtils.map( path, p3, 1, 0, 1 ) * -1 ) );
		}
		/**
		 * @inheritDoc
		 * <p>
		 * L'orientation renvoyée peut être différente
		 * pour une même valeur de <code>path</code> selon
		 * que la propriété <code>pathBasedOnLength</code> est
		 * à <code>true</code> ou à <code>false</code>.
		 * </p>
		 */
		public function getPathOrientation (path : Number) : Number
		{
			var p1 : Number;
			var p2 : Number;
			var p3 : Number;
			var p : Point;
			if( pathBasedOnLength )
			{
				var l : Number = length;
				p1 = width / l;
				p2 = ( width + height ) / l;
				p3 = p1 + p2;
			}
			else
			{
				p1 = .25;
				p2 = .5;
				p3 = .75;
			}
			if( path < p1 )
				p = topEdge;
			else if( path < p2 )
				p = rightEdge;
			else if( path < p3 )
				p = PointUtils.scaleNew( bottomEdge, -1 );
			else
				p = PointUtils.scaleNew( leftEdge, -1 );

			return Math.atan2( p.y, p.x );
		}
		/**
		 * @inheritDoc
		 */
		public function getRandomPointInSurface () : Point
		{
			return topLeft.add( PointUtils.scaleNew( topEdge, _randomSource.random() ) )
						  .add( PointUtils.scaleNew( leftEdge, _randomSource.random() ) );
		}
		public function getPointAtAngle (a : Number) : Point
		{
			var s : Point = center;
			var e : Point = s.add(pt(Math.cos(a)*10000,Math.sin(a)*10000));
			
			return GeometryUtils.vectorGeomIntersection( s, e, this )[0];
		}
		/**
		 * Effectue une rotation de cet objet <code>Rectangle2</code> autour
		 * de son centre d'un angle de <code>r</code> radians.
		 *
		 * @param	r	angle de la rotation à effectuer
		 */
		public function rotateAroundCenter ( r : Number ) : void
		{
			var p : Point = PointUtils.rotateAround( topLeft, center, r);

			rotation += r;
			topLeft = p;
		}
		/**
		 * Redimensionne le rectangle de manière régulière autour du centre
		 * de ce dernier.
		 *
		 * @param	s	facteur de redimensionnement de ce rectangle
		 */
		public function scaleAroundCenter ( s : Number ) : void
		{
			var c : Point = center;
			width *= s;
			height *= s;
			center = c;
		}
		/**
		 * Redimensionne le rectangle autour du centre
		 * de ce dernier.
		 *
		 * @param	dx	incrément sur l'axe X		 * @param	dy	incrément sur l'axe Y
		 */
		public function inflateAroundCenter ( dx : Number, dy : Number ) : void
		{
			var c : Point = center;
			width += dx;
			height += dy;
			center = c;
		}
		/**
		 * Accroit la taille de ce rectangle par les valeurs de <code>dx</code>
		 * et <code>dy</code> sans que le centre de celui-ci ne soit modifié.
		 *
		 * @param	dx	une valeur à ajouter à la longueur de ce rectangle.
		 * 				La formule suivante est utilisée pour calculer la nouvelle
		 * 				longueur : <listing>width += dx &#42; 2;</listing>
		 * @param	dy	une valeur à ajouter à la hauteur de ce rectangle.
		 * 				La formule suivante est utilisée pour calculer la nouvelle
		 * 				longueur : <listing>height += dy &#42; 2;</listing>
		 */
		override public function inflate ( dx : Number, dy : Number ) : void
		{
			var c : Point = center;
			width += dx*2;
			height += dy*2;
			center = c;
		}
		public function inflateLeft( d : Number ) : void
		{
			width += d;
			var dp : Point = topEdge;
			dp.normalize(d);
			PointUtils.scale(dp, -1 );
			topLeft = topLeft.add( dp );
		}
		public function inflateRight( d : Number ) : void
		{
			width += d;
		}
		public function inflateTop( d : Number ) : void
		{
			height += d;
			var dp : Point = leftEdge;
			dp.normalize(d);
			PointUtils.scale(dp, -1 );
			topLeft = topLeft.add( dp );
		}
		public function inflateBottom( d : Number ) : void
		{
			height += d;
		}
		public function inflateTopLeft( dx : Number, dy : Number ):void
		{
			inflateLeft( dx );
			inflateTop( dy );
		}
		public function inflateTopRight( dx : Number, dy : Number ):void
		{
			inflateRight( dx );
			inflateTop( dy );
		}
		public function inflateBottomLeft( dx : Number, dy : Number ):void
		{
			inflateLeft( dx );
			inflateBottom( dy );
		}
		public function inflateBottomRight( dx : Number, dy : Number ):void
		{
			inflateRight( dx );
			inflateBottom( dy );
		}
		/**
		 * Accroit la taille de ce rectangle par les valeurs contenues dans
		 * <code>point</code> sans que le centre de celui-ci ne soit modifié.
		 *
		 * @param	point	un objet <code>Point</code> contenant les valeurs
		 * 					de modification de la longueur et de la hauteur de
		 * 					ce rectangle
		 */
		override public function inflatePoint ( point : Point ) : void
		{
			inflate(point.x*2, point.y*2);
		}
		/**
		 * Cette méthode n'est pas supportée par la classe <code>Rectangle2</code>.
		 */
		override public function union ( toUnion : Rectangle ) : Rectangle
		{
			return null;
		}
		/**
		 * Cette méthode n'est pas supportée par la classe <code>Rectangle2</code>.
		 */
		override public function intersection ( toIntersect : Rectangle ) : Rectangle
		{
			return null;
		}
		/**
		 * Renvoie <code>true</code> si le rectangle <code>toIntersect</code> entrecroise
		 * l'instance courante.
		 *
		 * @param	toIntersect	un objet <code>Rectangle</code> à tester
		 * @return	<code>true</code> si le rectangle <code>toIntersect</code> entrecroise
		 * 			l'instance courante
		 */
		override public function intersects ( toIntersect : Rectangle ) : Boolean
		{
			return intersectGeometry( new Rectangle2(toIntersect) );
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
		override public function contains (x : Number, y : Number) : Boolean
		{
			return containsPoint( pt(x, y) );
		}
		/**
		 * @inheritDoc
		 */
		override public function containsPoint (point : Point) : Boolean
		{
			point = PointUtils.rotateAround( point, topLeft, -rotation );
			return point.x >= x &&
				   point.x <= x + width &&
				   point.y >= y &&
				   point.y <= y + height;
		}
		/**
		 * @inheritDoc
		 */
		public function containsGeometry ( geom : Geometry ) : Boolean
		{
			return GeometryUtils.surfaceContainsGeometry(this, geom);
		}
		/**
		 * Affecte la valeur <code>0</code> à toutes les propriétés de cet instance.
		 */
		override public function setEmpty () : void
		{
			super.setEmpty ();
			rotation = 0;
		}
		/**
		 * Renvoie une copie parfaite de cet objet <code>Rectangle2</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>Rectangle2</code>
		 */
		override public function clone () : Rectangle
		{
			return new Rectangle2(x, y, width, height, rotation, pathBasedOnLength);
		}
		/**
		 * @inheritDoc
		 */
		public function draw (g : Graphics, c : Color) : void
		{
			var p1 : Point = topLeft;			var p2 : Point = topRight;			var p3 : Point = bottomRight;			var p4 : Point = bottomLeft;

			g.lineStyle(0, c.hexa, c.alpha/255 );
			g.moveTo(p1.x, p1.y);			g.lineTo(p2.x, p2.y);			g.lineTo(p3.x, p3.y);			g.lineTo(p4.x, p4.y);			g.lineTo(p1.x, p1.y);			g.lineStyle();
		}
		/**
		 * @inheritDoc
		 */
		public function fill ( g : Graphics, c : Color ) : void
		{
			var p1 : Point = topLeft;
			var p2 : Point = topRight;
			var p3 : Point = bottomRight;
			var p4 : Point = bottomLeft;

			g.beginFill( c.hexa, c.alpha/255 );
			g.moveTo(p1.x, p1.y);
			g.lineTo(p2.x, p2.y);
			g.lineTo(p3.x, p3.y);
			g.lineTo(p4.x, p4.y);
			g.lineTo(p1.x, p1.y);
			g.endFill();
		}
		/**
		 * Renvoie <code>true</code> si cette instance et l'instance <code>toCompare</code>
		 * sont égales.
		 * <p>
		 * Si <code>toCompare</code> est une instance de la classe <code>Rectangle</code>
		 * les deux instances seront égales si leur positions et leur tailles sont égales
		 * et si la rotation de l'instance courante est égale à <code>0</code>.
		 * </p>
		 * <p>
		 * Si <code>toCompare</code> est une instance de la classe <code>Rectangle2</code>
		 * les deux instances seront égales si leur positions, leur tailles et leur
		 * rotation sont égales.
		 * </p>
		 *
		 * @param	toCompare	instance de la classe <code>Rectangle</code> ou de la classe
		 * 						<code>Rectangle2</code> à comparer.
		 * @return	<code>true</code> si cette instance et l'instance <code>toCompare</code>
		 * 			sont égales
		 */
		override public function equals ( toCompare : Rectangle ) : Boolean
		{
			if( toCompare is Rectangle2 )
				return super.equals ( toCompare ) && ( toCompare as Rectangle2 ).rotation == rotation;
			else
				return super.equals ( toCompare ) && rotation == 0;
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
			return StringUtils.tokenReplace("new $0($1,$2,$3,$4,$5,$6)",
					   getQualifiedClassName(this),
					   x,
					   y,
					   width,
					   height, rotation, pathBasedOnLength );
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return	la représentation de l'objet sous forme de chaîne
		 */
		override public function toString () : String 
		{
			return StringUtils.stringify(this,{ x:x, y:y, width:width, height:height, rotation:rotation } );
		}
	}
}
