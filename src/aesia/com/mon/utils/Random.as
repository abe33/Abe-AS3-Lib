package aesia.com.mon.utils 
{
	
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.geom.pt;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class Random 
	{
		public var generator : RandomGenerator;

		public function Random ( generator : RandomGenerator = null ) 
		{
			this.generator = generator ? generator : new BaseRandom();
		}
		/*----------------------------------------------------------*
		 * FLOAT METHODS
		 *----------------------------------------------------------*/
		/**
		 * Renvoie un nombre aléatoire entre <code>0</code> et <code>val</code>.
		 *
		 * @param	val	limite supérieur pour la valeur aléatoire
		 * @return	un nombre aléatoire entre <code>0</code> et <code>val</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function random ( val : Number = 1 ) : Number
		{
			return generator.random() * val;
		}
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>.
		 *
		 * @param	val	taille de la plage de valeur répartie équitablement de part et d'autre de 0
		 * @return	un nombre aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function balance ( val : Number = 2 ) : Number
		{
			return val / 2 - generator.random() * val;
		}
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>r</code>.
		 *
		 * @param	r	plage de valeurs possible
		 * @return	un nombre aléatoire compris dans la plage <code>r</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function range ( r : Range ) : Number
		{
			return r.min + generator.random() * r.size();
		}
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>a &lt; n &lt; b</code>.
		 *
		 * @param	a	borne inférieur de la plage des valeurs possible
		 * @param	a	borne supérieur de la plage des valeurs possible
		 * @return	un nombre aléatoire compris dans la plage <code>a &lt; n &lt; b</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function rangeAB ( a : Number = 0, b : Number = 1 ) : Number
		{
			return a + generator.random() * ( b - a );
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
		public function point ( p : Point, rand : Number ) : Point
		{
			var vec : Point = p.clone();
			vec.x += balance( rand );
			vec.y += balance( rand );
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
		public function pointInRange ( x : Number, y : Number, w : Number, h : Number ) : Point
		{
			var vec : Point = pt( rangeAB(x, x+w), rangeAB(y, y+h) );
			return vec;
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
		public function dimension ( d : Dimension, rand : Number ) : Dimension
		{
			var dim : Dimension = d.clone();
			dim.width += balance( rand );
			dim.height += balance( rand );
			return dim;
		}

		/*----------------------------------------------------------*
		 * INT METHODS
		 *----------------------------------------------------------*/
		/**
		 * Renvoie un entier aléatoire entre <code>0</code> et <code>val</code>.
		 *
		 * @param	val	limite supérieur pour la valeur aléatoire
		 * @return	un entier aléatoire entre <code>0</code> et <code>val</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function irandom ( val : int = 1 ) : int
		{
			return Math.round( generator.random() * val );
		}
		/**
		 * Renvoie un entier aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>.
		 *
		 * @param	val	taille de la plage de valeur répartie équitablement de part et d'autre de 0
		 * @return	un entier aléatoire compris dans la plage <code>-val/2 &lt; n &lt; val/2</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function ibalance ( val : int = 2 ) : int
		{
			return Math.round( val / 2 - generator.random() * val );
		}
		/**
		 * Renvoie un entier aléatoire compris dans la plage <code>r</code>.
		 *
		 * @param	r	plage de valeurs possible
		 * @return	un entier aléatoire compris dans la plage <code>r</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/Math.html#random() Math.random()
		 */
		public function irange ( r : Range ) : int
		{
			return Math.round( r.min + generator.random() * r.size() );
		}
		/**
		 * Renvoie un entier aléatoire compris dans la plage <code>a &lt; n &lt; b</code>.
		 *
		 * @param	a	borne inférieur de la plage des valeurs possible
		 * @param	a	borne supérieur de la plage des valeurs possible
		 * @return	un nombre aléatoire compris dans la plage <code>a &lt; n &lt; b</code>
		 * @see #irandom()
		 */
		public function irangeAB ( a : uint = 0, b : uint = 1 ) : Number
		{
			return a + irandom( b - a );
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
		public function ipoint ( p : Point, rand : int ) : Point
		{
			var vec : Point = p.clone();
			vec.x += ibalance( rand );
			vec.y += ibalance( rand );
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
		public function ipointInRange ( x : int, y : int, w : int, h : int ) : Point
		{
			var vec : Point = pt( irangeAB(x, x+w), irangeAB(y,y+h) );
			return vec;
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
		public function idimension ( d : Dimension, rand : int ) : Dimension
		{
			var dim : Dimension = d.clone();
			dim.width += ibalance( rand );
			dim.height += ibalance( rand );
			return dim;
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
		public function inArray ( a : Array ) : *
		{
			return a[ irandom( a.length-1 ) ];
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
		public function inArrayWithRatios ( a : Array,
												   ratios : Array,
												   cumulativeRatios : Boolean = true,
												   total : Number = NaN ) : *
		{
			var n : Number = generator.random ();
			if( isNaN ( total ) && !cumulativeRatios )
			{
				var t : Number = 0
				ratios.forEach(function( n : Number, ... args ) : void { t += n; } );
				total = t;
			}
			else if( isNaN( total ) && cumulativeRatios )
				throw new Error( "While cumulativeRatios is true, the total parameter is mandatory" );

			var l : uint = ratios.length;
			var step : Number = 0;
			var index : uint;

			for( var i : int = 0; i < l; i++ )
			{
				if( cumulativeRatios )
					step = ratios[i] / total;
				else
					step += ratios[i] / total;

				if( n <= step )
				{
					index = i;
					break;
				}
			}
			return a[index];
		}
		/**
		 * Renvoie une des valeurs de <code>a</code> définie aléatoirement.
		 *
		 * @param	a	le vecteur dans lequel prélever une valeur aléatoirement
		 * @return	une des valeurs de <code>a</code> définie aléatoirement
		 */
		public function inVector ( a : Vector ) : *
		{
			return a[ irandom( a.length-1 ) ];
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
		public function inVectorWithRatios ( a : Vector,
												   ratios : Array,
												   total : Number = NaN,
												   cumulativeRatios : Boolean = true ) : *
		{
			var n : Number = generator.random();
			if( isNaN( total) )
			{
				var t : Number = 0
				ratios.forEach(function( n : Number, ... args ) : void { t += n; } );
				total = t;
			}
			var l : uint = ratios.length;
			var step : Number = 0;
			var index : uint;

			for( var i : int = 0; i < l; i++ )
			{
				if( cumulativeRatios )
					step = ratios[i] / total;
				else
					step += ratios[i] / total;

				if( n <= step )
				{
					index = i;
					break;
				}
			}
			return a[index];
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
		public function boolean ( percentage : Number = 0.5 ) : Boolean
		{
			return random() <= percentage;
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
		public function bit ( percentage : Number = 0.5 ) : Number
		{
			return random() <= percentage ? 1 : 0;
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
		public function sign ( percentage : Number = 0.5 ) : Number
		{
			return random() <= percentage ? 1 : -1;
		}
		/**
		 * Renvoie un caractère dans la plage ASCII choisit aléatoirement.
		 *
		 * @return	un caractère dans la plage ASCII choisit aléatoirement
		 */
		public function ascii () : String
		{
			return String.fromCharCode( irandom( 128 ) );
		}
		/**
		 * Fonction de tri aléatoire.
		 *
		 * @param	el1
		 * @param	el2
		 * @return	soit 0, 1 ou -1 de manière aléatoire
		 */
		public function randomSort ( el1 : *, el2:* ) : Number
		{
			return ibalance();
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
		public function velocity ( a1 : Number, a2 : Number, l1 : Number, l2 : Number ) : Point
		{
			var a : Number = rangeAB(a1, a2 );
			var l : Number = rangeAB( l1, l2 );

			return new Point( Math.sin(a)*l, Math.cos(a)*l );
		}
	}
}
