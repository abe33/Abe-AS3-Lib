/**
 * @license
 */
package aesia.com.mon.utils
{
	import aesia.com.mon.core.Randomizable;
	/**
	 * Classe implémentant l'algorithme de génération de nombre pseudo aléatoire Mersenne Twister.
	 * <p>
	 * Chaque instance initie une séquence de nombres qui seront identiques pour une <code>seed</code>
	 * donnée. Tel que :
	 * </p>
	 * <listing>var mt1 : MTRandom = new MTRandom();
	 * var mt2 : MTRandom = new MTRandom();
	 *
	 * trace( mt1.random() == mt2.random() ); // output : true </listing>
	 *
	 * @author Cédric Néhémie
	 * @see http://fr.wikipedia.org/wiki/Mersenne_Twister Mersenne Twister sur Wikipédia
	 * @see http://www.devslash.com/ Implementation originale d'après Matthew Lloyd
	 */
	public class MTRandom implements RandomGenerator
	{
		static public function init( o : Randomizable, seed : uint = 0 ) : Randomizable
		{
			o.randomSource = new Random( new MTRandom( seed ) );
			return o;
		}
		/**
		 * Créer une nouvelle instance de la classe <code>MTRandom</code> avec
		 * la graine <code>seed</code>.
		 * <p>
		 * Deux instances dont les graines sont égales renverront la même séquence de nombres.
		 * </p>
		 *
		 * @param	seed	graine initialisant la séquence de nombre
		 */
		public function MTRandom ( seed : uint = 0 )
		{
			plantSeed( seed );
		}

		/*----------------------------------------------------------------------------*
		 * MERSENNE TWISTER RANDOM NUMBER GENERATOR
		 *
		 * implementation originale d'après Matthew Lloyd
		 * http://www.devslash.com/
		 *---------------------------------------------------------------------------*/
		/**
		 * Renvoie un nombre aléatoire compris dans la plage <code>0 &lt; n &lt; val</code>.
		 *
		 * @param	val	limite supérieur de la plage de valeur possible
		 * @return	un nombre aléatoire compris dans la plage <code>0 &lt; n &lt; val</code>
		 */
		public function random() : Number
		{
			return ( Number( seed() )/ 0xffffffff * 2 );
		}
		/**
		 * Renvoie le prochain entier de la séquence pseudo-aléatoire.
		 *
		 * @return le prochain entier de la séquence pseudo-aléatoire
		 */
		public function seed() : uint
		{
			// si il n'y a pas encore de valeurs pré-générées on plante la graine
			if( Z == 0 )
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
		 * Définie la graine pour cette instance. Dès lors qu'une nouvelle graine est définie
		 * la séquence est reconstruite.
		 * <p>
		 * Transmettre la même graine que celle définie précedemment aura pour effet de
		 * réinitialiser la séquence précédente.
		 * </p>
		 *
		 * @param	seed	la nouvelle graine pour l'instance courante
		 */
		public function plantSeed( seed : uint ) : void
		{
			MT[0] = seed;

			for( var i : int = 1 ; i < 623 ; i++ )
				MT[i] = ( ( 0x10dcd * MT[ i-1 ] ) + 1 ) & 0xFFFFFFFF;
		}
		/*-------------------------------------------------------------*
		 * PRIVATE MEMBERS
		 *-------------------------------------------------------------*/
		// Un vecteur contenant les 623 valeurs de la séquence courante
		private var MT:Vector.<uint> = new Vector.<uint>( 623 );
		// le curseur permettant de récupérer la prochaine valeur parmis les 623 courantes
		private var Z:Number = 0;
		// une variable utilisée dans le cadre de la génération
		private var Y:Number = 0;

		/*
		 * Fonction générant une séquence de 623 nombres pseudo aléatoires
		 */
		private function generateNumbers():void
		{
			Z = 0;

			for( var i : int = 0 ; i < 623 ; i++ )
			{
				Y = 0x80000000 & MT[ i ] + 0x7FFFFFFF & ( MT[ ( i + 1 ) % 623 ] );

				if( ( Y % 2 ) == 0 )
					MT[ i ] = MT [ ( i + 397 ) % 623 ] ^ ( Y >> 1 );
				else
					MT[ i ] = MT[ ( i + 397 ) % 623 ] ^ ( Y >> 1 ) ^ 0x9908B0DF;
			}
		}
		/*
		 * Extrait une des valeurs de la séquence
		 */
		private function extractNumber( i : Number ):Number
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
