/**
 * @license
 */
package abe.com.edia.bitmaps
{
	import abe.com.mon.utils.PointUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * La classe <code>BitmapCollider</code> compose un objet <code>BitmapData</code>
	 * et le transforme en un support pour des calculs de collision.
	 * <p>
	 * La classe fournit deux types de calculs de collision sur bitmaps :
	 * <ol>
	 * <li>Un calcul à base de lancer de rayon.</li>
	 * <li>Un calcul à base de boîte englobante et de comparaison de pixels.</li>
	 * </ol>
	 * </p>
	 *
	 * @author Cédric Néhémie
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/display/BitmapData.html BitmapData
	 */
	public class BitmapCollider
	{
		/**
		 * Seuil de détection de collision pour un pixel. Le seuil par défaut considère
		 * tout pixel dont la valeur d'alpha est inférieure à <code>0xcc</code> comme
		 * transparent, et donc ignoré dans la detection de collision.
		 *
		 * @default 0xcc000000
		 */
		protected var _threshold : uint = 0xcc000000;
		/**
		 * Masque binaire pour le calcul des collisions.
		 *
		 * @default 0xff000000
		 */
		protected var _bitmask : uint = 0xff000000;
		/**
		 * Une valeur booléenne indiquant si la recherche de tangentes est
		 * faite en profondeur ou non. Lorsque la recherche est faite en profondeur
		 * on ne prend pas en compte les deux pixels limitrof voisin du pixel de
		 * référence, mais les deux voisins des deux voisins, afin de gagner en précisions
		 * dans le calculs de l'angle de la tangente.
		 *
		 * @default true
		 */
		protected var _deepTangentSearch : Boolean;
		/**
		 * L'objet <code>BitmapData</code> sur lequel est effectuée les calculs de collisions.
		 */
		protected var _bitmap : BitmapData;

		/**
		 * Créer un nouvel objet <code>BitmaCollider</code> pour <code>bitmap</code>.
		 * <p>
		 * Par défaut, à sa création, la propriété <code>deepTangentSearch</code> est à
		 * <code>true</code>.
		 * </p>
		 * @param	bitmap	la cible de l'objet <code>BitmapCollider</code>
		 */
		public function BitmapCollider ( bitmap : BitmapData )
		{
			_bitmap = bitmap;
			_deepTangentSearch = true;
		}

		/**
		 * L'objet <code>BitmapData</code> sur lequel l'objet courant travaille.
		 */
		public function get bitmap () : BitmapData { return _bitmap; }
		public function set bitmap ( bitmap : BitmapData ) : void
		{
			_bitmap = bitmap;
		}

		/**
		 * Un entier figurant le seuil à partir duquel un pixel est considérer
		 * comme opaque.
		 */
		public function get threshold () : uint	{ return _threshold; }
		public function set threshold ( threshold : uint ) : void
		{
			_threshold = threshold;
		}

		/**
		 * Masque binaire utilisé pour isoler les composantes lors des calculs
		 * d'opacité d'un pixel.
		 */
		public function get bitmask () : uint { return _bitmask; }
		public function set bitmask ( bitmask : uint ) : void
		{
			_bitmask = bitmask;
		}

		/**
		 * Un <code>Boolean</code> déterminant si les calculs de tangentes sont effectués
		 * sur les voisins direct d'un pixel (<code>deepTangentSearch=false</code>) ou sur
		 * les voisins des voisins du pixel (<code>deepTangentSearch=true</code>).
		 */
		public function get deepTangentSearch () : Boolean { return _deepTangentSearch;	}
		public function set deepTangentSearch ( deepTangentSearch : Boolean ) : void
		{
			_deepTangentSearch = deepTangentSearch;
		}

		/**
		 * Éxécute un lancer de rayon sur le bitmap courant de <code>a</code> en direction de <code>b</code>
		 * et renvoie un tableau contenant toutes les coordonnées constituant la trajectoire du rayon.
		 * <p>
		 * Si aucune collision ne se produit entre <code>a</code> et <code>b</code> le tableau retourné ne
		 * contiendra que ces deux coordonnées.
		 * </p>
		 * <p>
		 * Le rayon final est censé faire approximativement la même longueur que le vecteur <code>ab</code>
		 * d'origine, cependant, étant donné que les calculs de tangentes sont effectués sur un bitmap, avec donc
		 * une perte non négligeable, il peut arriver qu'une tangente ne puisse être calculée, auquel cas, le
		 * rayon s'arrêtera à ce point précis et sera retourné en l'état.
		 * </p>
		 *
		 * @param	a		coordonnées de départ du rayon
		 * @param	b		coordonnées déterminant la direction du rayon par rapport à <code>start</code>
		 * @param	depth	nombre de rebonds effectués avant le retour du résultat
		 * @return	un tableau contenant les coordonnées des points de collisions
		 * @see #intersect()
		 * @see #isEmpty()
		 * @see	#getTangent()
		 */
		public function castRay ( a : Point, b : Point, depth : uint = 0 ) : Array
		{
			var n : Number = 0;
			var ar : Array = [a];
			var dist : Number = Point.distance(a, b);

			while( n++ <= depth )
			{
				var pt : Point = intersect( a, b );

				if( pt )
				{
					var tangeant : Number = getTangent( pt.x, pt.y, _deepTangentSearch );

					// special case for when we can't compute the tangeant
					if( isNaN( tangeant ) )
						return ar.concat( pt );

					var v1:Point = pt.subtract(a);
					var v2 : Point = PointUtils.reflect( v1, new Point( Math.sin( tangeant ), Math.cos( tangeant ) ) );

					dist -= Point.distance(a, pt);

					v2.normalize(dist);
					a = pt.clone();
					ar.push( pt );
					b = new Point( pt.x - v2.x, pt.y - v2.y );
				}
				else
					return ar.concat( b );
			}
			return ar;
		}
		/**
		 * Renvoie les coordonnées du premier point d'intersection entre le vecteur
		 * <code>ab</code> et le bitmap courant. Si aucune intersection n'est trouvée,
		 * la fonction renvoie la valeur <code>null</code>.
		 * <p>
		 * Le processus de calcul est effectué point par point, c'est-à-dire que l'on
		 * confronte chaque pixel sur la trajectoire du vecteur à l'aide de la méthode
		 * <code>isEmpty</code>
		 * </p>
		 *
		 * @param	a	point d'origine du segment à confronter
		 * @param	b	point de destination du segment à confronter
		 * @return	un objet point correspondant aux coordonnées d'intersection
		 * 			ou <code>null</code> si aucune intersection se produit
		 * @see #isEmpty()
		 */
		public function intersect ( a : Point, b : Point ) : Point
		{
			var pt : Point = a.clone();
			var step : Point = b.subtract(a);
			var collide : Boolean = false;
			var dist : Number = Point.distance(a, b);
			var curDist : Number = 0;
			var stepDist : Number;
			var x1 : Number, x2 : Number, y1 : Number, y2 : Number;

			step.normalize(1);
			stepDist = step.length;

			pt.x += step.x * 4;
			pt.y += step.y * 4;

			while( !collide )
			{
				x1 = Math.floor(pt.x);
				x2 = Math.ceil(pt.x);

				y1 = Math.floor(pt.y);
				y2 = Math.ceil(pt.y);

				if( !isValidCoordinates(x1, y1) ||
					!isValidCoordinates(x2, y2 ) )
					return null;

				collide = !isEmpty(x1, y1);
				if( collide )
					return new Point(x1,y1);

				collide = !isEmpty(x2, y2);
				if( collide )
					return new Point(x2,y2);

				pt.x += step.x;
				pt.y += step.y;

				curDist += stepDist;
				if( curDist > dist )
					return null;
			}
			return pt;
		}
		/**
		 * Renvoie <code>true</code> si le pixel aux coordonnées <code>x</code> et <code>y</code>
		 * est jugé transparent au regard des paramètres de l'objet courant.
		 * <p>
		 * La formule utilisée pour déterminer si un pixel est transparent est la suivante :
		 * </p>
		 * <listing>( bmp.getPixel32(x,y) &#38; mask ) &lt;= threshold</listing>
		 * <p>
		 * Où <code>mask</code> permet d'isoler un canal particulier, et <code>threshold</code>
		 * un seuil en dessous duquel le pixel est considéré comme transparent.
		 * </p>
		 *
		 * @param	x	coordonnée en x du pixel à tester
		 * @param	y	coordonnée en y du pixel à tester
		 * @return	<code>true</code> si le pixel est jugé transparent au regard des paramètres
		 * 			de l'objet courant, <code>false</code> autrement
		 */
		public function isEmpty( x : Number, y : Number ) : Boolean
		{
			return uint( _bitmap.getPixel32( x, y ) & _bitmask ) <= _threshold;
		}

		/**
		 * Calcule et renvoie la tangente au point <code>(x,y)</code> si il est possible de le calculer.
		 * <p>
		 * La tangente est calculée en recherchant autour des coordonnées passées en paramètres en recherchant
		 * deux pixels opaques placés à la frontière opacité/transparence, puis en calculant l'angle de la
		 * droite passant par ces deux pixels.
		 * </p>
		 * <p>
		 * Si le paramètre <code>deepTangentSearch</code> est à <code>true</code>, la recherche de pixels à
		 * la frontière sera étendue au couple de voisin du pixel de référence afin de gagner en précision
		 * et en finesse.
		 * </p>
		 *
		 * @param	x					coordonnée en X du pixel pour lequel on souhaite trouver la tangente
		 * @param	y					coordonnée en Y du pixel pour lequel on souhaite trouver la tangente
		 * @param	deepTangentSearch	si <code>true</code> la recherche est poursuivie au dela des deux voisins
		 * 								direct des coordonnées du piexl de référence
		 * @return	l'angle de la tangente au point <code>x,y</code> si il est possible de la calculer, autrement
		 * 			<code>null</code>
		 */
		public function getTangent( x : Number, y : Number, deepTangentSearch : Boolean = false ) : Number
		{
			var pt1 : Point;
			var pt2 : Point;
			var pt3 : Point;
			var pt4 : Point;


			if( !( pt1 = getContiguPoint( x, y, -1, -1 ) ) )
				//return 0;				return NaN;

			if( !( pt2 = getContiguPoint( x, y, pt1.x, pt1.y ) ) )
				pt2 = new Point(x,y);

			if( !deepTangentSearch )
				return Math.atan2( pt2.x-pt1.x, pt2.y-pt1.y );

			if( !( pt3 = getContiguPoint( pt1.x, pt1.y, x, y, pt2.x, pt2.y ) ) )
				pt3 = pt1;

			if( !( pt4 = getContiguPoint( pt2.x, pt2.y, x, y, pt1.x, pt1.y ) ) )
				pt4 = pt2;

			return Math.atan2( pt4.x-pt3.x, pt4.y-pt3.y );
		}

		/**
		 * Renvoie les coordonnées d'un pixel opaque, voisin de <code>(x,y)</code>, et situé à la frontière entre
		 * pixels opaques et pixels transparents.
		 * <p>
		 * Les paramètres  <code>badx</code> et <code>bady</code> ainsi que  <code>badx2</code> et <code>bady2</code>
		 * servent à exclure certaines coordonnées de la recherche, pour éviter de retourner des coordonnées déjà
		 * connue par exemple.
		 * </p>
		 * <p>
		 * La recherche est effectuée en parcourant les 8 voisins du pixel de référence dans le sens des aiguilles
		 * d'une montre.
		 * </p>
		 *
		 * @param	x		coordonnée en X du pixel de référence
		 * @param	y		coordonnée en Y du pixel de référence
		 * @param	badx	coordonnée en X d'un pixel à exclure de la recherche
		 * @param	bady	coordonnée en Y d'un pixel à exclure de la recherche
		 * @param	badx2	coordonnée en X d'un deuxième pixel à exclure de la recherche
		 * @param	bady2	coordonnée en Y d'un deuxième pixel à exclure de la recherche
		 * @return	un objet <code>Point</code> contenant les coordonnées d'un pixel frontalier
		 * 			et voisin du pixel de référence, ou <code>null</code> si aucun pixel
		 * 			ne peut être trouvé
		 * @see #isEmpty()
		 */
		public function getContiguPoint( x : Number,
										 y : Number,
										 badx : Number,
										 bady : Number,
										 badx2 : Number = -1,
										 bady2 : Number = -1 ) : Point
		{
			if( !isValidCoordinates(x+1, y) ||
				!isValidCoordinates(x-1, y) ||
				!isValidCoordinates(x, y+1) ||
				!isValidCoordinates(x, y-1) )
				return null;

			var pt : Point = new Point();

			//upper left pixel
			if( ( x-1 != badx2 || y-1 != bady2 ) &&
				( x-1 != badx || y-1 != bady ) )
			  	if( !isEmpty( x-1,y-1 ) &&
			  	  ( isEmpty( x-1,y ) ||
			  		isEmpty( x,y-1 ) ) )
				{
				    pt.x=x-1;
				    pt.y=y-1;
				    return pt;
				}

			//upper pixel
			if( ( x != badx2 || y-1 != bady2 ) &&
				( x != badx || y-1 != bady ) )
			  	if( !isEmpty( x,y-1 ) &&
			  	  ( isEmpty( x-1,y-1 ) ||
			  		isEmpty( x+1,y-1 ) ) )
				{
				    pt.x=x;
				    pt.y=y-1;
				    return pt;
				}

			//upper right pixel
			if( ( x+1 != badx2 || y-1 != bady2 ) &&
				( x+1 != badx || y-1 != bady ) )
			  	if( !isEmpty( x+1,y-1 ) &&
			  	  ( isEmpty( x,y-1 ) ||
			  		isEmpty( x+1,y ) ) )
				{
				    pt.x=x+1;
				    pt.y=y-1;
				    return pt;
				}

			//right pixel
			if( ( x+1 != badx2 || y != bady2 ) &&
				( x+1 != badx || y != bady ) )
			  	if( !isEmpty( x+1,y ) &&
			  	  ( isEmpty( x+1,y-1 ) ||
			  		isEmpty( x+1,y+1 ) ) )
				{
				    pt.x=x+1;
				    pt.y=y;
				    return pt;
				}
			//bottom right pixel
			if( ( x+1 != badx2 || y+1 != bady2 ) &&
				( x+1 != badx || y+1 != bady ))
			  	if( !isEmpty( x+1,y+1 ) &&
			  	  ( isEmpty( x+1,y ) ||
			  		isEmpty( x,y+1 ) ) )
				{
				    pt.x=x+1;
				    pt.y=y+1;
				    return pt;
				}
			//bottom pixel
			if( ( x != badx2 || y+1 != bady2 ) &&
				( x != badx || y+1 != bady ))
			  	if( !isEmpty( x,y+1 ) &&
			  	  ( isEmpty( x+1,y+1 ) ||
			  		isEmpty( x-1,y+1 ) ) )
				{
				    pt.x=x;
				    pt.y=y+1;
				    return pt;
				}
			//bottom left pixel
			if( ( x-1 != badx2 || y+1 != bady2 ) &&
				( x-1 != badx || y+1 != bady ))
			  	if( !isEmpty( x-1,y+1 ) &&
			  	  ( isEmpty( x-1,y+1 ) ||
			  		isEmpty( x,y+1 ) ) )
				{
				    pt.x=x-1;
				    pt.y=y+1;
				    return pt;
				}
			//left pixel
			if( ( x-1 != badx2 || y != bady2 ) &&
				( x-1 != badx || y != bady ) )
			  	if( !isEmpty( x-1,y ) &&
			  	  ( isEmpty( x-1,y-1 ) ||
			  		isEmpty( x-1,y+1 ) ) )
				{
				    pt.x=x-1;
				    pt.y=y;
				    return pt;
				}

			return null;
		}
		/**
		 * Renvoie <code>true</code> si les coordonnées transmises sont des coordonnées valide pour
		 * le bitmap courant. Autrement, la fonction renvoie <code>false</code>.
		 *
		 * @param	x	coordonnée en X du point dont on souhaite vérifier la validité
		 * @param	y	coordonnée en Y du point dont on souhaite vérifier la validité
		 * @return	<code>true</code> si les coordonnées transmises sont des coordonnées valide pour
		 * 			le bitmap courant, autrement, la fonction renvoie <code>false</code>
		 */
		public function isValidCoordinates ( x : Number, y : Number ) : Boolean
		{
			return x >= 0 && x < _bitmap.width && y >= 0 && y < _bitmap.height;
		}

		/**
		 * Renvoie un objet <code>Rectangle</code> correspondant à la zone d'intersection
		 * entre <code>target1</code> et <code>target2</code> situés respectivement aux
		 * coordonnées <code>pt1</code> et <code>pt2</code>.
		 * <p>
		 * La méthode utilisée pour déterminer la zone de contact se découpe en deux phases :
		 * <ol>
		 * <li>On compare les boîtes englobantes des deux bitmaps pour déterminer si on
		 * a besoin de rentrer dans la deuxième phase.</li>
		 * <li>On créer une image, correspondant à la zone de contact commune des boîtes
		 * englobantes, dans laquelle on dessine nos deux bitmaps de manière à obtenir une
		 * couleur spécifique pour les pixels se chevauchant entre les deux images, puis,
		 * à l'aide de la fonction <code>getColorBoundsRect</code> de la classe <code>BitmapData</code>
		 * on récupère le <code>Rectangle</code> englobant les pixels superposés.</li>
		 * </ol>
		 * </p>
		 *
		 * @param	target1		le 1er bitmap
		 * @param	pt1			coordonnées du 1er bitmap
		 * @param	target2		le 2ème bitmap
		 * @param	pt2			coordonnées du 2ème bitmap
		 * @param	tolerance	valeur entre 0 et 1 déterminant le seuil de transparence
		 * 						à partir duquel un pixel est considéré comme opaque
		 * @param	debugBitmap	un objet <code>BitmapData</code> utilisé pour visualiser
		 * 						la zone de couverture entre les deux bitmap pour des besoins
		 * 						de debuggage
		 * @return	un <code>Rectangle</code> représentant la zone de chevauchement entre les
		 * 			deux bitmaps, sinon renvoie <code>null</code> si aucune zone de chevauchement
		 * 			n'existe entre les deux bitmaps
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/display/BitmapData.html#getColorBoundsRect() BitmapData.getColorBoundsRect()
		 */
		static public function getCollisionRect( target1:BitmapData,
												 pt1 : Point,
												 target2:BitmapData,
												 pt2 : Point,
												 tolerance : Number = 0,
												 debugBitmap : Bitmap = null ) : Rectangle
		{
			var res : Rectangle;

			var rect1 : Rectangle = new Rectangle( pt1.x, pt1.y, target1.width, target1.height );
			var rect2 : Rectangle = new Rectangle( pt2.x, pt2.y, target2.width, target2.height );

			var isIntersecting : Boolean = rect1.intersects( rect2 );

			if ( isIntersecting )
			{
				var combinedrect : Rectangle = rect1.intersection( rect2 );
				var bmp : BitmapData = new BitmapData( combinedrect.width, combinedrect.height, true, 0x00000000 );

				bmp.draw( target1, getBitmapMatrix( pt1, combinedrect, rect1 ), new ColorTransform( 0,0,0,1,255, 0, 0, Math.round(tolerance*255) ) );				bmp.draw( target2, getBitmapMatrix( pt2, combinedrect, rect2 ), new ColorTransform( 0,0,0,1,255,255,255,Math.round(tolerance*255) ), BlendMode.DIFFERENCE );

				if ( tolerance > 1 )
					tolerance = 1;

				if ( tolerance < 0 )
					tolerance = 0;

				res = bmp.getColorBoundsRect( 0xffffffff, 0xff00ffff );
				res.x += combinedrect.x;
				res.y += combinedrect.y;

				if(debugBitmap)
					debugBitmap.bitmapData = bmp;

				return res;
			}
			return null;
		}

		/**
		 * Renvoie le centre du <code>Rectangle</code> résultant d'un appel à la
		 * méthode <code>getCollisionRect</code>.
		 *
		 * @param	target1		le 1er bitmap
		 * @param	pt1			coordonnées du 1er bitmap
		 * @param	target2		le 2ème bitmap
		 * @param	pt2			coordonnées du 2ème bitmap
		 * @param	tolerance	valeur entre 0 et 1 déterminant le seuil de transparence
		 * 						à partir duquel un pixel est considéré comme opaque
		 * @return	le centre du <code>Rectangle</code> résultant d'un appel à la
		 * 			méthode <code>getCollisionRect</code>
		 * @see #getCollisionRect()
		 */
		static public function getCollisionPoint( target1 : BitmapData,
												  pt1 : Point,
												  target2 : BitmapData,
												  pt2 : Point,
												  tolerance : Number = 0 ) : Point
		{
			var pt : Point;
			var collisionRect : Rectangle = getCollisionRect( target1, pt1, target2, pt2, tolerance );
			if ( collisionRect != null && collisionRect.size.length > 0 )
			{
				var xcoord : Number = ( collisionRect.left + collisionRect.right ) / 2;
				var ycoord : Number = ( collisionRect.top + collisionRect.bottom ) / 2;
				pt = new Point( xcoord, ycoord );
			}
			return pt;
		}

		/**
		 * Renvoie <code>true</code> si la méthode <code>getCollisionRect</code> renvoie un <code>Rectangle</code>,
		 * et <code>false</code> si le retour est <code>null</code>.
		 *
		 * @param	target1		le 1er bitmap
		 * @param	pt1			coordonnées du 1er bitmap
		 * @param	target2		le 2ème bitmap
		 * @param	pt2			coordonnées du 2ème bitmap
		 * @param	tolerance	valeur entre 0 et 1 déterminant le seuil de transparence
		 * 						à partir duquel un pixel est considéré comme opaque
		 * @return	<code>true</code> si la méthode <code>getCollisionRect</code> renvoie un <code>Rectangle</code>,
		 * 			et <code>false</code> si le retour est <code>null</code>
		 * @see #getCollisionRect()
		 */
		static public function isColliding( target1 : BitmapData, pt1 : Point, target2 : BitmapData, pt2 : Point, tolerance : Number = 0 ) : Boolean
		{
			var collisionRect : Rectangle = getCollisionRect( target1, pt1, target2, pt2, tolerance );
			if ( collisionRect != null && collisionRect.size.length > 0 )
				return true;
			else
				return false;
		}

		/**
		 * Renvoie un objet <code>Matrix</code> correspondant à la transformation nécessaire pour dessiner
		 * un bitmap, positionné à <code>pt</code> et dont la boîte englobante est <code>rect</code>, dans
		 * le rectangle <code>myRect</code>.
		 * <p>
		 * Cette fonction est utilisé par la méthode <code>getCollisionRect</code> lors de la phase de dessin
		 * des deux bitmaps afin de déterminer les pixels se chevauchant sur chaque bitmap.
		 * </p>
		 *
		 * @param pt		coordonnées du bitmap
		 * @param rect		boîte englobante du bitmap
		 * @param myrect	boîte englobante de la zone de dessin
		 * @return			un objet <code>Matrix</code> correspondant à la transformation nécessaire pour dessiner
		 * 					un bitmap dans <code>myRect</code>
		 * @see #getCollisionRect()
		 */
		static protected function getBitmapMatrix( pt : Point , rect : Rectangle, myrect : Rectangle ) : Matrix
		{
			var m : Matrix = new Matrix();
			var offX : Number = pt.x - myrect.x;
			var offY : Number = pt.y - myrect.y;
			var xpos : Number = myrect.x + offX - rect.x;
			var ypos : Number = myrect.y + offY - rect.y;
			m.translate( xpos, ypos );

			return m;
		}
	}
}
