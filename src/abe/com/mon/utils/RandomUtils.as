/**
 * @license
 */
package  abe.com.mon.utils
{
	
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.Range;
	import abe.com.mon.geom.pt;

	import flash.geom.Point;
	/**
	 * Classe utilitaire regroupant différentes méthodes de génération
	 * de valeurs aléatoires.
	 * <p>
	 * Certaines fonctions sont préfixées avec :
	 * <ul>
	 * <li><code>i…</code> lorsqu'elles renvoies un entier.</li>
	 * <li><code>s…</code> lorsqu'elles utilisent un algorithme de génération
	 * de nombres pseudo-aléatoires.</li>
	 * </ul>
	 * </p>
	 * <p>
	 * L'algorithme de génération de nombres pseudo-aléatoires utilisé est
	 * le Mersenne Twister.
	 * </p>
	 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
	 * @see MTRandom Classe MTRandom
	 * @see http://fr.wikipedia.org/wiki/Mersenne_Twister Mersenne Twister sur Wikipédia
	 * @see http://www.devslash.com/ Implémentation originale de l'algorithme Mersenne Twister d'après Matthew Lloyd
	 */
	public final class RandomUtils
	{
		static public var RANDOM : Random = new Random();
		
		/*----------------------------------------------------------*
		 * FLOAT METHODS
		 *----------------------------------------------------------*/
		/**
		 * Renvoie un nombre aléatoire entre <code>0</code> et <code>val</code>.
		 *
		 * @param	val	limite supérieur pour la valeur aléatoire
		 * @return	un nombre aléatoire entre <code>0</code> et <code>val</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function random ( val : Number = 1 ) : Number
		{
			return RANDOM.random( val );
		}
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>.
		 *
		 * @param	val	taille de la plage de valeur répartie équitablement de part et d'autre de 0
		 * @return	un nombre aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function balance ( val : Number = 2 ) : Number
		{
			return RANDOM.balance( val );
		}
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>r</code>.
		 *
		 * @param	r	plage de valeurs possible
		 * @return	un nombre aléatoire compris dans la plage <code>r</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function range ( r : Range ) : Number
		{
			return RANDOM.range ( r );
		}
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>a &lt; n &lt; b</code>.
		 *
		 * @param	a	borne inférieur de la plage des valeurs possible		 * @param	a	borne supérieur de la plage des valeurs possible
		 * @return	un nombre aléatoire compris dans la plage <code>a &lt; n &lt; b</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function rangeAB ( a : Number = 0, b : Number = 1 ) : Number
		{
			return RANDOM.rangeAB( a, b );
		}
		/**
		 * Renvoie un nouvel objet <code>Point</code> basé sur <code>p</code>dont les valeurs de
		 * <code>x</code> et de <code>y</code> ont été modifiées tel que :
		 * <listing>
		 * x += balance( rand )
		 * y += balance( rand )</listing>
		 *
		 * @param	p		un point de référence à tranformer aléatoirement
		 * @param	rand	la valeur de tranformation aléatoire tel que définie
		 * 					par la méthode <code>balance</code>
		 * @return 	un nouvel objet <code>Point</code> basé sur <code>p</code>dont les valeurs de
		 * 			<code>x</code> et de <code>y</code> ont été modifiées aléatoirement
		 * @see #balance()
		 */
		static public function point ( p : Point, rand : Number ) : Point
		{
			return RANDOM.point(p, rand);
		}
		/**
		 * Renvoie un objet <code>Point</code> contenant des coordonnées choisie aléatoirement
		 * dans l'espace définit par les paramètres transmis à cette fonction.
		 *
		 * @param	x	coordonnée en x du point supérieur gauche de la zone source		 * @param	y	coordonnée en y du point supérieur gauche de la zone source		 * @param	w	longueur de la zone source		 * @param	h	hauteur de la zone source
		 * @return	un objet <code>Point</code> contenant des coordonnées choisie aléatoirement
		 * 			dans l'espace définit par les paramètres transmis à cette fonction
		 */
		static public function pointInRange ( x : Number, y : Number, w : Number, h : Number ) : Point
		{
			return RANDOM.pointInRange(x, y, w, h);
		}
		/**
		 * Renvoie un nouvel objet <code>Dimension</code> basé sur <code>d</code>dont les valeurs de
		 * <code>width</code> et de <code>height</code> ont été modifiées tel que :
		 * <listing>
		 * width += balance( rand )
		 * height += balance( rand )</listing>
		 *
		 * @param	d		une dimension de référence à tranformer aléatoirement
		 * @param	rand	la valeur de tranformation aléatoire tel que définie
		 * 					par la méthode <code>balance</code>
		 * @return 	un nouvel objet <code>Dimension</code> basé sur <code>d</code>dont les valeurs de
		 * 			<code>width</code> et de <code>height</code> ont été modifiées aléatoirement
		 * @see #balance()
		 */
		static public function dimension ( d : Dimension, rand : Number ) : Dimension
		{
			return RANDOM.dimension(d, rand);
		}

		/*----------------------------------------------------------*
		 * INT METHODS
		 *----------------------------------------------------------*/
		/**
		 * Renvoie un entier aléatoire entre <code>0</code> et <code>val</code>.
		 *
		 * @param	val	limite supérieur pour la valeur aléatoire
		 * @return	un entier aléatoire entre <code>0</code> et <code>val</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function irandom ( val : int = 1 ) : int
		{
			return RANDOM.irandom(val);
		}
		/**
		 * Renvoie un entier aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>.
		 *
		 * @param	val	taille de la plage de valeur répartie équitablement de part et d'autre de 0
		 * @return	un entier aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function ibalance ( val : int = 2 ) : int
		{
			return RANDOM.ibalance( val );
		}
		/**
		 * Renvoie un entier aléatoire compris dans la plage <code>r</code>.
		 *
		 * @param	r	plage de valeurs possible
		 * @return	un entier aléatoire compris dans la plage <code>r</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() RANDOM.random()
		 */
		static public function irange ( r : Range ) : int
		{
			return RANDOM.irange( r );
		}
		/**
		 * Renvoie un entier aléatoire compris dans la plage <code>a &lt; n &lt; b</code>.
		 *
		 * @param	a	borne inférieur de la plage des valeurs possible
		 * @param	a	borne supérieur de la plage des valeurs possible
		 * @return	un nombre aléatoire compris dans la plage <code>a &lt; n &lt; b</code>
		 * @see #irandom()
		 */
		static public function irangeAB ( a : uint = 0, b : uint = 1 ) : Number
		{
			return RANDOM.irangeAB( a, b );
		}
		/**
		 * Renvoie un nouvel objet <code>Point</code> basé sur <code>p</code>dont les valeurs de
		 * <code>x</code> et de <code>y</code> ont été modifiées tel que :
		 * <listing>
		 * x += ibalance( rand )
		 * y += ibalance( rand )</listing>
		 *
		 * @param	p		un point de référence à tranformer aléatoirement
		 * @param	rand	la valeur de tranformation aléatoire tel que définie
		 * 					par la méthode <code>balance</code>
		 * @return 	un nouvel objet <code>Point</code> basé sur <code>p</code>dont les valeurs de
		 * 			<code>x</code> et de <code>y</code> ont été modifiées aléatoirement
		 * @see #ibalance()
		 */
		static public function ipoint ( p : Point, rand : int ) : Point
		{
			return RANDOM.ipoint(p, rand);
		}
		/**
		 * Renvoie un objet <code>Point</code> contenant des coordonnées choisie aléatoirement
		 * dans l'espace définit par les paramètres transmis à cette fonction.
		 *
		 * @param	x	coordonnée en x du point supérieur gauche de la zone source
		 * @param	y	coordonnée en y du point supérieur gauche de la zone source
		 * @param	w	longueur de la zone source
		 * @param	h	hauteur de la zone source
		 * @return	un objet <code>Point</code> contenant des coordonnées choisie aléatoirement
		 * 			dans l'espace définit par les paramètres transmis à cette fonction
		 */
		static public function ipointInRange ( x : int, y : int, w : int, h : int ) : Point
		{
			return RANDOM.ipointInRange(x, y, w, h);
		}
		/**
		 * Renvoie un nouvel objet <code>Dimension</code> basé sur <code>d</code>dont les valeurs de
		 * <code>width</code> et de <code>height</code> ont été modifiées tel que :
		 * <listing>
		 * width += ibalance( rand )
		 * height += ibalance( rand )</listing>
		 *
		 * @param	d		une dimension de référence à tranformer aléatoirement
		 * @param	rand	la valeur de tranformation aléatoire tel que définie
		 * 					par la méthode <code>balance</code>
		 * @return 	un nouvel objet <code>Dimension</code> basé sur <code>d</code>dont les valeurs de
		 * 			<code>width</code> et de <code>height</code> ont été modifiées aléatoirement
		 * @see #ibalance()
		 */
		static public function idimension ( d : Dimension, rand : int ) : Dimension
		{
			return RANDOM.idimension(d, rand);
		}
		/*
		 * MISC METHODS
		 */
		/**
		 * Renvoie une des valeurs de <code>a</code> définie aléatoirement.
		 *
		 * @param	a	le tableau dans lequel prélever une valeur aléatoirement
		 * @return	une des valeurs de <code>a</code> définie aléatoirement
		 */
		static public function inArray ( a : Array ) : *
		{
			return RANDOM.inArray(a);
		}
		/**
		 * Renvoie une des valeurs de <code>a</code> prélevée aléatoirement à l'aide
		 * des valeurs de probabilité définies dans <code>ratios</code>.
		 * <p>
		 * Les taux de probabilité sont relatif à la valeur de <code>total</code>. Ainsi
		 * pour un tableau <code>[a, b, c]</code> dont les taux de probabilité sont
		 * <code>[1, 2, 3]</code>, les taux réels utilisés lors de l'appel seront :
		 * </p>
		 * <ul>
		 * <li><code>a</code> : 1/6</li>
		 * <li><code>b</code> : 2/6</li>
		 * <li><code>c</code> : 3/6</li>
		 * </ul>
		 * <p>
		 * Pour réaliser le choix, la fonction génère un nombre entre 0 et 1, puis parcours
		 * les différents taux, si la valeur générée est inférieur à un taux, la valeur à
		 * l'index correspondant est renvoyée. Ainsi, en reprenant l'exemple précédent, les
		 * taux utilisés lors des tests avec la valeur générée seront <code>[ 1/6, 3/6, 1 ]</code>,
		 * soit le résultat de :
		 * </p>
		 * <listing>
		 * [
		 * 	1/6,
		 * 	1/6 + 2/6,
		 * 	1/6 + 2/6 + 3/6
		 * ];</listing>
		 * <p>
		 * Si le paramètre <code>total</code> est omis, et que le paramètre <code>cumulativeRatios</code>
		 * est à <code>false</code>, la fonction parcours le tableau <code>ratios</code> afin de calculer
		 * le total des taux de probabilité. Dans le cas où <code>total</code> serait omis est que
		 * <code>cumulativeRatios</code> serait à <code>true</code>, une exception est levée par la fonction.
		 * </p>
		 *
		 * @param	a					le tableau dans lequel prélever une valeur aléatoirement
		 * @param	ratios				un tableau contenant les taux d'apparitions de chaque valeurs
		 * @param	total				une valeur représentant le total des valeurs contenues dans
		 * 								<code>ratios</code>
		 * @param	cumulativeRatios	une valeur booléenne indiquant si les taux de probabilités
		 * 								présent dans <code>ratios</code> sont des valeurs pré-additionnées
		 * 								ou non
		 * @return	une valeur de <code>a</code> prélevée aléatoirement
		 * @throws	Error	Le paramètre <code>total</code> est obligatoire lorsque <code>cumulativeRatios</code>
		 * 					est à <code>true</code>.
		 */
		static public function inArrayWithRatios ( a : Array,
												   ratios : Array,
												   cumulativeRatios : Boolean = true,
												   total : Number = NaN ) : *
		{
			return RANDOM.inArrayWithRatios(a, ratios, cumulativeRatios, total);
		}
		/**
		 * Renvoie une des valeurs de <code>a</code> définie aléatoirement.
		 *
		 * @param	a	le vecteur dans lequel prélever une valeur aléatoirement
		 * @return	une des valeurs de <code>a</code> définie aléatoirement
		 */
		/*FDT_IGNORE*/  
		TARGET::FLASH_10
		static public function inVector ( a : Vector.<*> ) : * { return RANDOM.inVector(a); }
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static public function inVector ( a : Vector.<*> ) : * { return RANDOM.inVector(a); }
		
		/**
		 * Renvoie une des valeurs de <code>a</code> prélevée aléatoirement à l'aide
		 * des valeurs de probabilité définies dans <code>ratios</code>.
		 * <p>
		 * Les taux de probabilité sont relatif à la valeur de <code>total</code>. Ainsi
		 * pour un tableau <code>[a, b, c]</code> dont les taux de probabilité sont
		 * <code>[1, 2, 3]</code>, les taux réels utilisés lors de l'appel seront :
		 * </p>
		 * <ul>
		 * <li><code>a</code> : 1/6</li>
		 * <li><code>b</code> : 2/6</li>
		 * <li><code>c</code> : 3/6</li>
		 * </ul>
		 * <p>
		 * Pour réaliser le choix, la fonction génère un nombre entre 0 et 1, puis parcours
		 * les différents taux, si la valeur générée est inférieur à un taux, la valeur à
		 * l'index correspondant est renvoyée. Ainsi, en reprenant l'exemple précédent, les
		 * taux utilisés lors des tests avec la valeur générée seront <code>[ 1/6, 3/6, 1 ]</code>,
		 * soit le résultat de :
		 * </p>
		 * <listing>
		 * [
		 * 	1/6,
		 * 	1/6 + 2/6,
		 * 	1/6 + 2/6 + 3/6
		 * ];</listing>
		 * <p>
		 * Si le paramètre <code>total</code> est omis, et que le paramètre <code>cumulativeRatios</code>
		 * est à <code>false</code>, la fonction parcours le tableau <code>ratios</code> afin de calculer
		 * le total des taux de probabilité. Dans le cas où <code>total</code> serait omis est que
		 * <code>cumulativeRatios</code> serait à <code>true</code>, une exception est levée par la fonction.
		 * </p>
		 *
		 * @param	a					le vecteur dans lequel prélever une valeur aléatoirement
		 * @param	ratios				un tableau contenant les taux d'apparitions de chaque valeurs
		 * @param	total				une valeur représentant le total des valeurs contenues dans
		 * 								<code>ratios</code>
		 * @param	cumulativeRatios	une valeur booléenne indiquant si les taux de probabilités
		 * 								présent dans <code>ratios</code> sont des valeurs pré-additionnées
		 * 								ou non
		 * @return	une valeur de <code>a</code> prélevée aléatoirement
		 * @throws	Error	Le paramètre <code>total</code> est obligatoire lorsque <code>cumulativeRatios</code>
		 * 					est à <code>true</code>.
		 */
		/*FDT_IGNORE*/  
		TARGET::FLASH_10
		static public function inVectorWithRatios ( a : Vector.<*>,
												   ratios : Array,
												   total : Number = NaN,
												   cumulativeRatios : Boolean = true ) : *
		{
			return RANDOM.inVectorWithRatios(a, ratios, total, cumulativeRatios);
		}
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static public function inVectorWithRatios ( a : Vector.<*>,
												   ratios : Array,
												   total : Number = NaN,
												   cumulativeRatios : Boolean = true ) : *
		{
			return RANDOM.inVectorWithRatios(a, ratios, total, cumulativeRatios);
		}
		/**
		 * Renvoie une valeur booléenne choisie aléatoirement selon le taux
		 * passé en paramètre.
		 *
		 * @param	percentage	un nombre représentant la part de valeurs
		 * 			<code>true</code> retournée par la fonction. Ainsi pour
		 * 			une valeur de 1, la fonction renverra toujours <code>true</code>
		 * 			et pour une valeur de 0, la fonction renverra toujours <code>false</code>.
		 */
		static public function boolean ( percentage : Number = 0.5 ) : Boolean
		{
			return RANDOM.boolean(percentage);
		}
		/**
		 * Renvoie un entier valant soit 1 soit 0 choisi aléatoirement selon le taux
		 * passé en paramètre.
		 *
		 * @param	percentage	un nombre représentant la part de valeurs
		 * 			<code>1</code> retournée par la fonction. Ainsi pour
		 * 			une valeur de 1, la fonction renverra toujours <code>1</code>
		 * 			et pour une valeur de 0, la fonction renverra toujours <code>0</code>.
		 */
		static public function bit ( percentage : Number = 0.5 ) : Number
		{
			return RANDOM.bit(percentage);
		}
		/**
		 * Renvoie un entier valant soit 1 soit -1 choisi aléatoirement selon le taux
		 * passé en paramètre.
		 *
		 * @param	percentage	un nombre représentant la part de valeurs
		 * 			<code>1</code> retournée par la fonction. Ainsi pour
		 * 			une valeur de 1, la fonction renverra toujours <code>1</code>
		 * 			et pour une valeur de 0, la fonction renverra toujours <code>-1</code>.
		 */
		static public function sign ( percentage : Number = 0.5 ) : Number
		{
			return RANDOM.sign(percentage);
		}
		/**
		 * Renvoie un caractère dans la plage ASCII choisit aléatoirement.
		 *
		 * @return	un caractère dans la plage ASCII choisit aléatoirement
		 */
		static public function ascii () : String
		{
			return RANDOM.ascii();
		}
		/**
		 * Fonction de tri aléatoire.
		 *
		 * @param	el1
		 * @param	el2
		 * @return	soit 0, 1 ou -1 de manière aléatoire
		 */
		static public function randomSort ( el1 : *, el2:* ) : Number
		{
			return RANDOM.randomSort(el1, el2);
		}
		/**
		 * Renvoie un vecteur aléatoirement choisi dans la plage d'angle définie par
		 * <code>a1</code> et <code>a2</code> et de longueur aléatoirement choisie
		 * dans la plage entre <code>l1</code> et <code>l2</code>.
		 *
		 * @param	a1	angle minimum de la plage d'angle
		 * @param	a2	angle maximum de la plage d'angle
		 * @param	l1	longueur minimum du vecteur
		 * @param	l2	longueur maximum du vecteur
		 * @return	un objet <code>Point</code> représentant le vecteur généré aléatoirement
		 */
		static public function velocity ( a1 : Number, a2 : Number, l1 : Number, l2 : Number ) : Point
		{
			return RANDOM.velocity(a1, a2, l1, l2);
		}
		
		/*
		 * MERSENNE TWISTER RANDOM NUMBER GENERATOR
		 *
		 * implementation originale d'après Matthew Lloyd
		 * http://www.devslash.com/
		 */
		/**
		 * @copy MTRandom#random()
		 * @see	MTRandom#random()
		 */
		static public function srandom( val : Number = 1 ) : Number
		{
			return ( seed() / 0xffffffff ) * val;
		}
		/**
		 * @copy MTRandom#balance()
		 * @see	MTRandom#balance()
		 */
		static public function sbalance ( val : Number = 2 ) : Number
		{
			return val / 2 - srandom( val );
		}
		/**
		 * @copy MTRandom#range()
		 * @see	MTRandom#range()
		 */
		static public function srange ( r : Range ) : Number
		{
			return r.min + srandom() * r.size();
		}

		static public function srangeAB ( a : uint = 0, b : uint = 1 ) : Number
		{
			return a + srandom( b - a );
		}
		/**
		 * @copy MTRandom#point()
		 * @see	MTRandom#point()
		 */
		static public function spoint ( p : Point, rand : int ) : Point
		{
			var vec : Point = p.clone();
			vec.x += sbalance( rand );
			vec.y += sbalance( rand );
			return vec;
		}
		/**
		 * Renvoie un objet <code>Point</code> contenant des coordonnées choisie aléatoirement
		 * dans l'espace définit par les paramètres transmis à cette fonction.
		 *
		 * @param	x	coordonnée en x du point supérieur gauche de la zone source
		 * @param	y	coordonnée en y du point supérieur gauche de la zone source
		 * @param	w	longueur de la zone source
		 * @param	h	hauteur de la zone source
		 * @return	un objet <code>Point</code> contenant des coordonnées choisie aléatoirement
		 * 			dans l'espace définit par les paramètres transmis à cette fonction
		 */
		static public function spointInRange ( x : int, y : int, w : int, h : int ) : Point
		{
			var vec : Point = pt( srangeAB(x, x+w), srangeAB(y,y+h) );
			return vec;
		}
		/**
		 * @copy MTRandom#dimension()
		 * @see	MTRandom#dimension()
		 */
		static public function sdimension ( d : Dimension, rand : Number ) : Dimension
		{
			var dim : Dimension = d.clone();
			dim.width += sbalance( rand );
			dim.height += sbalance( rand );
			return dim;
		}
		/**
		 * @copy MTRandom#seed()
		 * @see	MTRandom#seed()
		 */
		static public function seed():Number
		{
			// si il n'y a pas encore de valeurs pré-générées on plante la graine
			if( MT.length == 0 )
				plantSeed( 0 );

			/*
			 * si on a déja utilisée toutes les valeurs pré-générées
			 * on en reconstruit de nouvelles
			 */
		    if( Z >= 623 )
		    	generateNumbers();

		    return extractNumber( Z++ );
		}
		/**
		 * @copy MTRandom#plantSeed()
		 * @see	MTRandom#plantSeed()
		 */
		static public function plantSeed( seed : uint ) : void
		{
			MT[0] = seed;

			for( var i : int = 1 ; i < 623 ; i++ )
				MT[i] = ( ( 0x10dcd * MT[ i-1 ] ) + 1 ) & 0xFFFFFFFF;
		}
		//
		static private var MT:Array = new Array();
		static private var Z:Number = 0;
		static private var Y:Number = 0;

		static private function generateNumbers():void
		{
			Z = 0;

			for( var i : int = 0 ; i < 623 ; i++ )
			{
				Y = 0x80000000 & MT[ i ] + 0x7FFFFFFF & ( MT[ ( i + 1 ) % 624 ] );

				if( ( Y % 2 ) == 0 )
					MT[ i ] = MT [ ( i + 397 ) % 624 ] ^ ( Y >> 1 );
				else
					MT[ i ] = MT[ ( i + 397 ) % 624 ] ^ ( Y >> 1 ) ^ 0x9908B0DF;
			}
		}
		static private function extractNumber( i : Number ):Number
		{
			Y = MT[ i ];
			Y ^= ( Y >> 11 );
			Y ^= ( Y << 7  ) & 0x9d2c5680;
			Y ^= ( Y << 15 ) & 0xefc60000;
			Y ^= ( Y >> 18 );
			return Y;
		}
	}
}