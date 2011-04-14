/**
 * @license
 */
package abe.com.mon.geom
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Copyable;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Serializable;
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
	 * The <code>Rectangle2</code> class extends the <code>Rectangle</code>
	 * class primarily to provide a rotation control on the rectangle.
	 * <p>
	 * Moreover, the class <code>Rectangle2</code> implement the <code>Geometry</code>
	 * <code>Surface</code> and <code>Path</code> interfaces as well as support for
	 * serialization as defined in the interface <code>Serializable</code>.
	 * </p> 
	 * <p>
	 * Most of the methods of the classes <code>Rectangle</code> has been rewritten
	 * to support the rotation. Only <code>union</code> and <code>intersection</code> 
	 * are not supported by the class <code>Rectangle2</code>.
	 * </p>
	 * <fr>
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
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Rectangle2 extends Rectangle implements Serializable,
														 Path,
														 Geometry,
														 ClosedGeometry,
														 Surface,
														 Randomizable,
														 Copyable
	{
		/**
		 * @copy abe.com.mon.core.Randomizable#randomSource
		 */
		protected var _randomSource : Random;
		/**
		 * A boolean value indicating whether the calculations 
		 * of a position in the path of this <code>Rectangle2</code>
		 * are based on the length of the perimeter or on the basis
		 * of the edges.
		 * <p>
		 * If the calculations are based on the edges, the path is
		 * divided as follows:
		 * </p>
		 * <ul>
		 * <li>From <code>0</code> to <code>0.25</code> the returned position is
		 * on the upper edge of the rectangle.</li>
		 * <li>From <code>0.25</code> to <code>0.5</code> the returned position is
		 * on the right stops the rectangle.</li>
		 * <li>From <code>0.5</code> to <code>0.75</code> the returned position is
		 * on the lower edge of the rectangle.</li>
		 * <li>From <code>0.75</code> to <code>1</code> the returned position is
		 * on the left edge of the rectangle.</li>
		 * </ul>
		 * <fr>
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
		 * </fr>
		 * @default true
		 */
		public var pathBasedOnLength : Boolean;
		/**
		 * Angle in radians of rotation of the object <code>Rectangle2</code>.
		 * <fr>
		 * Angle en radians de la rotation de cet objet <code>Rectangle2</code>.
		 * </fr>
		 */
		public var rotation : Number;
		/**
		 * <code>Rectangle2</code> class constructor
		 * <fr>
		 * Constructeur de la classe <code>Rectangle2</code>.
		 * </fr>
		 * @param	xOrRect				the x position of the rectangle or a <code>Rectangle</code> 
		 * 								used to initialize this instance
		 * 								<fr>la position en x de ce rectangle ou un objet <code>Rectangle</code>
		 * 								servant à initialiser cet instance</fr>
		 * @param	yOrRotation			y position of the rectangle or the rotation when the first argument
		 * 								is an object <code>Rectangle</code>
		 * 								<fr>position en y de ce rectangle ou la rotation lorsque le premier argument
		 * 								est un objet <code>Rectangle</code></fr>
		 * @param	width				width of the rectangle
		 * 								<fr>longueur de ce rectangle</fr>
		 * @param	height				height of the rectangle
		 * 								<fr>hauteur de ce rectangle</fr>
		 * @param	rotation			rotation of the rectangle
		 * 								<fr>rotation de ce rectangle</fr>
		 * @param	pathBasedOnLength	path computation is it based on the length
		 * 								of the perimeter of the rectangle?
		 * 								<fr>le calcul du chemin est-il basé
		 * 								sur la longueur du périmètre du
		 * 								rectangle ?</fr>
		 * @example	Create a new instance from a <code>Rectangle</code>:
		 * <fr>Création d'une nouvelle instance à partir d'un objet <code>Rectangle</code> :</fr>
		 * <listing>var r : Rectangle = new Rectangle( 50, 100, 200, 100 );
		 * var r2 : Rectangle2 = new Rectangle2( r, Math.PI / 4 );</listing>
		 * Create a new instance in a conventional manner:
		 * <fr>Création d'une nouvelle instance de manière classique :</fr>
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
		/**
		 * An object representing the vector of the upper edge.
		 * <fr>
		 * Un objet représentant le vecteur de l'arête supérieur.
		 * </fr>
		 */
		public function get topEdge () : Point { return pt( Math.cos( rotation ) * width,
															Math.sin( rotation ) * width );}
		/**
		 * An object representing the vector of the bottom edge.
		 * <fr>
		 * Un objet représentant le vecteur de l'arête inférieur.
		 * </fr>
		 */
		public function get bottomEdge () : Point { return topEdge; }
		/**
		 * An object representing the vector of the left edge.
		 * <fr>
		 * Un objet représentant le vecteur de l'arête gauche.
		 * </fr>
		 */
		public function get leftEdge () : Point { return pt( Math.cos( rotation + Math.PI / 2 ) * height,
															 Math.sin( rotation + Math.PI / 2 ) * height );}
		/**
		 * An object representing the vector of the right edge.
		 * <fr>
		 * Un objet représentant le vecteur de l'arête droite.
		 * </fr>
		 */
		public function get rightEdge () : Point { return leftEdge; }
		/**
		 * A <code>Point</code> representing the coordinates of the
		 * top left corner of this <code>Rectangle2</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin supérieur gauche de ce <code>Rectangle2</code>.
		 * </fr>
		 */
		override public function get topLeft () : Point { return pt(x,y ); }
		override public function set topLeft (value : Point) : void
		{
			x = value.x;
			y = value.y;
		}
		/**
		 * A <code>Point</code> representing the coordinates of the
		 * lower right corner of this <code>Rectangle2</code>.
		 * <p>
		 * Because of the support of the rotation of the rectangle,
		 * the writing access to this property has been disabled.
		 * </p>
		 * <fr>
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin inférieur droit de ce <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 * </fr>
		 */
		override public function get bottomRight () : Point { return pt(x,y).add( topEdge ).add( leftEdge ); }
		override public function set bottomRight (value : Point) : void {}
		/**
		 * A <code>Point</code> representing the coordinates of the
		 * top right corner of this <code>Rectangle2</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin supérieur droit de ce <code>Rectangle2</code>.
		 * </fr>
		 */
		public function get topRight () : Point { return pt(x,y).add( topEdge ); }
		/**
		 * A <code>Point</code> representing the coordinates of the
		 * bottom left corner of this <code>Rectangle2</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant les coordonnées
		 * du coin inférieur gauche de ce <code>Rectangle2</code>.
		 * </fr>
		 */		public function get bottomLeft () : Point { return pt(x,y).add( leftEdge ); }
		/**
		 * The coordinate on the y-axis of the highest point
		 * of this <code>Rectangle2</code>.
		 * <p>
		 * Because of the support of the rotation of the rectangle,
		 * the writing access to this property has been disabled.
		 * </p>
		 * <fr>
		 * La coordonnée sur l'axe y du point le plus haut de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 * </fr>
		 */
		override public function get top () : Number { return MathUtils.min( y,
																			 topRight.y,
																			 bottomLeft.y,
																			 bottomRight.y ); }
		override public function set top (value : Number) : void {}
		/**
		 * The coordinate on the y-axis of the lowest point
		 * of this <code>Rectangle2</code>.
		 * <p>
		 * Because of the support of the rotation of the rectangle,
		 * the writing access to this property has been disabled.
		 * </p>
		 * <fr>
		 * La coordonnée sur l'axe y du point le plus bas de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 * </fr>
		 */
		override public function get bottom () : Number { return MathUtils.max(  y,
																				 topRight.y,
																				 bottomLeft.y,
																				 bottomRight.y ); }
		override public function set bottom (value : Number) : void {}
		/**
		 * The coordinate on the x-axis of the furthest point on left
		 * of this <code>Rectangle2</code>.
		 * <p>
		 * Because of the support of the rotation of the rectangle,
		 * the writing access to this property has been disabled.
		 * </p>
		 * <fr>
		 * La coordonnée sur l'axe x du point le plus à gauche
		 * de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 * </fr>
		 */
		override public function get left () : Number { return MathUtils.min( x,
																			 topRight.x,
																			 bottomLeft.x,
																			 bottomRight.x ); }
		override public function set left (value : Number) : void {}
		/**
		 * The coordinate on the x-axis of the furthest point on right
		 * of this <code>Rectangle2</code>.
		 * <p>
		 * Because of the support of the rotation of the rectangle,
		 * the writing access to this property has been disabled.
		 * </p>
		 * <fr>
		 * La coordonnée sur l'axe x du point le plus à droite de cet objet <code>Rectangle2</code>.
		 * <p>
		 * Du fait du support de la rotation du rectangle, la fonction
		 * d'écriture de cette propriété a été désactivé.
		 * </p>
		 * </fr>
		 */
		override public function get right () : Number { return MathUtils.max( x,
																			 topRight.x,
																			 bottomLeft.x,
																			 bottomRight.x ); }
		override public function set right (value : Number) : void {}
		/**
		 * @inheritDoc
		 */
		public function get length () : Number { return width * 2 + height * 2; }
		/**
		 * A <code>Point</code> representing the center
		 * of this <code>Rectangle2</code>.
		 * <fr>
		 * Un objet <code>Point</code> représentant le centre
		 * de cet objet <code>Rectangle2</code>.
		 * </fr>
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
		 * A <code>Point</code> representing the center of the upper edge.
		 * <fr>
		 * Un objet <code>Point</code> représentant le centre de l'arrête supérieure.
		 * </fr>
		 */
		public function get topEdgeCenter () : Point { return topLeft.add( PointUtils.scaleNew( topEdge, .5 ) ); }
		/**
		 * A <code>Point</code> representing the center of the lower edge.
		 * <fr>
		 * Un objet <code>Point</code> représentant le centre de l'arrête inférieure.
		 * </fr>
		 */		public function get bottomEdgeCenter () : Point { return bottomLeft.add( PointUtils.scaleNew( bottomEdge, .5 ) ); }
		/**
		 * A <code>Point</code> representing the center of the left edge.
		 * <fr>
		 * Un objet <code>Point</code> représentant le centre de l'arrête de gauche.
		 * </fr>
		 */		public function get leftEdgeCenter () : Point { return topLeft.add( PointUtils.scaleNew( leftEdge, .5 ) ); }
		/**
		 * A <code>Point</code> representing the center of the right edge.
		 * <fr>
		 * Un objet <code>Point</code> représentant le centre de l'arrête de droite.
		 * </fr>
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
		 * @inheritDoc
		 */
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void { _randomSource = randomSource; }
		/**
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
			return topLeft.add( PointUtils.scaleNew( topEdge, _randomSource.random() ) )
						  .add( PointUtils.scaleNew( leftEdge, _randomSource.random() ) );
		}
		/**
		 * @inheritDoc
		 */
		public function getPointAtAngle (a : Number) : Point
		{
			var s : Point = center;
			var e : Point = s.add(pt(Math.cos(a)*10000,Math.sin(a)*10000));
			
			return GeometryUtils.vectorGeomIntersection( s, e, this )[0];
		}
		/**
		 * Rotates this object <code>Rectangle2</code> around its center
		 * by an angle of <code>r</code> radians.
		 * <fr>
		 * Effectue une rotation de cet objet <code>Rectangle2</code> autour
		 * de son centre d'un angle de <code>r</code> radians.
		 * </fr>
		 * @param	r	angle of rotation to perform
		 * 				<fr>angle de la rotation à effectuer</fr>
		 */
		public function rotateAroundCenter ( r : Number ) : void
		{
			var p : Point = PointUtils.rotateAround( topLeft, center, r);

			rotation += r;
			topLeft = p;
		}
		/**
		 * Resize the rectangle evenly around the center of it.
		 * <fr>
		 * Redimensionne le rectangle de manière régulière autour du centre
		 * de ce dernier.
		 * </fr>
		 * @param	s	scale factor of this rectangle
		 * 				<fr>facteur de redimensionnement de ce rectangle</fr>
		 */
		public function scaleAroundCenter ( s : Number ) : void
		{
			var c : Point = center;
			width *= s;
			height *= s;
			center = c;
		}
		/**
		 * Resize the rectangle around the center of it.
		 * <fr>
		 * Redimensionne le rectangle autour du centre
		 * de ce dernier.
		 * </fr>
		 * @param	dx	increment on the X axis
		 * 				<fr>incrément sur l'axe X</fr>		 * @param	dy	increment on the Y axis
		 * 				<fr>incrément sur l'axe Y</fr>
		 */
		public function inflateAroundCenter ( dx : Number, dy : Number ) : void
		{
			var c : Point = center;
			width += dx;
			height += dy;
			center = c;
		}
		/**
		 * Increases the size of this rectangle by the values
		 * of <code>dx</code> and <code>dy</code> without changing 
		 * its center.
		 * <fr>
		 * Accroit la taille de ce rectangle par les valeurs de <code>dx</code>
		 * et <code>dy</code> sans que le centre de celui-ci ne soit modifié.
		 * </fr>
		 * @param	dx	value to add to the width of the rectangle. 
		 * 				The following formula is used to calculate 
		 * 				the new width: <listing>width += dx &#42; 2;</listing>
		 * 				<fr>une valeur à ajouter à la longueur de ce rectangle.
		 * 				La formule suivante est utilisée pour calculer la nouvelle
		 * 				longueur : <listing>width += dx &#42; 2;</listing></fr>
		 * @param	dy	value to add to the height of the rectangle. 
		 * 				The following formula is used to calculate 
		 * 				the new height: <listing>height += dy &#42; 2;</listing>
		 * 				<fr>une valeur à ajouter à la hauteur de ce rectangle.
		 * 				La formule suivante est utilisée pour calculer la nouvelle
		 * 				longueur : <listing>height += dy &#42; 2;</listing></fr>
		 */
		override public function inflate ( dx : Number, dy : Number ) : void
		{
			var c : Point = center;
			width += dx*2;
			height += dy*2;
			center = c;
		}
		/**
		 * Increases the size of this rectangle on the left by the value
		 * of <code>d</code>.
		 * 
		 * @param	d	increment value 
		 */
		public function inflateLeft( d : Number ) : void
		{
			width += d;
			var dp : Point = topEdge;
			dp.normalize(d);
			PointUtils.scale(dp, -1 );
			topLeft = topLeft.add( dp );
		}
		/**
		 * Increases the size of this rectangle on the right by the value
		 * of <code>d</code>.
		 * 
		 * @param	d	increment value 
		 */
		public function inflateRight( d : Number ) : void
		{
			width += d;
		}
		/**
		 * Increases the size of this rectangle on the top by the value
		 * of <code>d</code>.
		 * 
		 * @param	d	increment value 
		 */
		public function inflateTop( d : Number ) : void
		{
			height += d;
			var dp : Point = leftEdge;
			dp.normalize(d);
			PointUtils.scale(dp, -1 );
			topLeft = topLeft.add( dp );
		}
		/**
		 * Increases the size of this rectangle on the bottom by the value
		 * of <code>d</code>.
		 * 
		 * @param	d	increment value 
		 */
		public function inflateBottom( d : Number ) : void
		{
			height += d;
		}
		/**
		 * Increases the size of this rectangle on the top left corner
		 * by the values of <code>dx</code> and <code>dy</code>
		 * 
		 * @param	dx	increment value on the x-axis		 * @param	dy	increment value on the y-axis
		 */
		public function inflateTopLeft( dx : Number, dy : Number ):void
		{
			inflateLeft( dx );
			inflateTop( dy );
		}
		/**
		 * Increases the size of this rectangle on the top right corner
		 * by the values of <code>dx</code> and <code>dy</code>
		 * 
		 * @param	dx	increment value on the x-axis
		 * @param	dy	increment value on the y-axis
		 */
		public function inflateTopRight( dx : Number, dy : Number ):void
		{
			inflateRight( dx );
			inflateTop( dy );
		}
		/**
		 * Increases the size of this rectangle on the bottom left corner
		 * by the values of <code>dx</code> and <code>dy</code>
		 * 
		 * @param	dx	increment value on the x-axis
		 * @param	dy	increment value on the y-axis
		 */
		public function inflateBottomLeft( dx : Number, dy : Number ):void
		{
			inflateLeft( dx );
			inflateBottom( dy );
		}
		/**
		 * Increases the size of this rectangle on the bottom right corner
		 * by the values of <code>dx</code> and <code>dy</code>
		 * 
		 * @param	dx	increment value on the x-axis
		 * @param	dy	increment value on the y-axis
		 */
		public function inflateBottomRight( dx : Number, dy : Number ):void
		{
			inflateRight( dx );
			inflateBottom( dy );
		}
		/**
		 * Increases the size of this rectangle by the values 
		 * contained in <code>point</code> without changing its center.
		 * <fr>
		 * Accroit la taille de ce rectangle par les valeurs contenues dans
		 * <code>point</code> sans que le centre de celui-ci ne soit modifié.
		 * </fr>
		 * @param	point	a <code>Point </code> containing values 
		 * 					of increment for the width and height of the rectangle
		 * 					<fr>un objet <code>Point</code> contenant les valeurs
		 * 					de modification de la longueur et de la hauteur de
		 * 					ce rectangle</fr>
		 */
		override public function inflatePoint ( point : Point ) : void
		{
			inflate(point.x*2, point.y*2);
		}
		/**
		 * This method is not supported by the class <code>Rectangle2</code>.
		 * <fr>
		 * Cette méthode n'est pas supportée par la classe <code>Rectangle2</code>.
		 * </fr>
		 */
		override public function union ( toUnion : Rectangle ) : Rectangle
		{
			return null;
		}
		/**
		 * This method is not supported by the class <code>Rectangle2</code>.
		 * <fr>
		 * Cette méthode n'est pas supportée par la classe <code>Rectangle2</code>.
		 * </fr>
		 */
		override public function intersection ( toIntersect : Rectangle ) : Rectangle
		{
			return null;
		}
		/**
		 * Returns <code>true</code> if the rectangle <code>toIntersect</code>
		 * intersects the current instance.
		 * <fr>
		 * Renvoie <code>true</code> si le rectangle <code>toIntersect</code> entrecroise
		 * l'instance courante.
		 * </fr>
		 * @param	toIntersect	a <code>Rectangle</code> to test
		 * 						<fr>un objet <code>Rectangle</code> à tester</fr>
		 * @return	<code>true</code> if the rectangle <code>toIntersect</code>
		 * 			intersects the current instance
		 * 			<fr><code>true</code> si le rectangle <code>toIntersect</code> entrecroise
		 * 			l'instance courante</fr>
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
		 * Affects the value <code>0</code> to all the properties of this instance.
		 * <fr>
		 * Affecte la valeur <code>0</code> à toutes les propriétés de cet instance.
		 * </fr>
		 */
		override public function setEmpty () : void
		{
			super.setEmpty ();
			rotation = 0;
		}
		/**
		 * @copy abe.com.mon.core.Cloneable#clone()
		 */
		override public function clone () : Rectangle
		{
			return new Rectangle2(x, y, width, height, rotation, pathBasedOnLength);
		}
		/**
		 * @inheritDoc
		 */
		public function copyTo (o : Object) : void
		{
			o["x"] = x;			o["y"] = y;			o["width"] = width;			o["height"] = height;			o["rotation"] = rotation;
		}
		/**
		 * @inheritDoc
		 */
		public function copyFrom (o : Object) : void
		{
			x = o["x"];			y = o["y"];			width = o["width"];			height = o["height"];			rotation = o["rotation"];
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
		 * Returns <code>true</code> if this instance and the instance <code>toCompare</code>
		 * are equal.
		 * <p>
		 * If <code>toCompare</code> is an instance of the class <code>Rectangle</code> 
		 * both instances are equal if their positions and their sizes are equal 
		 * and if the rotation of the current instance is equal to <code>0</code>.
		 * </p> 
		 * <p>
		 * If <code>toCompare</code> is an instance of the class <code>Rectangle2</code> 
		 * both instances are equal if their positions, their sizes and their 
		 * rotation are equal.
		 * </p>
		 * <fr>
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
		 * </fr>
		 * @param	toCompare	instance of the class <code>Rectangle</code> or class
		 * 						<code>Rectangle2</code> to compare
		 * 						<fr>instance de la classe <code>Rectangle</code> ou de la classe
		 * 						<code>Rectangle2</code> à comparer</fr>
		 * @return	<code>true</code> if this instance and the instance <code>toCompare</code>
		 * 			are equal
		 * 			<fr><code>true</code> si cette instance et l'instance <code>toCompare</code>
		 * 			sont égales</fr>
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
		 * @copy Dimension#toString()
		 */
		override public function toString () : String 
		{
			return StringUtils.stringify(this,{ x:x, y:y, width:width, height:height, rotation:rotation } );
		}
	}
}
