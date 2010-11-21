/**
 * @license
 */
package  aesia.com.mon.utils
{
	import aesia.com.mon.geom.Dimension;

	import flash.geom.Point;

	/**
	 * Classe utilitaire contenant des fonctions mathématique avancées.
	 *
	 * @author	Cédric Néhémie
	 */
	public final class MathUtils
	{
		/**
		 * Constante contenant la valeur de <code>π</code> multiplié par deux.
		 */
		static public const PI2 : Number = Math.PI * 2;
		/**
		 * Constante contenant la valeur de <code>π</code>.
		 */		static public const PI : Number = Math.PI;
		/**
		 * Convertie un angle en degrés dans son équivalent en radians.
		 *
		 * @param	a	l'angle en degrés
		 * @return	un angle en radians
		 */
		static public function deg2rad ( a : Number ) : Number
		{
			return a * Math.PI / 180;
		}
		/**
		 * Convertie un angle en radians dans son équivalent en degrés.
		 *
		 * @param	a	l'angle en radians
		 * @return	un angle en degrés
		 */
		static public function rad2deg ( a : Number ) : Number
		{
			return a * 180 / Math.PI;
		}
		/**
		 * Convertie un entier en une position dans une grille de taille
		 * <code>gridSize</code>.
		 *
		 * @param	i			index à convertir en coordonnées
		 * @param	gridSize	la taille de la grille
		 * @return	les coordonnées correspondantes à l'index dans la grille
		 */
		static public function id2pos( i : Number, gridSize : Dimension ) : Point
		{
			var sx:Number = gridSize.width;
			var x:Number = i % sx;
			var y:Number = ( i - x ) / sx;
			return new Point( x, y );
		}
		/**
		 * Convertie un entier en une position dans une grille de longueur
		 * <code>width</code>.
		 *
		 * @param	i		index à convertir en coordonnées
		 * @param	width	la longueur de la grille
		 * @return	les coordonnées correspondantes à l'index dans la grille
		 */
		static public function id2posWH( i : Number, width : Number ) : Point
		{
			var sx:Number = width;
			var x:Number = i % sx;
			var y:Number = ( i - x ) / sx;
			return new Point( x, y );
		}
		/**
		 * Convertie des coordonnées au sein d'une grille en une valeur
		 * d'index.
		 *
		 * @param	p			les coordonnées à convertir
		 * @param	gridSize	la taille de la grille
		 * @return	un index correspondant aux coordonnées dans la grille
		 */
		static public function pos2id( p : Point, gridSize : Dimension ) : Number
		{
			var sx:Number = gridSize.width;
			return p.y * sx + p.x;
		}
		/**
		 * Convertie des coordonnées au sein d'une grille en une valeur
		 * d'index.
		 *
		 * @param	x			coordonnée en x
		 * @param	y			coordonnée en y
		 * @param	gridSize	la taille de la grille
		 * @return	un index correspondant aux coordonnées dans la grille
		 */
		static public function pos2idXY ( x : Number, y : Number, gridSize : Dimension ) : Number
		{
			var sx:Number = gridSize.width;
			return y * sx + x;
		}
		/**
		 * Convertie des coordonnées au sein d'une grille en une valeur
		 * d'index.
		 *
		 * @param	x		coordonnée en x
		 * @param	y		coordonnée en y
		 * @param	width	la longueur de la grille
		 * @return	un index correspondant aux coordonnées dans la grille
		 */
		static public function pos2idXYW ( x : Number, y : Number, width : Number ) : Number
		{
			var sx:Number = width;
			return y * sx + x;
		}
		/*
		 * ARITHMETIC METHODS
		 */
		/**
		 * Renvoie la valeur dans la suite de Fibonnacci située
		 * à la position <code>n</code>.
		 *
		 * @param	n	position de la valeur dans la suite
		 * @return	la valeur dans la suite de Fibonnacci située
		 * 			à la position correspondante
		 */
		static public function fibonnacci ( n : uint ) : uint
		{
			var i : uint;
			var j : uint;			var k : uint;			var l : uint;
			for(i=0, j=1, k=0, l=0; k < n; k++, l=j+i, j=i, i=l){}
			return l;
		}
		/**
		 * Renvoie la valeur factorielle de l'entier <code>n</code>.
		 *
		 * @param	n	valeur pour laquelle calculée la valeur factorielle
		 * @return	la valeur factorielle de l'entier
		 */
		static public function factorial( n : uint ) : uint
		{
		    if(!n)
		        return 1;
		    else
		        return n * factorial( n - 1 );
		}
		/**
		 * Renvoie le nombre de possibilités tel que pour un ensemble de possibilités
		 * <code>a</code> on a <code>b</code> choix successifs à effectuer.
		 * <p>
		 * Ce calcul est différent de la fonction <code>factorial</code> en cela qu'un
		 * choix effectué lors du choix numéro un est toujours possible lors du choix
		 * numéro deux.
		 * </p>
		 * @param	a	nombre de possililité du choix
		 * @param	b	nombre de choix
		 * @return	le nombre de possibilités tel que pour un ensemble de possibilités
		 * 			<code>a</code> on a <code>b</code> choix successifs à effectuer
		 */
		static public function possibilities ( a : Number, b : Number ) : Number
		{
			if( b == 0)
				return 0;

			var n : Number = 0;
			var i : uint;
			for( i=1; i<=b; i++ )
			{
				n+= Math.pow( a, i );
			}
			return n;
		}
		/**
		 * Renvoie la valeur <code>value</code> contrainte dans la plage <code>min-max</code>.
		 *
		 * @param	value	la valeur à contraindre
		 * @param	min		la valeur minimum de la plage de contrainte
		 * @param	max		la valeur maximum de la plage de contrainte
		 */
		static public function restrict( value : Number, min : Number, max : Number ) : Number
		{
			return Math.min( Math.max( value, min ), max );
		}
		/**
		 * Renvoie la valeur normalisée de <code>value</code> dans la plage
		 * <code>minimum-maximum</code>.
		 *
		 * @param	value	la valeur à normalisée
		 * @param	minimum	la valeur minimum de la plage de normalisation		 * @param	maximum	la valeur maximum de la plage de normalisation
		 * @return	la valeur normalisée de <code>value</code> dans la plage
		 * 			<code>minimum-maximum</code>
		 */
		static public function normalize( value : Number,
										  minimum : Number,
										  maximum : Number) : Number
        {
            return (value - minimum) / (maximum - minimum);
        }
        /**
         * Renvoie la valeur dans la plage <code>minimum-maximum</code>
         * correspondant à la valeur normalisée <code>normValue</code>.
         *
         * @param	normValue	valeur normalisée
         * @param	minimum		valeur minimum de la plage
         * @param	maximum		valeur maximum de la plage
         * @return	la valeur dans la plage <code>minimum-maximum</code>
         * 			correspondant à la valeur normalisée <code>normValue</code>
         */
        static public function interpolate( normValue : Number,
        									minimum : Number,
        									maximum : Number) : Number
        {
            return minimum + (maximum - minimum) * normValue;
        }
        /**
         * Convertie la valeur <code>value</code> de la plage <code>min1-max1</code>
         * dans son équivalent dans la plage <code>min2-max2</code>.
         *
         * @param	value	valeur de la plge d'origine
         * @param	min1	valeur minimum de la plage d'origine
         * @param	max1	valeur maximum de la plage d'origine
         * @param	min2	valeur minimum de la plage cible
         * @param	max2	valeur maximum de la plage cible
         * @return	la valeur <code>value</code> convertie dans la plage <code>min2-max2</code>
         */
        static public function map( value : Number,
        							min1 : Number,
        							max1 : Number,
        							min2 : Number,
        							max2 : Number ) : Number
        {
            return interpolate( normalize(value, min1, max1), min2, max2);
        }
        /**
         * Renvoie soit <code>minimum</code> soit <code>maximum</code> selon
         * que <code>value</code> se situe plus près de l'un ou de l'autre.
         *
         * @param	value	valeur de référence
         * @param	minimum	valeur minimum
         * @param	maximum	valeur maximum
         * @return	soit <code>minimum</code> soit <code>maximum</code> selon
         * 			que <code>value</code> se situe plus près de l'un ou de l'autre
         */
        static public function clamp ( value : Number,
        							   minimum : Number,
        							   maximum : Number ) : Number
        {
        	return (value - minimum > maximum - value ) ? maximum : minimum ;
		}
		/**
		 * Renvoie la valeur de <code>sum( n )</code> tel que
		 * <code>sum( n ) = 1 - 1 / n</code>.
		 *
		 * @param	n	valeur pour laquelle récupérer la somme
		 * @return	la valeur de <code>sum( n )</code>
		 */
		static public function sum ( n : Number ) : Number
		{
			return 1 - 1 / n;
		}
		/**
		 * Renvoie la valeur maximum dans toutes les valeurs présentes
		 * dans <code>args</code>.
		 *
		 * @param	args	suite de valeur à tester
		 * @return	la valeur maximum dans toutes les valeurs présentes
		 * dans <code>args</code>
		 */
		static public function max ( ... args ) : Number
		{
			var n : Number = args[0];
			if( args.length > 1 )
			{
				for(var i : int = 1;i<args.length;i++)
					if( args[i] > n )
						n = args[i];
			}
			return n;
		}
		/**
		 * Renvoie la valeur minimum dans toutes les valeurs présentes
		 * dans <code>args</code>.
		 *
		 * @param	args	suite de valeur à tester
		 * @return	la valeur minimum dans toutes les valeurs présentes
		 * dans <code>args</code>
		 */
		static public function min ( ... args ) : Number
		{
			var n : Number = args[0];
			if( args.length > 1 )
			{
				for(var i : int = 1;i<args.length;i++)
					if( args[i] < n )
						n = args[i];
			}
			return n;
		}
		/**
		 * Fonction de tri permettant de trier des nombres de manière cohérente
		 * la où la fonction de tri de base les converties en chaîne avant de les
		 * trier. 
		 * 
		 * @param	a	premier nombre à comparer
		 * @param	b	second nombre à comparer
		 * @return	<code>1</code> si <code>a</code> doit être placé après <code>b</code>, 
		 * 			<code>-1</code> si c'est <code>b</code> qui doit être placé après
		 * 			<code>a</code> ou <code>0</code> si l'ordre des deux éléments ne change
		 * 			pas
		 */
		static public function numberSort( a : Number, b : Number ) : int
		{
			if( a > b )	
				return 1;
			else if( b > a )
				return -1;
			else
				return 0;
		}
		/**
		 * Fonction de tri permettant de trier des nombres de manière cohérente
		 * la où la fonction de tri de base les converties en chaîne avant de les
		 * trier. 
		 * <p>
		 * Les nombres sont triés de manière décroissante.
		 * </p>
		 * 
		 * @param	a	premier nombre à comparer
		 * @param	b	second nombre à comparer
		 * @return	<code>-1</code> si <code>a</code> doit être placé avant <code>b</code>, 
		 * 			<code>1</code> si c'est <code>b</code> qui doit être placé avant
		 * 			<code>a</code> ou <code>0</code> si l'ordre des deux éléments ne change
		 * 			pas
		 */
		static public function numberInvertSort( a : Number, b : Number ) : int
		{
			if( a > b )	
				return -1;
			else if( b > a )
				return 1;
			else
				return 0;
		}
	}
}