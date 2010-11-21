/**
 * @license
 */
package  aesia.com.mon.utils 
{
	import aesia.com.mon.core.Iterator;

	/**
	 * Classe utilitaire de manipulation des objets <code>Date</code>. Cette classe comprend des
	 * fonctions de formatages, de comparaisons et de manipulations des dates.
	 * 
	 * @author Cédric Néhémie
	 */
	public class DateUtils 
	{
		/*-----------------------------------------------------------------------------------
		 * CONSTANTS
		 *----------------------------------------------------------------------------------*/
		/**
		 * Constante du nombre de jours dans une année bisextile.
		 */
		static public const BISEXTILE_YEARS_DAY_COUNT 			: Number = 366; 
		/**
		 * Longueurs des mois durant une année bisextile.
		 */
		static public const BISEXTILE_YEARS_MONTH_LENGTH 		: Array = [ 
																	31, 29, 31, 30,
																	31, 30, 31, 31,
																	30, 31, 30, 31 
																	]; 

		/**
		 * Constante du nombre de jours dans une année normale.
		 */
		static public const NOT_BISEXTILE_YEARS_DAY_COUNT 		: Number = 365; 
		/**
		 * Longueurs des mois durant une année normale. 
		 */
		static public const NOT_BISEXTILE_YEARS_MONTH_LENGTH 	: Array = [ 
																	31, 28, 31, 30,
																	31, 30, 31, 31,
																	30, 31, 30, 31 
																	];
				
		/**
		 * Tableau des noms de mois.
		 */													 	 
		static public const MONTHS_NAMES 						: Array = [
																	"January", "February", "March",
																	"April", 	"May", 		"June",
																	"July", 	"August", 	"September",
																	"October", "November", "December" 
																	];
		/**
		 * Tableau des noms de jours.
		 */
		static public const DAYS_NAMES 							: Array = [ 
																	"Sunday", 	"Monday",	"Tuesday",
																	"Wednesday", "Thursday", "Friday", 
																	"Saturday" 
																	];
		/**
		 * Tableau des zones horaires.
		 */
		static public const TIMEZONES							: Array = [
																	"IDLW", "NT", "HST", "AKST", "PST", "MST", "CST", "EST", "AST", 
											                        "ADT", "AT", "WAT", "GMT", "CET", "EET", "MSK", "ZP4", "ZP5", 
											                        "ZP6", "WAST", "WST", "JST", "AEST", "AEDT", "NZST" 
											                        ];
		/**
		 * Tableau des jours de la semaines en commencant par le lundi.
		 */								                        
		static public const MONDAY_STARTING_WEEK 				: Array = [ 7, 1, 2, 3, 4, 5, 6 ];

		/**
		 * Constante du nombres de millisecondes dans une journée.
		 */
		static public const MILLISECONDS_IN_DAY 				: Number = 1000 * 60 * 60 * 24;	
		/**
		 * Constante du nombre de millisecondes dans une heure.
		 */	
		static public const MILLISECONDS_IN_HOUR 				: Number = 1000 * 60 * 60;	
		/**
		 * Constante du nombre de millisecondes dans une minute.
		 */	
		static public const MILLISECONDS_IN_MINUTE 				: Number = 1000 * 60;	
		/**
		 * Constante du nombre de millisecondes dans une seconde.
		 */	
		static public const MILLISECONDS_IN_SECOND 				: Number = 1000;
		/**
		 * Suffixe pour les millisecondes.
		 */
		static public const MILLISECOND_SUFFIX 					: String = "ms";
		/**
		 * Suffixe pour les secondes.
		 */		static public const SECOND_SUFFIX 						: String = "s";
		/**
		 * Suffixe pour les minutes.
		 */		static public const MINUTE_SUFFIX 						: String = "mn";
		/**
		 * Suffixe pour les heures.
		 */		static public const HOUR_SUFFIX 						: String = "h";
		
		/*-----------------------------------------------------------------------------------
		 * HELPERS METHODS
		 *----------------------------------------------------------------------------------*/
		/**
		 * Renvoie une copie de l'objet <code>Date</code> transmis en paramètre.
		 * 
		 * @param	d	objet <code>Date</code> à cloner
		 * @return	une copie de l'objet <code>Date</code> transmis en paramètre
		 */
		static public function cloneDate( d : Date ) : Date
		{
			return new Date( d.fullYear, d.month, d.date, d.hours, d.minutes, d.seconds, d.milliseconds );
		}
		
		/*
		 * matched syntax : 
		 * 
		 * 5ms
		 * 5s 50ms
		 * 10mn 50ms
		 * 1h 35m 45s
		 */
		/**
		 * Convertie une chaîne de caratère en un nombre de millisecondes.
		 * <p>La fonction prend en compte les syntaxe suivantes : </p>
		 * <ul>
		 * <li><code>5ms</code></li>
		 * <li><code>5s 50ms</code></li>
		 * <li><code>10mn 50ms</code></li>
		 * <li><code>1h 35m 45s</code></li>
		 * </ul>
		 * 
		 * @param	str	chaîne à convertir en millisecondes
		 * @return	nombre de millisecondes
		 */
		static public function stringToMilliseconds ( str : String ) : Number
		{
			var a : Array = str.split(/\s/gi);
			var n : Number = 0;
			var l : Number = a.length;
			
			for( var i : Number = 0; i < l; i++ )
			{
				var s : String = a[i];
				switch( true )
				{
					case s.indexOf( MILLISECOND_SUFFIX ) != -1  :
						n += parseInt( s.replace( MILLISECOND_SUFFIX, "" ) ); 
						break;
					case s.indexOf( SECOND_SUFFIX ) != -1  :
						n += parseInt( s.replace( SECOND_SUFFIX, "" ) ) * MILLISECONDS_IN_SECOND; 
						break;
					case s.indexOf( MINUTE_SUFFIX ) != -1  :
						n += parseInt( s.replace( MINUTE_SUFFIX, "" ) ) * MILLISECONDS_IN_MINUTE; 
						break;
					case s.indexOf( HOUR_SUFFIX ) != -1 :
						n += parseInt( s.replace( HOUR_SUFFIX, "" ) ) * MILLISECONDS_IN_HOUR; 
						break;
					default : 
						n += parseInt( s );
						break;
				}
			}
			return n; 
		}
		/**
		 * Renvoie <code>true</code> si l'année <code>year</code> est bisextile.
		 * 
		 * @param	year	l'année dont on souhaite savoir si elle est bisextile
		 * @return	<code>true</code> si l'année <code>year</code> est bisextile
		 */
		static public function isBisextileYear ( year : Number ) : Boolean
		{
			return ( year % 4 == 0 && !( year % 100 == 0 ) ) || ( year % 400 == 0 );
		}
		/**
		 * Renvoie le nombre de jour dans le mois <code>month</code> de année <code>year</code>.
		 * 
		 * @param	year	année de référence
		 * @param	month	mois de l'année
		 * @return	le nombre de jour dans le mois
		 */
		static public function getMonthLength ( year : Number, month : Number ) : Number
		{
			return isBisextileYear( year ) ?
				   BISEXTILE_YEARS_MONTH_LENGTH[ month ] :
				   NOT_BISEXTILE_YEARS_MONTH_LENGTH[ month ];
		}
		/**
		 * Renvoie le nom du mois.
		 * 
		 * @param	month	mois dont on souhaite connaître le nom
		 * @return	le nom du mois
		 */
		static public function getMonthName ( month : Number ) : String
		{
			return MONTHS_NAMES[ month ];
		}
		/**
		 * Renvoie le nom du mois en version raccourcie sur trois lettres.
		 * 
		 * @param	month	mois dont on souhaite connaître le nom
		 * @return	le nom du mois
		 */
		static public function getMonthShortName ( month : Number ) : String
		{
			return MONTHS_NAMES[ month ].substr(0,3);
		}
		/**
		 * Renvoie le nom du jour.
		 * 
		 * @param	day	jour dont on souhaite connaître le nom
		 * @return	le nom du jour
		 */
		static public function getDayName ( day : Number ) : String
		{
			return DAYS_NAMES[ day ];
		}
		/**
		 * Renvoie le nom du jour en version raccourcie sur trois lettres.
		 * 
		 * @param	day	jour dont on souhaite connaître le nom
		 * @return	le nom du jour
		 */
		static public function getDayShortName ( day : Number ) : String
		{
			return DAYS_NAMES[ day ].substr(0,3);
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant au jour suivant <code>d</code>
		 * dans le calendrier.
		 * 
		 * @param	d	jour de référence
		 * @return	un objet <code>Date</code> correspondant au jour suivant
		 */
		static public function getDayAfter ( d : Date ) : Date
		{
			return new Date( d.getFullYear(), d.getMonth(), d.getDate() + 1 );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant au jour précédent <code>d</code>
		 * dans le calendrier.
		 * 
		 * @param	d	jour de référence
		 * @return	un objet <code>Date</code> correspondant au jour précédent
		 */
		static public function getDayBefore ( d : Date ) : Date
		{
			return new Date( d.getFullYear(), d.getMonth(), d.getDate() - 1 );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant au mois suivant <code>d</code>
		 * dans le calendrier.
		 * 
		 * @param	d	date de référence
		 * @return	un objet <code>Date</code> correspondant au mois suivant
		 */
		static public function getMonthAfter ( d : Date ) : Date
		{
			return new Date( d.getFullYear(), d.getMonth() + 1 );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant au mois précédent <code>d</code>
		 * dans le calendrier.
		 * 
		 * @param	d	date de référence
		 * @return	un objet <code>Date</code> correspondant au mois précédent
		 */
		static public function getMonthBefore ( d : Date ) : Date
		{
			return new Date( d.getFullYear(), d.getMonth() - 1 );
		}
		/**
		 * Renvoie <code>true</code> si la date <code>futur</code> se situe après
		 * la date <code>ref</code> dans le temps.
		 * 
		 * @param	futur	date à tester
		 * @param	ref		date de référence
		 * @return	<code>true</code> si la date se situe après dans le temps
		 */
		static public function isFutureDate ( futur : Date, ref : Date ) : Boolean
		{	
			return futur.time > ref.time;
		}
		/**
		 * Renvoie <code>true</code> si la date <code>futur</code> se situe avant
		 * la date <code>ref</code> dans le temps.
		 * 
		 * @param	past	date à tester
		 * @param	ref		date de référence
		 * @return	<code>true</code> si la date se situe avant dans le temps
		 */
		static public function isPastDate ( past : Date, ref : Date ) : Boolean
		{	
			return past.time < ref.time;
		}
		/**
		 * Renvoie le nombre de jour entre les deux dates.
		 * 
		 * @param	from	date de départ
		 * @param	to		date d'arrivée
		 * @return	le nombre de jour entre les deux dates
		 */
		static public function getDistance ( from : Date, to : Date ) : Number
		{
			var i : Iterator = dayIterator( from, to );
			var n : Number = 0;
			while( i.hasNext() )
			{
				i.next();
				n++;
			}
			return n;
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date <code>from</code>
		 * un an plus tard.
		 * 
		 * @param	from	date de référence
		 * @return	un objet <code>Date</code> correspondant à la date un an plus tard
		 */
		static public function oneYearLater ( from : Date ) : Date
		{
			if( isBisextileYear( from.getFullYear() ) )
				return getFutureDateAt( from, BISEXTILE_YEARS_DAY_COUNT );			else
				return getFutureDateAt( from, NOT_BISEXTILE_YEARS_DAY_COUNT );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date <code>from</code>
		 * un an plus tôt.
		 * 
		 * @param	from	date de référence
		 * @return	un objet <code>Date</code> correspondant à la date un an plus tôt
		 */
		static public function oneYearBefore ( from : Date ) : Date
		{
			if( isBisextileYear( from.getFullYear() ) )
				return getPastDateAt( from, BISEXTILE_YEARS_DAY_COUNT );
			else
				return getPastDateAt( from, NOT_BISEXTILE_YEARS_DAY_COUNT );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date <code>from</code>
		 * un mois plus tard.
		 * 
		 * @param	from	date de référence
		 * @return	un objet <code>Date</code> correspondant à la date un mois plus tard
		 */
		static public function oneMonthLater ( from : Date ) : Date
		{
			if( isBisextileYear( from.getFullYear() ) )
				return getFutureDateAt( from, BISEXTILE_YEARS_MONTH_LENGTH[ from.getMonth() ] );
			else
				return getFutureDateAt( from, NOT_BISEXTILE_YEARS_MONTH_LENGTH[ from.getMonth() ] );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date <code>from</code>
		 * un mois plus tôt.
		 * 
		 * @param	from	date de référence
		 * @return	un objet <code>Date</code> correspondant à la date un mois plus tôt
		 */
		static public function oneMonthBefore ( from : Date ) : Date
		{
			if( isBisextileYear( from.getFullYear() ) )
				return getPastDateAt( from, BISEXTILE_YEARS_MONTH_LENGTH[ from.getMonth() ] );
			else
				return getPastDateAt( from, NOT_BISEXTILE_YEARS_MONTH_LENGTH[ from.getMonth() ] );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date situé à <code>daysTo</code>
		 * jours de la date <code>from</code>.
		 * 
		 * @param	from	date de référence
		 * @param	daysTo	nombre de jours à ajouter
		 * @return	un objet <code>Date</code> correspondant à la date situé à <code>daysTo</code>
		 * 			jours de la date <code>from</code>
		 */
		static public function getFutureDateAt ( from : Date, daysTo : Number ) : Date
		{
			return new Date( from.getFullYear( ), 
						     from.getMonth(), 
							 from.getDate() + daysTo, 
							 from.getHours(), 
							 from.getMinutes(), 
							 from.getSeconds(), 
							 from.getMilliseconds() );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date situé à <code>daysTo</code>
		 * jours avant la date <code>from</code>.
		 * 
		 * @param	from	date de référence
		 * @param	daysTo	nombre de jours à soustraire
		 * @return	un objet <code>Date</code> correspondant à la date situé à <code>daysTo</code>
		 * 			jours avant la date <code>from</code>
		 */
		static public function getPastDateAt ( from : Date, daysSince : Number ) : Date
		{
			return new Date( from.getFullYear( ), 
						     from.getMonth(), 
							 from.getDate() - daysSince, 
							 from.getHours(), 
							 from.getMinutes(), 
							 from.getSeconds(), 
							 from.getMilliseconds() );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date situé à <code>n</code>
		 * millisecondes de la date <code>from</code>.
		 * 
		 * @param	from	date de référence
		 * @param	n		nombre de millisecondes à ajouter
		 * @return	un objet <code>Date</code> correspondant à la date situé à <code>n</code>
		 * 			millisecondes de la date <code>from</code>
		 */
		static public function getTimeAfter ( from : Date, n : Number ) : Date
		{
			return new Date(  from.getFullYear( ), 
							  from.getMonth(), 
							  from.getDate(), 
							  from.getHours(), 
							  from.getMinutes(), 
							  from.getSeconds(), 
							  from.getMilliseconds() + n );
		}
		/**
		 * Renvoie un objet <code>Date</code> correspondant à la date situé à <code>n</code>
		 * millisecondes avant la date <code>from</code>.
		 * 
		 * @param	from	date de référence
		 * @param	n		nombre de millisecondes à soustraire
		 * @return	un objet <code>Date</code> correspondant à la date situé à <code>n</code>
		 * 			millisecondes avant la date <code>from</code>
		 */
		static public function getTimeBefore ( from : Date, n : Number ) : Date
		{
			return new Date(  from.getFullYear( ), 
							  from.getMonth(), 
							  from.getDate(), 
							  from.getHours(), 
							  from.getMinutes(), 
							  from.getSeconds(), 
							  from.getMilliseconds() - n );
		}
		/**
		 * Renvoie un objet <code>Iterator</code> parcourant les jours dans l'interval
		 * entre <code>from</code> et <code>to</code>.
		 * 
		 * @param	from	date de départ
		 * @param	to		date d'arrivée
		 * @return	un objet <code>Iterator</code> parcourant les jours dans l'interval
		 * 			entre <code>from</code> et <code>to</code>
		 */
		static public function dayIterator ( from : Date, to : Date ) : Iterator
		{
			return new DayIterator( from, to );
		}
		/**
		 * Renvoie un objet <code>Iterator</code> parcourant les mois dans l'interval
		 * entre <code>from</code> et <code>to</code>.
		 * 
		 * @param	from	date de départ
		 * @param	to		date d'arrivée
		 * @return	un objet <code>Iterator</code> parcourant les mois dans l'interval
		 * 			entre <code>from</code> et <code>to</code>
		 */
		static public function monthIterator ( from : Date, to : Date ) : Iterator
		{
			return new MonthIterator( from, to );
		}
		/**
		 * Renvoie une chaîne de caractère au format <code>Vd Wh Xmn Ys Zms</code>.
		 * 
		 * @param	time	nombre de millisecondes à convertir
		 * @return	une chaîne de caractère au format <code>Vd Wh Xmn Ys Zms</code>
		 */
		static public function getTimeAsDuration ( time : Number ) : String
		{
			var rest : Number = time;
			var days : Number;
			var hours : Number;
			var minutes : Number;
			var seconds : Number;
			var t : Number;
			
			if( rest > MILLISECONDS_IN_DAY )
			{
				t = rest % MILLISECONDS_IN_DAY;
				days = (rest - t) / MILLISECONDS_IN_DAY;
				rest = t;
			} 
			else
			{
				days = 0;
			}
			 
			if( rest > MILLISECONDS_IN_HOUR )
			{
				t = rest % MILLISECONDS_IN_HOUR;
				hours = (rest - t) / MILLISECONDS_IN_HOUR;
				rest = t;
			}
			else
			{
				hours = 0;
			}
			
			if( rest > MILLISECONDS_IN_MINUTE )
			{
				t = rest % MILLISECONDS_IN_MINUTE;
				minutes = (rest - t) / MILLISECONDS_IN_MINUTE;
				rest = t;
			}
			else
			{
				minutes = 0;
			}
			
			if( rest > MILLISECONDS_IN_SECOND )
			{
				t = rest % MILLISECONDS_IN_SECOND;
				seconds = (rest - t) / MILLISECONDS_IN_SECOND;
				rest = t;
			}
			else
			{
				seconds = 0;
			}
			
			return days + " d " +
				   hours + " h " + 
				   minutes + " mn " +
				   seconds + " s " + 
				   Math.round(rest) + " ms";
		}
		/**
		 * Renvoie la représentation formatée à l'aide du format <code>format</code> de l'objet
		 * <code>date</code> transmis en paramètre.
		 * <p>
		 * <strong>Jours</strong>
		 * </p>
		 * <ul>
		 * <li><code>d</code> : Le jour du mois avec un zéro de départ, de 01 à 31.</li>
		 * <li><code>D</code> : Une représentation textuelle du jour, en trois lettres, de Mon à Sun.</li>
		 * <li><code>j</code> : Le jour du mois sans les zéros de départ, de 1 ) 31.</li>
		 * <li><code>l</code> : Une représentation textuelle complète du jour, de Sunday à Monday.</li>
		 * <li><code>N</code> : Une représentation numérique du jour de la semaine selon la norme ISO-8601
		 * de 1 (Monday) à 7 (Sunday).</li>
		 * <li><code>S</code> : Suffixe ordinal anglais pour le jour du mois, en deux lettre, st, nd, rd ou th.
		 * Fonctionne bien avec <code>j</code>.</li>
		 * <li><code>w</code> : Représentation numérique du jour de la semaine, de 0 (Sunday) à 6 (Saturday).</li>
		 * <li><code>z</code> : Le jour de l'année, partant de 0, de 0 à 365.</li>
		 * </ul>
		 * <strong>Semaines</strong>
		 * <ul>
		 * <li><code>W</code> : Numéro de la semaine dans l'année, les semaines démarrant un lundi, 
		 * selon la norme ISO-8601.</li>
		 * </ul>
		 * <strong>Mois</strong>
		 * <ul>
		 * <li><code>F</code> : Une représentation textuelle complète d'un mois, tel January ou March, de January à December.</li>
		 * <li><code>m</code> : Une représentation numérique du mois, avec un zéro de départ, de 01 à 12.</li>
		 * <li><code>M</code> : Une courte représentation textuelle du mois, en trois lettre, de Jan à Dec.</li>
		 * <li><code>n</code> : Une représentation numérique du mois, sans le zéro de départ, de 1 à 12.</li>
		 * <li><code>t</code> : Nombre de jour dans le mois, de 28 à 31.</li>
		 * </ul>
		 * <strong>Années</strong>
		 * <ul>
		 * <li><code>L</code> : S'agit-il d'une année bisextile, 1 si oui, 0 si non.</li>
		 * <li><code>Y</code> : Une représentation numérique complète de l'année, en quatre nombres.
		 * Tel 1993 ou 2010.</li>
		 * <li><code>y</code> : Une réprésentation numérique partielle de l'année, en deux nombres.
		 * Tel 93 ou 10.</li>
		 * </ul>
		 * <strong>Heures</strong>
		 * <ul>
		 * <li><code>a</code> : Version en basse casse des Ante meridiem et Post meridiem, am ou pm.</li>
		 * <li><code>A</code> : Version en capitales des Ante meridiem et Post meridiem, AM ou PM.</li>
		 * <li><code>B</code> : Temps internet, de 000 à 999.</li>
		 * <li><code>g</code> : Heure au format 12 heures, sans zéro de départ, de 1 à 12.</li>
		 * <li><code>G</code> : Heure au format 24 heures, sans zéro de départ, de 0 à 23.</li>
		 * <li><code>h</code> : Heure au format 12 heures, avec zéro de départ, de 01 à 12.</li>
		 * <li><code>H</code> : Heure au format 24 heures, avec zéro de départ, de 00 à 23.</li>
		 * <li><code>i</code> : Minutes avec zéro de départ, de 00 à 59.</li>
		 * <li><code>s</code> : Secondes avec zéro de départ, de 00 à 59.</li>
		 * <li><code>u</code> : Millisecondes, exemple 54321.</li>
		 * </ul>
		 * <strong>Timezone</strong>
		 * <ul>
		 * <li><code>e</code> : Identifiant de la zone horaire, tel UTC, GMT ou Atlantic/Azores.</li>
		 * <li><code>I</code> : La date est-elle en heure d'été, 1 si oui, 0 si non.</li>
		 * <li><code>O</code> : Difference au temps de Greenwich (GMT), en heures, exemple : +0200.</li>
		 * <li><code>P</code> : Différence au temps de Greenwich (GMT), avec un séparateur entre heures 
		 * et minutes, exemple : +02:00.</li>
		 * <li><code>T</code> : Abbréviation de la zone horaire, exemple : EST, MDT, etc...</li>
		 * <li><code>Z</code> : Décalage de la zone horaire en secondes. Le décalage pour les zones horaires
		 * à l'ouest et toujours négatif, le décalages pour les zones de l'est étant toujours positif.</li>
		 * </ul>
		 * <strong>Date/Temps complet</strong>
		 * <ul>
		 * <li><code>c</code> : Formatage de date ISO 8601 : 2004-02-12T15:19:21+00:00</li>
		 * <li><code>r</code> : Formatage de date RFC 2822 : Thu, 21 Dec 2000 16:01:07 +0200</li>
		 * <li><code>U</code> : Nombre de secondes de puis l'époque UNIX (January 1 1970 00:00:00 GMT).</li>
		 *  </ul>
		 *  
		 * @param	date	l'objet <code>Date</code> à formater
		 * @param 	format	le format à utiliser
		 * @return	la date formatée selon le format défini
		 */
		static public function format( date : Date, format:String ):String
		{
			return parseFormatString( date, format );
		}
		
		/*-----------------------------------------------------------------------------------
		 * PHP DATE LIKE METHODS
		 *----------------------------------------------------------------------------------*/
		/*
		 * Parse la date selon le format
		 */
		static private function parseFormatString( date : Date, format:String ):String
		{
			var result:String = "";
			var d : Date = date;
			
			//get single chars from the full format string
			var chars:Array =  format.split( "" );
			
			//iterating over all chars
			chars.forEach( 
					function( item:String, index:int, array:Array ):void
					{
						/*
						 * check if the current char was escaped if true don't
						 * parse it
						 */
						if( item != "\\" )
						{
							if( (index > 0 && array[index-1] != "\\" ) || index == 0 )
							{
								result += parseSingleChar( item, d );
							}
							else if( item != "\\" )
							{
								result += item;
							}
						}
					});
							
			return result;
		}
		
		/*
		 * Parse un caractère
		 */
		static private function parseSingleChar( item:String, date : Date  ):String
		{
			/*
			 * checking if some regexp match to the given char, if false
			 * give back the original item
			 */ 
			if( item.match( /a/ ) )
				return getAmPm( date );

			else if( item.match( /A/ ) )
				return getAmPm( date, true  );

			else if( item.match( /B/ ) )
				return getSwatchInternetTime( date );

			else if( item.match( /c/ ) )
				return getIso8601( date );

			else if( item.match( /d/ ) )
				return getDayOfMonth( date );

			else if( item.match( /D/ ) )
				return getWeekDayAsText(  date, true );

			else if( item.match( /F/ ) )
				return getMonthAsText( date );

			else if( item.match( /g/ ) )
				return getHours( date, false, true );
			
			else if( item.match( /G/ ) )
				return getHours( date, false );

			else if( item.match( /h/ ) )
				return getHours( date, true, true );
			
			else if( item.match( /H/ ) )
				return getHours( date );

			else if( item.match( /i/ ) )
				return getMinutes( date );

			else if( item.match( /I/ ) )
				return getSummertime( date );

			else if( item.match( /j/ ) )
				return getDayOfMonth ( date, false );

			else if( item.match( /l/ ) )
				return getWeekDayAsText( date );

			else if( item.match( /L/ ) )
				return getLeapYear( date );

			else if( item.match( /m/ ) )
				return getMonth( date );

			else if( item.match( /M/ ) )
				return getMonthAsText( date, true );

			else if( item.match( /n/ ) )
				return getMonth(  date, false );

			else if( item.match( /N/ ) )
				return getIso8601Day( date );

			else if( item.match( /O/ ) )
				return getDifferenceBetweenGmt( date );

			else if( item.match( /P/ ) )
				return getDifferenceBetweenGmt( date, ":" );
			
			else if( item.match( /r/ ) )
				return getRfc2822( date );
			
			else if( item.match( /s/ ) )
				return getSeconds( date );

			else if( item.match( /S/ ) )
				return getMonthDayOrdinalSuffix( date );
			
			else if( item.match( /t/ ) )
				return getDaysOfMonth( date );
			
			else if( item.match( /T/ ) ) 
				return getTimezone( date );
			
			else if( item.match( /u/ ) )
				return getMilliseconds( date );

			else if( item.match( /U/ ) )
				return getUnixTimestamp( date );

			else if( item.match( /w/ ) )
				return getWeekDay( date );

			else if( item.match( /W/ ) )
				return getWeekOfYear( date );

			else if( item.match( /y/ ) )
				return getYear( date, true );

			else if( item.match( /Y/ ) )
				return getYear( date );
			
			else if( item.match( /z/ ) )
				return getDayOfYear( date );
			
			else if( item.match( /Z/ ) )
				return getTimezoneOffset( date );
			
			else
				return item;
		}
		
		/*
		 * Heure d'été
		 */
		static private function getSummertime( date : Date  ):String
		{
			if( isSummertime( date ) )
				return "1";
			
			return "0";
		}
		
		/*
		 * Heure d'été
		 */
		static private function isSummertime( date : Date ):Boolean
		{
			var currentOffset:Number = date.getTimezoneOffset();
			var referenceOffset:Number;

			var month:Number = 1;
						
			while ( month-- ) {
				referenceOffset = ( new Date( date.getFullYear(), month, 1 ) )
						.getTimezoneOffset();
				
				if( currentOffset != referenceOffset
					&& currentOffset < referenceOffset )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/*
		 * Temps UNIX
		 */
		static private function getUnixTimestamp( date : Date ):String
		{
			return String( Math.floor( date.getTime() / 1000 ) );
		}
		
		/*
		 * Temps ISO
		 */
		static private function getIso8601( date : Date ):String
		{
			return getYear( date ) + "-" + getMonth( date ) + "-" + getDayOfMonth( date ) + "T"
					+ getHours( date ) + ":" + getMinutes( date ) + ":" + getSeconds( date )
					+ getDifferenceBetweenGmt( date, ":");
		}
		
		static private function getIso8601Day( date : Date ):String
		{
			return String( MONDAY_STARTING_WEEK[ date.getDay() ] );
		}
		
		/*
		 * Temps RFC
		 */
		static private function getRfc2822( date : Date ):String
		{
			return getWeekDayAsText( date, true ) + ", " + getDayOfMonth( date ) + " " 
				+ getMonthAsText( date, true ) + " " + getYear(date ) + " "
				+ getHours( date ) + ":" + getMinutes( date ) + ":" + getSeconds( date )
				+ " " + getDifferenceBetweenGmt( date );
		}
		
		/*
		 * Zone horaire
		 */
		static private function getTimezone( date : Date ):String
		{
			var offset:Number = Math.round(11 + 
					-( date.getTimezoneOffset() / 60) );
			
			if( isSummertime( date ) )
				offset--;
				
			return TIMEZONES[ offset ];
		}
		
		/*
		 * Différence avec Greenwich
		 */
		static private function getDifferenceBetweenGmt(  date : Date, seperator:String='' ):String
		{
			var timezoneOffset:Number = -date.getTimezoneOffset();
			
			//sets the prefix
			var pre:String;
			if( timezoneOffset > 0 )
				pre = "+";
			else
				pre = "-";
			
			var hours:Number = Math.floor( timezoneOffset / 60 );
			var min:Number = timezoneOffset - ( hours * 60 );

			// building the return string			
			var result:String = pre;
			if( hours < 9 )
				result += "0";//adding leading zero to hours
			result += hours.toString();
			result += seperator;
			if( min < 9 )
				result += "0";//adding leading zero to minutes
			result += min;	
			
			return result;
		}
		
		/*
		 * Décalage zone horaire
		 */
		static private function getTimezoneOffset( date : Date ):String
		{
			return String( date.getTimezoneOffset()*60  );
		}
		
		/*
		 * number of days in the current month (such as 28-31)
		 * 
		 * @return Stirng
		 */
		static private function getDaysOfMonth( date : Date ):String
		{
			return String( new Date( date.getFullYear(), date.getMonth() + 1, 0 ).getDate() );
		}

		/**
		 * returns the beats of the swatch internet time
		 * 
		 * @return String
		 */
		static private function getSwatchInternetTime( date : Date ):String
		{
			// get passed seconds for the day
			var daySeconds:int = ( date.getUTCHours() * 3600 ) 
					+ ( date.getUTCMinutes() * 60 )
					+ ( date.getUTCSeconds() )
					+ 3600; // caused of the BMT Meridian
			
			// 1day = 1000 .beat ... 1 second = 0.01157 .beat 		
			return String( Math.round( daySeconds * 0.01157 ) );
		}
		
		/**
		 * return the two chars ordinal suffix of the month day (such as th, st,
		 * nd, rd )
		 * 
		 * @retun String; 
		 */
		static private function getMonthDayOrdinalSuffix( date : Date ):String
		{
			var day:String = date.getDate().toString();
			switch( day.charAt( day.length - 1 ) )
			{
				case "1":
					return "st";
					break;
				
				case "2":
					return "nd";
					break;

				case "3":
					return "rd";
					break;
				
				default:
					return "th";
					break;				
			} 
		}
		
		/**
		 * returns the month as text (such as Janury - December or Jan - Dec)
		 * 
		 * @param Boolean flag to get the short version of month, optional
		 * @return String 
		 */
		static private function getMonthAsText( date : Date, short:Boolean = false ):String
		{
			if( short == true )
			{
				return String( getMonthName( date.month ) ).substr( 0, 3 );	
			}
			return getMonthName( date.month );
		}
		
		/**
		 * returns the milliseconds (such as 415)
		 * 
		 * @return String
		 */
		static private function getMilliseconds( date : Date  ) : String
		{
			return String( date.getMilliseconds() );
		}
		
		/**
		 * return seconds (such as 0-59 or 00-59)
		 * 
		 * @param Flag to add leading zero, optional default = true
		 * @return String
		 */	
		static private function getSeconds( date : Date, leadingZero:Boolean = true ):String
		{
			if( leadingZero == true && date.getSeconds() <= 9 )
			{
				return "0" + date.getSeconds().toString();
			}
			return String( date.getSeconds() );
		}
	
		/**
		 * returns the minutes (such as 0-59 or 00-59)
		 * 
		 * @param flag for adding a leading zero, optional default = true
		 * @return String
		 */
		static private function getMinutes( date : Date, leadingZero:Boolean = true ):String
		{
			if( leadingZero == true && date.getMinutes() <= 9 )
			{
				return "0" + date.getMinutes().toString();
			}
			return String( date.getMinutes() );
		}
		
		/**
		 * returns the hours in diffrent formats( such as 0-12, 00-12, 0-23, 
		 * 00-23 )
		 * 
		 * @param Boolean switch to add a leading zero, optional
		 * @param Boolean switch to get in in 12h instead 24h, optional
		 * @return String
		 */
		static private function getHours( date : Date, leadingZero:Boolean = true, 
				twelfHours:Boolean = false ):String
		{
			var hours:int;
			if( twelfHours == true )
			{
				if( date.getHours() > 12 )
				{
					hours = date.getHours() - 12;
				}
			}
			else
			{
				hours = date.getHours();
			}
			
			if( leadingZero == true && hours <= 9 )
			{
				return "0" + hours.toString();
			}
			return String( hours );
		}
		
		/**
		 * returns am (ante meridiem) or pm (post meridiem)
		 * 
		 * @param Boolean flag to get an upper-case string
		 * @return String am or pm
		 */
		static private function getAmPm( date : Date, upperCase:Boolean = false ):String
		{
			var result:String = "am";
			if( date.hours > 12 )
			{
				result = "pm";
			}
			
			if( upperCase == true )
			{
				return result.toUpperCase();
			}
			return result;			
		}
		
		/**
		 * returns the numeric weekday ( 0 Sunday - 6 Saturday )
		 * 
		 * @return String
		 */
		static private function getWeekDay( date : Date ):String
		{
			return String( date.getDay() );
		}
		
		/**
		 * returns the weekday in textual presentation (such as Monday or Mon)
		 * 
		 * @param Boolean flag to switch between short and long weekdays
		 * @return String
		 */
		static private function getWeekDayAsText( date : Date, short:Boolean = false ):String
		{
			if( short == true )
			{
				return String( getDayName( date.getDay() ) ).substr( 0, 3 );
			}
			return getDayName( date.getDay() );
		}
		
		/**
		 * returns 1 if leap year, else 0 (as String)
		 * 
		 * return String
		 */
		static private function getLeapYear( date : Date ):String
		{
			if( isLeapYear( date ) )
				return "1";
			return "0";
		}
		
		/**
		 * returns true if the year is a leap year
		 * 
		 * @return Boolean
		 */
		static private function isLeapYear( date : Date):Boolean
		{
			if( ( date.getFullYear() % 4 == 0 )
				&& ( ( date.getFullYear() % 100 != 0 ) 
					|| ( date.getFullYear() % 400 == 0 ) ) )
			{
				return true;
			}
			return false;
		}
		
		/**
		 * returns the number of the current week for the year, a week starts
		 * with monday
		 * 
		 * @return String
		 */
		static private function getWeekOfYear( date : Date ):String
		{
			//number of passed days
			var dayOfYear:Number = Number( getDayOfYear( date ) );
			//january 1st of the current year
			var firstDay:Date = new Date( date.getFullYear(), 0, 1 );
			
			/*
			 * remove Days of the first and the current week to get the realy
			 * passed weeks
			 */
			var fullWeeks:Number = ( dayOfYear 
					- ( 
						MONDAY_STARTING_WEEK[ date.getDay() ] 
						+ ( 7 - MONDAY_STARTING_WEEK[ firstDay.getDay() ] ) 
					) ) / 7;  
			
			/*
			 * the first week of this year only matters if it has more than 3
			 * in the current year
			 */
			if( MONDAY_STARTING_WEEK[ firstDay.getDay() ] <= 4 )
			{
				fullWeeks++;
			}
			
			//adding the current week
			fullWeeks++;
			
			return String( fullWeeks );		
		}
		
		/**
		 * returns the day of the year, starting with 0 (0-365)
		 * 
		 * return String
		 */		
		static private function getDayOfYear( date : Date ):String
		{
			var firstDayOfYear:Date = new Date( date.getFullYear(), 0, 1 );
			var millisecondsOffset:Number = date.getTime() 
					- firstDayOfYear.getTime();
			return String( Math.floor( millisecondsOffset / 86400000 ) );
		}
		
		/**
		 * returns the year (such as 2008 or 08)
		 * 
		 * @param Boolean flag to get the year as two digits
		 * @return String
		 */
		static private function getYear( date : Date, twoDigits:Boolean = false ):String
		{
			if( twoDigits == true )
			{
				//cut the year for the last two digits and return it
				return String( date.getFullYear() ).substr( 2,2 );
			}
			return String( date.getFullYear() );
		}
		
		/**
		 * returns the month (1-12 or 01-12), with optional leading zero
		 * 
		 * @param Boolean optional flag to add a leading zero
		 * @return String month (1-12 or 01-12)
		 */
		static private function getMonth( date : Date, leadingZero:Boolean = true ):String
		{
			var month:Number = date.getMonth() + 1;
			if( leadingZero == true && month <= 9 )
			{
				return "0" + String( month );
			}
			return String( month );
		}
		
		/**
		 * returns day of the month (1-31 or 01-31), with optional leading zero
		 * 
		 * @param Boolean optional flag to add a leading zero to the day 
		 * @return day of the month (1-31 or 01-31)
		 */
		static private function getDayOfMonth( date : Date, leadingZero:Boolean = true ):String
		{
			if( leadingZero == true && date.getDate() <= 9 )
			{
				return "0" + String( date.getDate() );
			}
			return String( date.getDate() );
		}
	}
}

import aesia.com.mon.core.Iterator;
import aesia.com.mon.utils.DateUtils;

internal class DayIterator implements Iterator
{
	private var from : Date;
	private var to : Date;
	private var current : Date;
	
	public function DayIterator ( from : Date, to : Date )
	{
		this.from = from;
		this.to = to;
		this.current = DateUtils.getDayBefore( from );
	}

	public function hasNext () : Boolean
	{
		return !DateUtils.isFutureDate( DateUtils.getDayAfter( current ), to );
	}
	
	public function next () : *
	{
		return current = DateUtils.getDayAfter( current );
	}
	
	public function reset () : void
	{
		this.current = DateUtils.getDayBefore( from );
	}

	public function remove () : void
	{
		throw new Error( "La fonction remove() n'est pas supportée par la classe DayIterator" );
	}
}
internal class MonthIterator implements Iterator
{
	private var from : Date;
	private var to : Date;
	private var current : Date;
	
	public function MonthIterator ( from : Date, to : Date )
	{
		this.from = from;
		this.to = to;
		this.current = DateUtils.getMonthBefore( from );
	}

	public function hasNext () : Boolean
	{
		return !DateUtils.isFutureDate( DateUtils.getMonthAfter( current ), to );
	}
	
	public function reset () : void
	{
		this.current = DateUtils.getMonthBefore( from );
	}
	
	public function next () : *
	{
		return current = DateUtils.getMonthAfter( current );
	}

	public function remove () : void
	{
		throw new Error( "La fonction remove() n'est pas supportée par la classe MonthIterator" );
	}
}