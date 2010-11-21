/**
 * @license
 */
package aesia.com.mon.utils
{

	/**
	 * Classe utilitaires fournissant des méthodes opérant sur
	 * des chaînes de caractères.
	 *
	 * @author	Ryan Matsikas
	 * @author	Grant Skinner
	 * @author	Cédric Néhémie
	 * @see	http://www.gskinner.com	Visit www.gskinner.com for documentation, updates and more free code.
	 */
	public class StringUtils
	{
		/**
		 * Renvoie l'entier <code>i</code> sous forme d'une chaîne héxadécimale.
		 *
		 * @param	i	entier à convertir
		 * @return	l'entier sous forme d'une chaîne héxadécimale
		 * @example <listing>trace( StringUtils.formatUintAsHexadecimal( 0 ) ); // output : 0x000000</listing>
		 */
		static public function formatUintAsHexadecimal ( i : uint ) : String
		{
			return "0x" + StringUtils.fill ( i.toString ( 16 ), 6 );
		}
		/**
		 * Renvoie le nombre <code>n</code> sous forme de chaîne avec les décimales.
		 * <p>
		 * Le nombre de décimales est définie en argument de la fonction, elles seront
		 * présentes même si le nombre n'en comprend pas.
		 * </p>
		 * @param	n			le nombre à formater
		 * @param	decimals	le nombre de décimales à conserver
		 * @param	separator	le séparateur à utiliser pour les décimales
		 * @return	le nombre sous forme de chaîne
		 * @example	<listing>trace( StringUtils.formatNumber( 0 ) ); // output : 0.00</listing>
		 * <listing>trace( StringUtils.formatNumber( 26.66666666, 3, "," ) ) ; // output : 26,666</listing>
		 */
		static public function formatNumber ( n : Number, decimals : Number = 2, separator : String = "." ) : String
		{
			var sv : String = String ( n );

			if( sv.indexOf ( "." ) != -1 )
			{
				var a : Array = sv.split ( "." );

				if( a[1].length > decimals )
					a[1] = a[1].substr ( 0, decimals );
				else
					a[1] = fill ( a[1], decimals, "0", false );

				return a.join ( separator );
			}
			else
			{
				return sv + separator + fill ( "", decimals, "0", false );
			}
		}
		/**
		 * Renvoie la chaîne <code>s</code> où les jetons d'insertions ont été
		 * remplacés par les arguments transmis dans le paramètre <code>args</code>.
		 * <p>
		 * Les jetons d'insertions se présentent sous la forme <code>$N</code> où
		 * <code>N</code> représentent l'index de la valeur de <code>args</code>
		 * à utiliser pour le remplacement. L'ordre des jetons dans la chaîne n'a
		 * aucun impact sur le traitement des remplacements.
		 * </p>
		 * @param	s		la chaîne dans laquelle opérer les remplacements
		 * @param	args	liste des éléments servant pour les remplacements
		 * 					au sein de la chaîne <code>str</code>
		 * @return	la chaîne <code>s</code> dont les jetons auront été remplacés
		 * 			par les éléments transmis dans <code>args</code>
		 * @example <listing>trace( StringUtils.tokenReplace('Hello $0 ! Welcome in $1.', 'World', 'Hell') );
		 * // output : Hello World ! Welcome in Hell.</listing>
		 */
		static public function tokenReplace ( s : String, ... args ) : String
		{
			var a : Array = args;
			var f : Function = function ( ... rest ) : String
			{
				return a[ parseInt ( rest[ 1 ] ) ];
			};
			return (s as String).replace ( /\$([0-9]+)/g, f );
		}
		/**
		 * Renvoie la chaîne <code>s</code> complétée avec le caractère <code>f</code>
		 * afin que sa longueur atteigne <code>l</code>.
		 * <p>
		 * Les caractères de complément peuvent être ajoutés aussi bien à gauche qu'à
		 * droite de la chaîne selon que le paramètre <code>fillLeft</code> est à
		 * <code>true</code> ou à <code>false</code>.
		 * </p>
		 *
		 * @param	s			la chaîne à transformer
		 * @param	l			la longueur à atteindre
		 * @param	f			le caractère servant à compléter la chaîne
		 * @param	fillLeft	les caractères de compléments sont ajouté
		 * 						à la gauche de la chaîne de caractère
		 * @return	la chaîne complétée afin que sa longueur atteigne <code>l</code>
		 */
		static public function fill ( s : *,
									  l : Number,
									  f : String = "0",
									  fillLeft : Boolean = true ) : String
		{
			if( String(s).length >= l )
				return String( s );
			
			if( f.length > 1 )
				f = f.substring(0, 1);

			var str : String = s.toString ();
			var toFill : Number = l - str.length;
			while (toFill--)
			{
				if( fillLeft )
					str = f + str;
				else
					str = str + f;
			}
			return str;
		}
		/**
		 * Renvoie tout les caractères après la première occurence de <code>char</code>
		 * dans la chaîne <code>string</code>.
		 *
		 * @param	string	la chaîne à traiter
		 * @param	begin	le caractère à rechercher
		 * @return	tout les caractères après la première occurence de <code>char</code>
		 */
		public static function afterFirst ( string : String, char : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			var idx : int = string.indexOf ( char );
			if (idx == -1)
			{
				return '';
			}
			idx += char.length;
			return string.substr ( idx );
		}
		/**
		 * Renvoie tous les caractère après la dernière occurence de <code>char</code>
		 * dans la chaîne <code>string</code>
		 *
		 * @param	string	la chaîne à traiter
		 * @param	begin	le caractère à rechercher
		 * @return	tout les caractères après la dernière occurence de <code>char</code>
		 */
		public static function afterLast ( string : String, char : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			var idx : int = string.lastIndexOf ( char );
			if (idx == -1)
			{
				return '';
			}
			idx += char.length;
			return string.substr ( idx );
		}
		/**
		 * Renvoie <code>true</code> si la chaîne <code>string</code> commence par
		 * la séquence <code>begin</code>.
		 *
		 * @param	string	la chaîne à vérifier
		 * @param	begin	la séquence de départ
		 * @return	<code>true</code> si la chaîne commence par la séquence
		 * 			<code>begin</code>
		 */
		public static function beginsWith ( string : String, begin : String ) : Boolean
		{
			if (string == null)
			{
				return false;
			}
			return string.indexOf ( begin ) == 0;
		}
		/**
		 * Renvoie tous les caractère avant la première occurence de <code>char</code>
		 * dans la chaîne <code>string</code>
		 *
		 * @param	string	la chaîne à traiter
		 * @param	begin	le caractère à rechercher
		 * @return	tout les caractères avant la première occurence de <code>char</code>
		 */
		public static function beforeFirst ( string : String, char : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			var idx : int = string.indexOf ( char );
			if (idx == -1)
			{
				return '';
			}
			return string.substr ( 0, idx );
		}
		/**
		 * Renvoie tous les caractère avant la dernière occurence de <code>char</code>
		 * dans la chaîne <code>string</code>
		 *
		 * @param	string	la chaîne à traiter
		 * @param	begin	le caractère à rechercher
		 * @return	tout les caractères avant la dernière occurence de <code>char</code>
		 */
		public static function beforeLast ( string : String, char : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			var idx : int = string.lastIndexOf ( char );
			if (idx == -1)
			{
				return '';
			}
			return string.substr ( 0, idx );
		}
		/**
		 * Renvoie tous les caractères entre la première occurence de <code>start</code>
		 * et la première occurence de <code>end</code> dans la chaîne <code>string</code>.
		 *
		 * @param	string	la chaîne à traiter
		 * @param	start	la séquence de début à rechercher
		 * @param	end		la séquence de fin à rechercher
		 * @return	tous les caractères entre la première occurence de <code>start</code>
		 * 			et la première occurence de <code>end</code> dans la chaîne <code>string</code>
		 */
		public static function between ( string : String, start : String, end : String ) : String
		{
			var str : String = '';
			if (string == null)
			{
				return str;
			}
			var startIdx : int = string.indexOf ( start );
			if (startIdx != -1)
			{
				startIdx += start.length;
				// RM: should we support multiple chars? (or ++startIdx);
				var endIdx : int = string.indexOf ( end, startIdx );
				if (endIdx != -1)
				{
					str = string.substr ( startIdx, endIdx - startIdx );
				}
			}
			return str;
		}
		/**
		 * Méthode utilitaire découpant intelligement la chaîne en plusieurs blocs
		 * <p>
		 * Cette méthode tente de retourner les portions de chaîne se rapprochant
		 * le plus du caractère <code>delim</code> tout en conservant le texte dans
		 * la limite définie par <code>len</code>.
		 * </p>
		 * <p>
		 * Si aucun texte ne peut être trouvé avec la longueur précisé, la chaîne
		 * est suffixé avec un '...' et la recherche de blocs continue jusqu'à ce
		 * que tout le texte ait été découpé.
		 * </p>
		 *
		 * @param	string	la chaîne à découper
		 * @param	len		la longueur maximum d'un bloc
		 * @param	delim	le caractère définissant la fin d'un bloc
		 * @return	un tableau contenant les différents blocs de texte trouvé dans la chaîne
		 */
		public static function block ( string : String, len : uint, delim : String = "." ) : Array
		{
			var arr : Array = new Array ();
			if (string == null || !contains ( string, delim ))
			{
				return arr;
			}
			var chrIndex : uint = 0;
			var strLen : uint = string.length;
			var replPatt : RegExp = new RegExp ( "[^" + escapePattern ( delim ) + "]+$", "g" );
			while (chrIndex < strLen)
			{
				var subString : String = string.substr ( chrIndex, len );
				if (!contains ( subString, delim ))
				{
					arr.push ( truncate ( subString, subString.length ) );
					chrIndex += subString.length;
				}
				subString = subString.replace ( replPatt, '' );
				arr.push ( subString );
				chrIndex += subString.length;
			}
			return arr;
		}
		/**
		 * Met en capitale la première lettre du premier de la chaîne et renvoie
		 * la chaîne transformée.
		 * <p>
		 * Si le paramètre <code>all</code> est à <code>true</code> tout les mots
		 * voient leur premier caractère passé en capitale.
		 * </p>
		 *
		 * @param	string	la chaîne à traiter
		 * @param	all		si <code>true</code> tout les mots voient leur premier
		 * 					caractère passé en capitale
		 * @return	la chaîne transformée
		 */
		public static function capitalize ( string : String, all : Boolean = false ) : String
		{
			var str : String = trimLeft ( string );
			if ( all )
			{
				return str.replace ( /^.|\b./g, _upperCase );
			}
			else
			{
				return str.replace ( /(^\w)/, _upperCase );
			}
		}
		/**
		 * Met en capitale la première lettre du premier de la chaîne et renvoie
		 * la chaîne transformée.
		 * <p>
		 * Les caractères capitalisés peuvent être transformés à l'aide d'un motif
		 * de remplacement <code>pattern</code> fonctionnant sur le principe définit
		 * par la méthode <code>tokenReplace</code>.
		 * </p>
		 * <p>
		 * Si le paramètre <code>all</code> est à <code>true</code> tout les mots
		 * voient leur premier caractère passé en capitale.
		 * </p>
		 *
		 * @param	string	la chaîne à traiter
		 * @param	pattern	une chaîne représentant le motif de remplacement tel que
		 * 					définie par la méthode <code>tokenReplace</code>
		 * @param	all		si <code>true</code> tout les mots voient leur premier
		 * 					caractère passé en capitale
		 * @return	la chaîne transformée
		 * @example	<listing>trace( StringUtils.smartCapitalize( "Hello World !", "&lt;b&gt;!$0&lt;/b&gt;", true ) );
		 * // output &lt;b&gt;H&lt;/b&gt;ello &lt;b&gt;W&lt;/b&gt;orld !</listing>
		 */
		public static function smartCapitalize ( string : String, pattern : String = "$0", all : Boolean = false ) : String
		{
			var str : String = trimLeft ( string );
			_currentSmartPattern = pattern;
			if ( all )
			{
				return str.replace ( /^.|\b./g, _smartUpperCase );
			}
			else
			{
				return str.replace ( /(^\w)/, _smartUpperCase );
			}
		}
		/**
		 * Renvoie <code>true</code> si la chaîne <code>string</code> contient
		 * la séquence <code>char</code>
		 *
		 * @param	string	chaîne à traiter
		 * @param	char	séquence à rechercher
		 * @return	<code>true</code> si la chaîne contient
		 * 			la séquence <code>char</code>
		 */
		public static function contains ( string : String, char : String ) : Boolean
		{
			if (string == null)
				return false;

			return string.indexOf ( char ) != -1;
		}
		/**
		 * Renvoie le nombre d'occurences de la séquence <code>char</code> trouvée
		 * dans la chaîne <code>string</code>.
		 *
		 * @param	string			la chaîne source
		 * @param	char			la séquence à compter
		 * @param	caseSensitive	<code>true</code> pour la recherche soit sensible
		 * 							à la casse
		 * @return	le nombre d'occurences de la séquence <code>char</code> trouvée
		 * 			dans la chaîne
		 */
		public static function countOf ( string : String, char : String, caseSensitive : Boolean = true ) : uint
		{
			if (string == null)
			{
				return 0;
			}
			var char : String = escapePattern ( char );
			var flags : String = (!caseSensitive) ? 'ig' : 'g';
			return string.match ( new RegExp ( char, flags ) ).length;
		}
		/**
		 * Renvoie la distance de Levenshtein entre la chaîne <code>source</code>
		 * et la chaîne <code>target</code>.
		 * <p>
		 * La distance de Levenshtein mesure la similarité entre deux chaînes de caractères.
		 * Elle est égale au nombre minimal de caractères qu'il faut supprimer, insérer
		 * ou remplacer pour passer d’une chaîne à l’autre.
		 * </p>
		 * @param	source	chaîne source
		 * @param	target	chaîne finale
		 * @return	la distance de Levenshtein entre les deux chaînes
		 */
		public static function editDistance ( source : String, target : String ) : uint
		{
			var i : uint;

			if (source == null)
			{
				source = '';
			}
			if (target == null)
			{
				target = '';
			}

			if (source == target)
			{
				return 0;
			}

			var d : Array = new Array ();
			var cost : uint;
			var n : uint = source.length;
			var m : uint = target.length;
			var j : uint;

			if (n == 0)
			{
				return m;
			}
			if (m == 0)
			{
				return n;
			}

			for (i = 0; i <= n ; i++)
			{
				d[i] = new Array ();
			}
			for (i = 0; i <= n ; i++)
			{
				d[i][0] = i;
			}
			for (j = 0; j <= m ; j++)
			{
				d[0][j] = j;
			}

			for (i = 1; i <= n ; i++)
			{
				var s_i : String = source.charAt ( i - 1 );
				for (j = 1; j <= m ; j++)
				{
					var t_j : String = target.charAt ( j - 1 );

					if (s_i == t_j)
					{
						cost = 0;
					}
					else
					{
						cost = 1;
					}

					d[i][j] = _minimum ( d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost );
				}
			}
			return d[n][m];
		}
		/**
		 * Renvoie <code>true</code> si la chaîne <code>string</code> termine par
		 * la séquence <code>end</code>.
		 *
		 * @param	string	la chaîne à vérifier
		 * @param	end		la séquence de fin
		 * @return	<code>true</code> si la chaîne termine par la séquence
		 * 			<code>end</code>
		 */
		public static function endsWith ( string : String, end : String ) : Boolean
		{
			return string.lastIndexOf ( end ) == string.length - end.length;
		}
		/**
		 * Renvoie <code>true</code> si la chaîne <code>string</code> contient
		 * autre chose que des espaces.
		 *
		 * @param	string	chaîne à vérifier
		 * @return	<code>true</code> si la chaîne contient
		 * 			autre chose que des espaces
		 */
		public static function hasText ( string : String ) : Boolean
		{
			var str : String = removeExtraWhitespace ( string );
			return !!str.length;
		}
		/**
		 *	Renvoie <code>true</code> si la chaîne <code>string</code> est vide.
		 *
		 * @param	string	chaîne à vérifier
		 * @return	<code>true</code> si la chaîne est vide
		 */
		public static function isEmpty ( string : String ) : Boolean
		{
			if (string == null)
			{
				return true;
			}
			return !string.length;
		}
		/**
		 *	Renvoie <code>true</code> si la chaîne <code>string</code>
		 *	contient une représentation numérique.
		 *
		 *	@param	string	chaîne à vérifier
		 *	@return	<code>true</code> si la chaîne contient une représentation
		 *			numérique
		 */
		public static function isNumeric ( string : String ) : Boolean
		{
			if (string == null)
			{
				return false;
			}
			var regx : RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test ( string );
		}
		/**
		 * Renvoie la chaîne <code>string</code> proprement formatée
		 * comme une "phrase".
		 *
		 * @param	string	chaîne à formater
		 * @return	la chaîne proprement formatée comme une "phrase"
		 */
		public static function properCase ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			var str : String = string.toLowerCase ().replace ( /\b([^.?;!]+)/, capitalize );
			return str.replace ( /\b[i]\b/, "I" );
		}
		/**
		 * Échappe tout les caractères de la chaîne afin de renvoyer une chaîne
		 * ne posant pas de problème une fois placée entre guillemets.
		 *
		 * @param	string	la chaîne à traiter
		 * @return	une chaîne ne posant pas de problème une fois placée
		 * 			entre guillemets
		 */
		public static function quote ( string : String ) : String
		{
			var regx : RegExp = /[\\"\r\n]/g;
			return '"' + string.replace ( regx, _quote ) + '"';
			// "
		}
		/**
		 * Supprime toutes les occurences de <code>remove</code> dans la chaîne <code>string</code>.
		 *
		 * @param	string			la chaîne à traiter
		 * @param	remove			la séquence à supprimer
		 * @param	caseSensitive	<code>true</code> pour que la recherche soit
		 * 							sensible à la casse
		 */
		public static function remove ( string : String, remove : String, caseSensitive : Boolean = true ) : String
		{
			if (string == null)
			{
				return '';
			}
			var rem : String = escapePattern ( remove );
			var flags : String = (!caseSensitive) ? 'ig' : 'g';
			return string.replace ( new RegExp ( rem, flags ), '' );
		}
		/**
		 * Supprime tout les espaces supperflus dans la chaîne <code>string</code>
		 *
		 * @param	string	chaîne à traiter
		 * @return	la chaîne sans les espaces superflus
		 */
		public static function removeExtraWhitespace ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			var str : String = trim ( string );
			return str.replace ( /\s+/g, ' ' );
		}
		/**
		 * Remplace tout les caractères accentués de la chaîne <code>string</code>
		 * par leur équivalent non-accentués.
		 *
		 * @param	source	la chaîne à traiter
		 * @return	la chaîne sans les caractères accentués
		 */
		static public function noAccent ( source : String ) : String
		{
			return source.replace ( /[àáâãäå]/g, "a" )
			.replace ( /[ÀÁÂÃÄÅ]/g, "A" )
			.replace ( /[èéêë]/g, "e" )
			.replace ( /[ËÉÊÈ]/g, "E" )
			.replace ( /[ìíîï]/g, "i" )
			.replace ( /[ÌÍÎÏ]/g, "I" )
			.replace ( /[ðòóôõöø]/g, "o" )
			.replace ( /[ÐÒÓÔÕÖØ]/g, "O" )
			.replace ( /[ùúûü]/g, "u" )
			.replace ( /[ÙÚÛÜ]/g, "U" )
			.replace ( /[ýýÿ]/g, "y" )
			.replace ( /[ÝÝŸ]/g, "Y" )
			.replace ( /[ç]/g, "c" )
			.replace ( /[Ç]/g, "C" )
			.replace ( /[ñ]/g, "n" )
			.replace ( /[Ñ]/g, "N" )
			.replace ( /[š]/g, "s" )
			.replace ( /[Š]/g, "S" )
			.replace ( /[ž]/g, "z" )
			.replace ( /[Ž]/g, "Z" )
			.replace ( /[æ]/g, "ae" )
			.replace ( /[Æ]/g, "AE" )
			.replace ( /[œ]/g, "oe" )
			.replace ( /[Œ]/g, "OE" );
		}
		/**
		 * Renvoie la chaîne <code>string</code> avec tout ses caractères
		 * placés dans l'autre sens.
		 *
		 * @param	string	chaîne à inverser
		 * @return	la chaîne avec tout ses caractères placés dans l'autre sens
		 */
		public static function reverse ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.split ( '' ).reverse ().join ( '' );
		}
		/**
		 * Renvoie la chaîne <code>string</code> avec tout ses mots
		 * placés dans l'autre sens
		 *
		 * @param	string	chaîne à inverser
		 * @return	la chaîne avec tout ses mots placés dans l'autre sens
		 */
		public static function reverseWords ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.split ( /\s+/ ).reverse ().join ( '' );
		}
		/**
		 * Renvoie le pourcentage de similitude entre deux chaînes en se
		 * basant sur le résultat de la méthode <code>editDistance</code>.
		 *
		 * @param	source	première chaîne
		 * @param	target	deuxième chaîne
		 * @return	le pourcentage de similitude entre les deux chaînes
		 */
		public static function similarity ( source : String, target : String ) : Number
		{
			var ed : uint = editDistance ( source, target );
			var maxLen : uint = Math.max ( source.length, target.length );
			if (maxLen == 0)
			{
				return 100;
			}
			else
			{
				return (1 - ed / maxLen) * 100;
			}
		}
		/**
		 * Supprime toutes les balises XML de la chaîne.
		 *
		 * @param	string	chaîne à traiter
		 * @return	la chaîne néttoyée des balises XML
		 */
		public static function stripTags ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.replace ( /<\/?[^>]+>/igm, '' );
		}
		/**
		 * Inverse la casse de la chaîne.
		 *
		 * @param	string	chaîne à traiter
		 * @return	la chaîne avec sa casse inversée
		 */
		public static function swapCase ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.replace ( /(\w)/, _swapCase );
		}
		/**
		 * Supprime les espaces en début et fin de chaîne.
		 *
		 * @param	string	la chaîne à traiter
		 * @return	la chaîne néttoyé de ses espaces de début
		 * 			et de fin
		 */
		public static function trim ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.replace ( /^\s+|\s+$/g, '' );
		}

		/**
		 * Supprime les espaces en début de chaîne.
		 *
		 * @param	string	la chaîne à traiter
		 * @return	la chaîne néttoyé de ses espaces de début
		 */
		public static function trimLeft ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.replace ( /^\s+/, '' );
		}

		/**
		 * Supprime les espaces en fin de chaîne.
		 *
		 * @param	string	la chaîne à traiter
		 * @return	la chaîne néttoyé de ses espaces de fin
		 */
		public static function trimRight ( string : String ) : String
		{
			if (string == null)
			{
				return '';
			}
			return string.replace ( /\s+$/, '' );
		}
		/**
		 * Renvoie le nombre de mots présents dans la chaîne <code>string</code>.
		 *
		 * @param	string	la chaîne dont on souhaite compter les mots.
		 * @return	le nombre de mots présents dans la chaîne
		 */
		public static function wordCount ( string : String ) : uint
		{
			if (string == null)
			{
				return 0;
			}
			return string.match ( /\b\w+\b/g ).length;
		}
		/**
		 * Renvoie une version tronquée de la chaîne <code>string</code> à la longueur <code>len</code>
		 * et suffixée avec la chaîne <code>suffix</code>.
		 *
		 * @param	string	la chaîne à tronquer
		 * @param	len		la longueur de la chaîne à retourner
		 * @param	suffix	le suffix à utiliser
		 * @return	une version tronquée de la chaîne
		 */
		public static function truncate ( string : String, len : uint, suffix : String = "..." ) : String
		{
			if (string == null)
			{
				return '';
			}
			len -= suffix.length;
			var trunc : String = string;
			if (trunc.length > len)
			{
				trunc = trunc.substr ( 0, len );
				if (/[^\s]/.test ( string.charAt ( len ) ))
				{
					trunc = trimRight ( trunc.replace ( /\w+$|\s+$/, '' ) );
				}
				trunc += suffix;
			}

			return trunc;
		}
		/**
		 * Revoie l'index du caractère de fin du bloc défini par les caractères
		 * <code>openingChar</code> et <code>closingChar</code> et commencant à
		 * <code>startIndex</code>.
		 * <p>
		 * La fonction prend soin de considérer les blocs imbriqués, ainsi, quelque
		 * soit le nombre de blocs imbriqués, l'index renvoyé est bien celui de fin
		 * du bloc commencant à <code>startIndex</code>.
		 * </p>
		 * <p>
		 * Si la fonction arrive à la fin de la chaîne sans avoir trouvé de caractère
		 * fermant le bloc, celle-ci renvoie <code>-1</code>.
		 * </p>
		 *
		 * @param	s			la chaîne dans laquelle rechercher un bloc
		 * @param	startIndex	l'index de départ de la recherche, souvent l'index
		 * 						du caractère d'ouverture ayant initié le bloc
		 * @param	openingChar	le caractère utilisé pour définir l'ouverture d'un bloc
		 * @param	closingChar	le caractère utilisé pour fermer le bloc
		 * @return	l'index du caractère de fin du bloc commencant
		 * 			à <code>startIndex</code>
		 */
		static public function findClosingIndex ( s : String, startIndex : int = 0, openingChar : String = "[", closingChar : String = "]" ) : int
		{
			var curStr : String;
			var index : int = startIndex;
			var nests : int = 1;
			while( nests && index < s.length )
			{
				curStr = s.substr ( index++, 1 );

				if( curStr == closingChar )
					nests--;
				else if( curStr == openingChar )
					nests++;
			}
			if( nests == 0)
				return index - 1;
			else
				return -1;
		}
		/**
		 * Renvoie un tableau contenant les éléments dans la chaîne <code>s</code>
		 * séparés par le séparateur <code>sep</code>.
		 * <p>
		 * La fonction prend en compte les blocs imbriqués, elle se différencie ainsi
		 * de la fonction <code>String.split</code> car elle ne découpera pas la chaîne
		 * lorsque le séparateur se situe à l'intérieur d'un groupe.
		 * </p>
		 *
		 * @param	s	chaîne à convertir en tableau
		 * @param	sep	séparateur servant au découpage de la chaîne
		 * @return	un tableau contenant les éléments dans la chaîne <code>s</code>
		 * 			séparés par le séparateur <code>sep</code>
		 * @example Lorsque la chaîne contient des groupes contenant eux-mêmes le séparateur
		 * la fonction ignore ces séparateurs :
		 * <listing>var a : Array = StringUtils.splitBlock("foo(a,b,c),[1,2,3],{x:1,y:1}");
		 * trace( a.join("\n") );
		 * // output :
		 * // foo(a,b,c)
		 * // [1,2,3]
		 * // {x:1,y:1}</listing>
		 */
		static public function splitBlock ( s : String, sep : String = "," ) : Array
		{
			var a : Array = [];
			var l : uint = s.length;
			var i : uint;
			var start : uint = 0;
			while( i < l )
			{
				var c : String = s.substr ( i, 1 );
				switch(c)
				{
					case "(" :
						i = StringUtils.findClosingIndex ( s, i + 1, c, ")" );
						break;
					case "[" :
						i = StringUtils.findClosingIndex ( s, i + 1, c, "]" );
						break;
					case "{" :
						i = StringUtils.findClosingIndex ( s, i + 1, c, "}" );
						break;
					case sep :
						a.push ( StringUtils.trim ( s.substr ( start, i - start ) ) );
						start = i + 1;
						break;
				}

				i++;
			}
			a.push ( StringUtils.trim ( s.substr ( start, i - start ) ) );
			return a;
		}
		/**
		 * Renvoie un entier représentant le degré de sécurité de la chaîne <code>password</code>.
		 * <p>
		 * Pour obtenir le score maximum, la chaîne se doit de satisfaire à chacune de ces exigences : 
		 * </p>
		 * <ul>
		 * <li>Contenir des caractères en basse casse : <code>/[a-z]+/</code></li>		 * <li>Contenir des caractères en haute casse : <code>/[A-Z]+/</code></li>		 * <li>Contenir des caractères numériques : <code>/[0-9]+/</code></li>		 * <li>Contenir des caractères spéciaux : <code>/\W+/</code></li>
		 * </ul>
		 * <p>Chacun de ces critères compte pour un point dans le calcul du score
		 * de sécurité du mot de passe.</p>
		 * 
		 * @param	password	la chaîne de mot de passe à vérifier
		 * @return	un entier représentant le degré de sécurité de la chaîne
		 */
		public static function checkStrength( password : String ) : uint
		{
			var strength : uint = 0;
			
			if( password.search( _regSmall ) != -1 )
				strength ++;
			
			if( password.search( _regBig ) != -1 )
				strength ++;
			
			if( password.search( _regNum ) != -1 )
				strength ++;
			
			if( password.search( _regSpecial ) != -1 )
				strength ++;
			
			return strength;
		}
		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static var _regSmall : RegExp = new RegExp( /([a-z]+)/ );
		private static var _regBig : RegExp = new RegExp( /([A-Z]+)/ );
		private static var _regNum    : RegExp = new RegExp( /([0-9]+)/ );
		private static var _regSpecial : RegExp = new RegExp( /(\W+)/ );

		private static function escapePattern ( pattern : String ) : String
		{
			// RM: might expose this one, I've used it a few times already.
			return pattern.replace ( /(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1' );
		}

		private static function _minimum ( a : uint, b : uint, c : uint ) : uint
		{
			return Math.min ( a, Math.min ( b, Math.min ( c, a ) ) );
		}

		private static function _quote ( string : String, ...args ) : String
		{
			switch (string)
			{
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase ( char : String, ...args ) : String
		{
			return char.toUpperCase ();
		}

		private static var _currentSmartPattern : String;

		private static function _smartUpperCase ( char : String, ...args ) : String
		{
			return tokenReplace ( _currentSmartPattern, char.toUpperCase () );
		}

		private static function _swapCase ( char : String, ...args ) : String
		{
			var lowChar : String = char.toLowerCase ();
			var upChar : String = char.toUpperCase ();
			switch (char)
			{
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return char;
			}
		}
	}
}