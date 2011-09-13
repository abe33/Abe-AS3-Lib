/**
 * @license
 */
package  abe.com.patibility.lang 
{
    import abe.com.mon.core.Serializable;
	/**
	 * Enumération de tout les codes de langues tel que définit
	 * par la norme ISO 639-1. Chaque objet <code>Lang</code>
	 * contient le code ISO de la langue ainsi que son nom ISO
	 * en français.
	 * 
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="code,name")]    
	public class Lang implements Serializable
	{
		/*
		 * CLASS MEMBERS
		 *
		 */	
		/**
		 * Un objet permettant de relier les codes sous formes de chaînes 
		 * et les objets <code>Lang</code> correspondant.
		 */
		static private const map : Object = {};
		/**
		 * Insère un objet <code>Lang</code> dans la map de liaison.
		 * Les objets s'insère automatiquement lors de la création.
		 * 
		 * @param	key		le code de langue qui servira d'index
		 * @param	value	l'objet <code>Lang</code> correspondant
		 */
		static private function put ( key : String, value : Lang ) : void
		{
			map[ key ] = value;
		}	

		/**
		 * Permet de récupérer un objet <code>Lang</code> à partir de son
		 * code ISO sous forme de chaîne.
		 * 
		 * @param	key		le code ISO de la langue
		 * @return	l'objet <code>Lang</code> correspondant au code de langue
		 */	
		static public function get ( key : String ) : Lang
		{
			return map[ key ] as Lang;
		}

		/*
		 * ISO CODES ENUM
		 * 
		 * Toutes les langues répertoriées dans la norme ISO 639-1
		 * sous forme de constantes. 
		 * Les constantes sont triées dans l'ordre alphabétique des
		 * codes de langues.
		 *
		 * RegExp pour manipuler les constantes : 
		 * static public const ([^\s:]+)\s*: Lang = new Lang\( "([^"]+)","([^"]+)"\s*\);
		 * Remplacement pour la doc (penser à virer le backslash devant le slash de fermeture de commentaire) :
		 * /**\n\t\t * <strong>$3</strong>.\n\t\t * <p>Instance de la classe <code>Lang</code> représentant \n\t\t * le code de la langue correspondante (<code>$3</code>) de la norme ISO 639-1.</p>\n\t\t *\/\n\t\t$0
		 */
		
		/**
		 * <strong>Afar</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Afar</code>) de la norme ISO 639-1.</p>
		 */
		static public const AA : Lang = new Lang( "aa","Afar" 			);
		/**
		 * <strong>Abkhaze</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Abkhaze</code>) de la norme ISO 639-1.</p>
		 */
		static public const AB : Lang = new Lang( "ab","Abkhaze" 		);
		/**
		 * <strong>Avestique</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Avestique</code>) de la norme ISO 639-1.</p>
		 */
		static public const AE : Lang = new Lang( "ae","Avestique" 		);
		/**
		 * <strong>Afrikaans</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Afrikaans</code>) de la norme ISO 639-1.</p>
		 */
		static public const AF : Lang = new Lang( "af","Afrikaans" 		);
		/**
		 * <strong>Akan</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Akan</code>) de la norme ISO 639-1.</p>
		 */
		static public const AK : Lang = new Lang( "ak","Akan" 			);
		/**
		 * <strong>Amharique</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Amharique</code>) de la norme ISO 639-1.</p>
		 */
		static public const AM : Lang = new Lang( "am","Amharique" 		);
		/**
		 * <strong>Aragonais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Aragonais</code>) de la norme ISO 639-1.</p>
		 */
		static public const AN : Lang = new Lang( "an","Aragonais" 		);
		/**
		 * <strong>Arabe</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Arabe</code>) de la norme ISO 639-1.</p>
		 */
		static public const AR : Lang = new Lang( "ar","Arabe" 			);
		/**
		 * <strong>Assamais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Assamais</code>) de la norme ISO 639-1.</p>
		 */
		static public const AS : Lang = new Lang( "as","Assamais" 		);
		/**
		 * <strong>Avar</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Avar</code>) de la norme ISO 639-1.</p>
		 */
		static public const AV : Lang = new Lang( "av","Avar" 			);
		/**
		 * <strong>Aymara</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Aymara</code>) de la norme ISO 639-1.</p>
		 */
		static public const AY : Lang = new Lang( "ay","Aymara" 		);
		/**
		 * <strong>Azéri</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Azéri</code>) de la norme ISO 639-1.</p>
		 */
		static public const AZ : Lang = new Lang( "az","Azéri" 			);
		/**
		 * <strong>Bachkir</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bachkir</code>) de la norme ISO 639-1.</p>
		 */
		static public const BA : Lang = new Lang( "ba","Bachkir" 		);
		/**
		 * <strong>Biélorusse</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Biélorusse</code>) de la norme ISO 639-1.</p>
		 */
		static public const BE : Lang = new Lang( "be","Biélorusse" 	);
		/**
		 * <strong>Bulgare</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bulgare</code>) de la norme ISO 639-1.</p>
		 */
		static public const BG : Lang = new Lang( "bg","Bulgare" 		);
		/**
		 * <strong>Bihari</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bihari</code>) de la norme ISO 639-1.</p>
		 */
		static public const BH : Lang = new Lang( "bh","Bihari" 		);
		/**
		 * <strong>Bichelamar</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bichelamar</code>) de la norme ISO 639-1.</p>
		 */
		static public const BI : Lang = new Lang( "bi","Bichelamar" 	);
		/**
		 * <strong>Bambara</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bambara</code>) de la norme ISO 639-1.</p>
		 */
		static public const BM : Lang = new Lang( "bm","Bambara" 		);
		/**
		 * <strong>Bengalî</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bengalî</code>) de la norme ISO 639-1.</p>
		 */
		static public const BN : Lang = new Lang( "bn","Bengalî" 		);
		/**
		 * <strong>Tibétain</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tibétain</code>) de la norme ISO 639-1.</p>
		 */
		static public const BO : Lang = new Lang( "bo","Tibétain" 		);
		/**
		 * <strong>Breton</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Breton</code>) de la norme ISO 639-1.</p>
		 */
		static public const BR : Lang = new Lang( "br","Breton" 		);
		/**
		 * <strong>Bosnien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Bosnien</code>) de la norme ISO 639-1.</p>
		 */
		static public const BS : Lang = new Lang( "bs","Bosnien" 		);
		/**
		 * <strong>Catalan</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Catalan</code>) de la norme ISO 639-1.</p>
		 */
		static public const CA : Lang = new Lang( "ca","Catalan" 		);
		/**
		 * <strong>Tchétchène</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tchétchène</code>) de la norme ISO 639-1.</p>
		 */
		static public const CE : Lang = new Lang( "ce","Tchétchène" 	);
		/**
		 * <strong>Chamorro</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Chamorro</code>) de la norme ISO 639-1.</p>
		 */
		static public const CH : Lang = new Lang( "ch","Chamorro" 		);
		/**
		 * <strong>Corse</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Corse</code>) de la norme ISO 639-1.</p>
		 */
		static public const CO : Lang = new Lang( "co","Corse" 			);
		/**
		 * <strong>Cri</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Cri</code>) de la norme ISO 639-1.</p>
		 */
		static public const CR : Lang = new Lang( "cr","Cri" 			);
		/**
		 * <strong>Tchèque</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tchèque</code>) de la norme ISO 639-1.</p>
		 */
		static public const CS : Lang = new Lang( "cs","Tchèque" 		);
		/**
		 * <strong>Vieux</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Vieux</code>) de la norme ISO 639-1.</p>
		 */
		static public const CU : Lang = new Lang( "cu","Vieux" 			);
		/**
		 * <strong>Tchouvache</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tchouvache</code>) de la norme ISO 639-1.</p>
		 */
		static public const CV : Lang = new Lang( "cv","Tchouvache" 	);
		/**
		 * <strong>Gallois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Gallois</code>) de la norme ISO 639-1.</p>
		 */
		static public const CY : Lang = new Lang( "cy","Gallois" 		);
		/**
		 * <strong>Danois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Danois</code>) de la norme ISO 639-1.</p>
		 */
		static public const DA : Lang = new Lang( "da","Danois" 		);
		/**
		 * <strong>Allemand</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Allemand</code>) de la norme ISO 639-1.</p>
		 */
		static public const DE : Lang = new Lang( "de","Allemand" 		);
		/**
		 * <strong>Divehi</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Divehi</code>) de la norme ISO 639-1.</p>
		 */
		static public const DV : Lang = new Lang( "dv","Divehi" 		);
		/**
		 * <strong>Dzongkha</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Dzongkha</code>) de la norme ISO 639-1.</p>
		 */
		static public const DZ : Lang = new Lang( "dz","Dzongkha" 		);
		/**
		 * <strong>Ewe</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ewe</code>) de la norme ISO 639-1.</p>
		 */
		static public const EE : Lang = new Lang( "ee","Ewe" 			);
		/**
		 * <strong>Grec</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Grec</code>) de la norme ISO 639-1.</p>
		 */
		static public const EL : Lang = new Lang( "el","Grec" 			);
		/**
		 * <strong>Anglais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Anglais</code>) de la norme ISO 639-1.</p>
		 */
		static public const EN : Lang = new Lang( "en","Anglais" 		);
		/**
		 * <strong>Espéranto</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Espéranto</code>) de la norme ISO 639-1.</p>
		 */
		static public const EO : Lang = new Lang( "eo","Espéranto" 		);
		/**
		 * <strong>Espagnol</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Espagnol</code>) de la norme ISO 639-1.</p>
		 */
		static public const ES : Lang = new Lang( "es","Espagnol" 		);
		/**
		 * <strong>Estonien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Estonien</code>) de la norme ISO 639-1.</p>
		 */
		static public const ET : Lang = new Lang( "et","Estonien" 		);
		/**
		 * <strong>Basque</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Basque</code>) de la norme ISO 639-1.</p>
		 */
		static public const EU : Lang = new Lang( "eu","Basque" 		);
		/**
		 * <strong>Perse</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Perse</code>) de la norme ISO 639-1.</p>
		 */
		static public const FA : Lang = new Lang( "fa","Perse" 			);
		/**
		 * <strong>Peul</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Peul</code>) de la norme ISO 639-1.</p>
		 */
		static public const FF : Lang = new Lang( "ff","Peul" 			);
		/**
		 * <strong>Finnois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Finnois</code>) de la norme ISO 639-1.</p>
		 */
		static public const FI : Lang = new Lang( "fi","Finnois" 		);
		/**
		 * <strong>Fidjien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Fidjien</code>) de la norme ISO 639-1.</p>
		 */
		static public const FJ : Lang = new Lang( "fj","Fidjien" 		);
		/**
		 * <strong>Féringien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Féringien</code>) de la norme ISO 639-1.</p>
		 */
		static public const FO : Lang = new Lang( "fo","Féringien" 		);
		/**
		 * <strong>Français</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Français</code>) de la norme ISO 639-1.</p>
		 */
		static public const FR : Lang = new Lang( "fr","Français" 		);
		/**
		 * <strong>Frison</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Frison</code>) de la norme ISO 639-1.</p>
		 */
		static public const FY : Lang = new Lang( "fy","Frison" 		);
		/**
		 * <strong>Irlandais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Irlandais</code>) de la norme ISO 639-1.</p>
		 */
		static public const GA : Lang = new Lang( "ga","Irlandais" 		);
		/**
		 * <strong>Écossais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Écossais</code>) de la norme ISO 639-1.</p>
		 */
		static public const GD : Lang = new Lang( "gd","Écossais" 		);
		/**
		 * <strong>Galicien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Galicien</code>) de la norme ISO 639-1.</p>
		 */
		static public const GL : Lang = new Lang( "gl","Galicien" 		);
		/**
		 * <strong>Guarani</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Guarani</code>) de la norme ISO 639-1.</p>
		 */
		static public const GN : Lang = new Lang( "gn","Guarani" 		);
		/**
		 * <strong>Gujarâtî</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Gujarâtî</code>) de la norme ISO 639-1.</p>
		 */
		static public const GU : Lang = new Lang( "gu","Gujarâtî" 		);
		/**
		 * <strong>Mannois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Mannois</code>) de la norme ISO 639-1.</p>
		 */
		static public const GV : Lang = new Lang( "gv","Mannois" 		);
		/**
		 * <strong>Haoussa</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Haoussa</code>) de la norme ISO 639-1.</p>
		 */
		static public const HA : Lang = new Lang( "ha","Haoussa" 		);
		/**
		 * <strong>Hébreu</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Hébreu</code>) de la norme ISO 639-1.</p>
		 */
		static public const HE : Lang = new Lang( "he","Hébreu" 		);
		/**
		 * <strong>Hindî</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Hindî</code>) de la norme ISO 639-1.</p>
		 */
		static public const HI : Lang = new Lang( "hi","Hindî" 			);
		/**
		 * <strong>Hiri</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Hiri</code>) de la norme ISO 639-1.</p>
		 */
		static public const HO : Lang = new Lang( "ho","Hiri" 			);
		/**
		 * <strong>Croate</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Croate</code>) de la norme ISO 639-1.</p>
		 */
		static public const HR : Lang = new Lang( "hr","Croate" 		);
		/**
		 * <strong>Créole</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Créole</code>) de la norme ISO 639-1.</p>
		 */
		static public const HT : Lang = new Lang( "ht","Créole" 		);
		/**
		 * <strong>Hongrois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Hongrois</code>) de la norme ISO 639-1.</p>
		 */
		static public const HU : Lang = new Lang( "hu","Hongrois" 		);
		/**
		 * <strong>Arménien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Arménien</code>) de la norme ISO 639-1.</p>
		 */
		static public const HY : Lang = new Lang( "hy","Arménien" 		);
		/**
		 * <strong>Herero</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Herero</code>) de la norme ISO 639-1.</p>
		 */
		static public const HZ : Lang = new Lang( "hz","Herero" 		);
		/**
		 * <strong>Interlingua</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Interlingua</code>) de la norme ISO 639-1.</p>
		 */
		static public const IA : Lang = new Lang( "ia","Interlingua" 	);
		/**
		 * <strong>Indonésien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Indonésien</code>) de la norme ISO 639-1.</p>
		 */
		static public const ID : Lang = new Lang( "id","Indonésien" 	);
		/**
		 * <strong>Occidental</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Occidental</code>) de la norme ISO 639-1.</p>
		 */
		static public const IE : Lang = new Lang( "ie","Occidental" 	);
		/**
		 * <strong>Igbo</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Igbo</code>) de la norme ISO 639-1.</p>
		 */
		static public const IG : Lang = new Lang( "ig","Igbo" 			);
		/**
		 * <strong>Yi</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Yi</code>) de la norme ISO 639-1.</p>
		 */
		static public const II : Lang = new Lang( "ii","Yi" 			);
		/**
		 * <strong>Inupiaq</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Inupiaq</code>) de la norme ISO 639-1.</p>
		 */
		static public const IK : Lang = new Lang( "ik","Inupiaq" 		);
		/**
		 * <strong>Ido</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ido</code>) de la norme ISO 639-1.</p>
		 */
		static public const IO : Lang = new Lang( "io","Ido" 			);
		/**
		 * <strong>Islandais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Islandais</code>) de la norme ISO 639-1.</p>
		 */
		static public const IS : Lang = new Lang( "is","Islandais" 		);
		/**
		 * <strong>Italien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Italien</code>) de la norme ISO 639-1.</p>
		 */
		static public const IT : Lang = new Lang( "it","Italien" 		);
		/**
		 * <strong>Inuktitut</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Inuktitut</code>) de la norme ISO 639-1.</p>
		 */
		static public const IU : Lang = new Lang( "iu","Inuktitut" 		);
		/**
		 * <strong>Japonais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Japonais</code>) de la norme ISO 639-1.</p>
		 */
		static public const JA : Lang = new Lang( "ja","Japonais" 		);
		/**
		 * <strong>Javanais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Javanais</code>) de la norme ISO 639-1.</p>
		 */
		static public const JV : Lang = new Lang( "jv","Javanais" 		);
		/**
		 * <strong>Géorgien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Géorgien</code>) de la norme ISO 639-1.</p>
		 */
		static public const KA : Lang = new Lang( "ka","Géorgien" 		);
		/**
		 * <strong>Kikongo</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kikongo</code>) de la norme ISO 639-1.</p>
		 */
		static public const KG : Lang = new Lang( "kg","Kikongo" 		);
		/**
		 * <strong>Kikuyu</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kikuyu</code>) de la norme ISO 639-1.</p>
		 */
		static public const KI : Lang = new Lang( "ki","Kikuyu" 		);
		/**
		 * <strong>Kuanyama</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kuanyama</code>) de la norme ISO 639-1.</p>
		 */
		static public const KJ : Lang = new Lang( "kj","Kuanyama" 		);
		/**
		 * <strong>Kazakh</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kazakh</code>) de la norme ISO 639-1.</p>
		 */
		static public const KK : Lang = new Lang( "kk","Kazakh" 		);
		/**
		 * <strong>Kalaallisut</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kalaallisut</code>) de la norme ISO 639-1.</p>
		 */
		static public const KL : Lang = new Lang( "kl","Kalaallisut" 	);
		/**
		 * <strong>Khmer</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Khmer</code>) de la norme ISO 639-1.</p>
		 */
		static public const KM : Lang = new Lang( "km","Khmer" 			);
		/**
		 * <strong>Kannara</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kannara</code>) de la norme ISO 639-1.</p>
		 */
		static public const KN : Lang = new Lang( "kn","Kannara" 		);
		/**
		 * <strong>Coréen</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Coréen</code>) de la norme ISO 639-1.</p>
		 */
		static public const KO : Lang = new Lang( "ko","Coréen" 		);
		/**
		 * <strong>Kanouri</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kanouri</code>) de la norme ISO 639-1.</p>
		 */
		static public const KR : Lang = new Lang( "kr","Kanouri" 		);
		/**
		 * <strong>Kashmiri</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kashmiri</code>) de la norme ISO 639-1.</p>
		 */
		static public const KS : Lang = new Lang( "ks","Kashmiri" 		);
		/**
		 * <strong>Kurde</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kurde</code>) de la norme ISO 639-1.</p>
		 */
		static public const KU : Lang = new Lang( "ku","Kurde" 			);
		/**
		 * <strong>Komi</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Komi</code>) de la norme ISO 639-1.</p>
		 */
		static public const KV : Lang = new Lang( "kv","Komi" 			);
		/**
		 * <strong>Cornique</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Cornique</code>) de la norme ISO 639-1.</p>
		 */
		static public const KW : Lang = new Lang( "kw","Cornique" 		);
		/**
		 * <strong>Kirghiz</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kirghiz</code>) de la norme ISO 639-1.</p>
		 */
		static public const KY : Lang = new Lang( "ky","Kirghiz" 		);
		/**
		 * <strong>Latin</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Latin</code>) de la norme ISO 639-1.</p>
		 */
		static public const LA : Lang = new Lang( "la","Latin" 			);
		/**
		 * <strong>Luxembourgeois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Luxembourgeois</code>) de la norme ISO 639-1.</p>
		 */
		static public const LB : Lang = new Lang( "lb","Luxembourgeois" );
		/**
		 * <strong>Ganda</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ganda</code>) de la norme ISO 639-1.</p>
		 */
		static public const LG : Lang = new Lang( "lg","Ganda" 			);
		/**
		 * <strong>Limbourgeois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Limbourgeois</code>) de la norme ISO 639-1.</p>
		 */
		static public const LI : Lang = new Lang( "li","Limbourgeois" 	);
		/**
		 * <strong>Lingala</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Lingala</code>) de la norme ISO 639-1.</p>
		 */
		static public const LN : Lang = new Lang( "ln","Lingala" 		);
		/**
		 * <strong>Lao</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Lao</code>) de la norme ISO 639-1.</p>
		 */
		static public const LO : Lang = new Lang( "lo","Lao" 			);
		/**
		 * <strong>Lituanien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Lituanien</code>) de la norme ISO 639-1.</p>
		 */
		static public const LT : Lang = new Lang( "lt","Lituanien" 		);
		/**
		 * <strong>Tchiluba</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tchiluba</code>) de la norme ISO 639-1.</p>
		 */
		static public const LU : Lang = new Lang( "lu","Tchiluba" 		);
		/**
		 * <strong>Letton</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Letton</code>) de la norme ISO 639-1.</p>
		 */
		static public const LV : Lang = new Lang( "lv","Letton" 		);
		/**
		 * <strong>Malgache</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Malgache</code>) de la norme ISO 639-1.</p>
		 */
		static public const MG : Lang = new Lang( "mg","Malgache" 		);
		/**
		 * <strong>Marshallais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Marshallais</code>) de la norme ISO 639-1.</p>
		 */
		static public const MH : Lang = new Lang( "mh","Marshallais"	);
		/**
		 * <strong>Māori</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Māori</code>) de la norme ISO 639-1.</p>
		 */
		static public const MI : Lang = new Lang( "mi","Māori" 			);
		/**
		 * <strong>Macédonien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Macédonien</code>) de la norme ISO 639-1.</p>
		 */
		static public const MK : Lang = new Lang( "mk","Macédonien" 	);
		/**
		 * <strong>Malayalam</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Malayalam</code>) de la norme ISO 639-1.</p>
		 */
		static public const ML : Lang = new Lang( "ml","Malayalam" 		);
		/**
		 * <strong>Mongol</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Mongol</code>) de la norme ISO 639-1.</p>
		 */
		static public const MN : Lang = new Lang( "mn","Mongol" 		);
		/**
		 * <strong>Moldave</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Moldave</code>) de la norme ISO 639-1.</p>
		 */
		static public const MO : Lang = new Lang( "mo","Moldave" 		);
		/**
		 * <strong>Marâthî</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Marâthî</code>) de la norme ISO 639-1.</p>
		 */
		static public const MR : Lang = new Lang( "mr","Marâthî" 		);
		/**
		 * <strong>Malais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Malais</code>) de la norme ISO 639-1.</p>
		 */
		static public const MS : Lang = new Lang( "ms","Malais" 		);
		/**
		 * <strong>Maltais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Maltais</code>) de la norme ISO 639-1.</p>
		 */
		static public const MT : Lang = new Lang( "mt","Maltais" 		);
		/**
		 * <strong>Birman</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Birman</code>) de la norme ISO 639-1.</p>
		 */
		static public const MY : Lang = new Lang( "my","Birman" 		);
		/**
		 * <strong>Nauruan</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Nauruan</code>) de la norme ISO 639-1.</p>
		 */
		static public const NA : Lang = new Lang( "na","Nauruan" 		);
		/**
		 * <strong>Norvégien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Norvégien</code>) de la norme ISO 639-1.</p>
		 */
		static public const NB : Lang = new Lang( "nb","Norvégien" 		);
		/**
		 * <strong>Ndébélé</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ndébélé</code>) de la norme ISO 639-1.</p>
		 */
		static public const ND : Lang = new Lang( "nd","Ndébélé" 		);
		/**
		 * <strong>Népalais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Népalais</code>) de la norme ISO 639-1.</p>
		 */
		static public const NE : Lang = new Lang( "ne","Népalais" 		);
		/**
		 * <strong>Ndonga</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ndonga</code>) de la norme ISO 639-1.</p>
		 */
		static public const NG : Lang = new Lang( "ng","Ndonga" 		);
		/**
		 * <strong>Néerlandais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Néerlandais</code>) de la norme ISO 639-1.</p>
		 */
		static public const NL : Lang = new Lang( "nl","Néerlandais" 	);
		/**
		 * <strong>Norvégien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Norvégien</code>) de la norme ISO 639-1.</p>
		 */
		static public const NN : Lang = new Lang( "nn","Norvégien" 		);
		/**
		 * <strong>Norvégien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Norvégien</code>) de la norme ISO 639-1.</p>
		 */
		static public const NO : Lang = new Lang( "no","Norvégien" 		);
		/**
		 * <strong>Ndébélé</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ndébélé</code>) de la norme ISO 639-1.</p>
		 */
		static public const NR : Lang = new Lang( "nr","Ndébélé" 		);
		/**
		 * <strong>Navajo</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Navajo</code>) de la norme ISO 639-1.</p>
		 */
		static public const NV : Lang = new Lang( "nv","Navajo" 		);
		/**
		 * <strong>Chichewa</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Chichewa</code>) de la norme ISO 639-1.</p>
		 */
		static public const NY : Lang = new Lang( "ny","Chichewa" 		);
		/**
		 * <strong>Occitan</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Occitan</code>) de la norme ISO 639-1.</p>
		 */
		static public const OC : Lang = new Lang( "oc","Occitan" 		);
		/**
		 * <strong>Ojibwé</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ojibwé</code>) de la norme ISO 639-1.</p>
		 */
		static public const OJ : Lang = new Lang( "oj","Ojibwé" 		);
		/**
		 * <strong>Oromo</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Oromo</code>) de la norme ISO 639-1.</p>
		 */
		static public const OM : Lang = new Lang( "om","Oromo" 			);
		/**
		 * <strong>Oriya</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Oriya</code>) de la norme ISO 639-1.</p>
		 */
		static public const OR : Lang = new Lang( "or","Oriya" 			);
		/**
		 * <strong>Ossète</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ossète</code>) de la norme ISO 639-1.</p>
		 */
		static public const OS : Lang = new Lang( "os","Ossète" 		);
		/**
		 * <strong>Panjâbî</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Panjâbî</code>) de la norme ISO 639-1.</p>
		 */
		static public const PA : Lang = new Lang( "pa","Panjâbî" 		);
		/**
		 * <strong>Pâli</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Pâli</code>) de la norme ISO 639-1.</p>
		 */
		static public const PI : Lang = new Lang( "pi","Pâli" 			);
		/**
		 * <strong>Polonais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Polonais</code>) de la norme ISO 639-1.</p>
		 */
		static public const PL : Lang = new Lang( "pl","Polonais" 		);
		/**
		 * <strong>Pachto</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Pachto</code>) de la norme ISO 639-1.</p>
		 */
		static public const PS : Lang = new Lang( "ps","Pachto" 		);
		/**
		 * <strong>Portugais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Portugais</code>) de la norme ISO 639-1.</p>
		 */
		static public const PT : Lang = new Lang( "pt","Portugais" 		);
		/**
		 * <strong>Quechua</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Quechua</code>) de la norme ISO 639-1.</p>
		 */
		static public const QU : Lang = new Lang( "qu","Quechua" 		);
		/**
		 * <strong>Romanche</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Romanche</code>) de la norme ISO 639-1.</p>
		 */
		static public const RM : Lang = new Lang( "rm","Romanche" 		);
		/**
		 * <strong>Kirundi</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kirundi</code>) de la norme ISO 639-1.</p>
		 */
		static public const RN : Lang = new Lang( "rn","Kirundi" 		);
		/**
		 * <strong>Roumain</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Roumain</code>) de la norme ISO 639-1.</p>
		 */
		static public const RO : Lang = new Lang( "ro","Roumain" 		);
		/**
		 * <strong>Russe</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Russe</code>) de la norme ISO 639-1.</p>
		 */
		static public const RU : Lang = new Lang( "ru","Russe" 			);
		/**
		 * <strong>Kinyarwanda</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Kinyarwanda</code>) de la norme ISO 639-1.</p>
		 */
		static public const RW : Lang = new Lang( "rw","Kinyarwanda" 	);
		/**
		 * <strong>Sanskrit</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Sanskrit</code>) de la norme ISO 639-1.</p>
		 */
		static public const SA : Lang = new Lang( "sa","Sanskrit" 		);
		/**
		 * <strong>Sarde</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Sarde</code>) de la norme ISO 639-1.</p>
		 */
		static public const SC : Lang = new Lang( "sc","Sarde" 			);
		/**
		 * <strong>Sindhi</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Sindhi</code>) de la norme ISO 639-1.</p>
		 */
		static public const SD : Lang = new Lang( "sd","Sindhi" 		);
		/**
		 * <strong>Same</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Same</code>) de la norme ISO 639-1.</p>
		 */
		static public const SE : Lang = new Lang( "se","Same" 			);
		/**
		 * <strong>Sango</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Sango</code>) de la norme ISO 639-1.</p>
		 */
		static public const SG : Lang = new Lang( "sg","Sango" 			);
		/**
		 * <strong>Serbo-croate</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Serbo-croate</code>) de la norme ISO 639-1.</p>
		 */
		static public const SH : Lang = new Lang( "sh","Serbo-croate" 	);
		/**
		 * <strong>Cingalais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Cingalais</code>) de la norme ISO 639-1.</p>
		 */
		static public const SI : Lang = new Lang( "si","Cingalais" 		);
		/**
		 * <strong>Slovaque</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Slovaque</code>) de la norme ISO 639-1.</p>
		 */
		static public const SK : Lang = new Lang( "sk","Slovaque" 		);
		/**
		 * <strong>Slovène</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Slovène</code>) de la norme ISO 639-1.</p>
		 */
		static public const SL : Lang = new Lang( "sl","Slovène" 		);
		/**
		 * <strong>Samoan</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Samoan</code>) de la norme ISO 639-1.</p>
		 */
		static public const SM : Lang = new Lang( "sm","Samoan" 		);
		/**
		 * <strong>Shona</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Shona</code>) de la norme ISO 639-1.</p>
		 */
		static public const SN : Lang = new Lang( "sn","Shona" 			);
		/**
		 * <strong>Somali</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Somali</code>) de la norme ISO 639-1.</p>
		 */
		static public const SO : Lang = new Lang( "so","Somali" 		);
		/**
		 * <strong>Albanais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Albanais</code>) de la norme ISO 639-1.</p>
		 */
		static public const SQ : Lang = new Lang( "sq","Albanais" 		);
		/**
		 * <strong>Serbe</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Serbe</code>) de la norme ISO 639-1.</p>
		 */
		static public const SR : Lang = new Lang( "sr","Serbe" 			);
		/**
		 * <strong>Siswati</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Siswati</code>) de la norme ISO 639-1.</p>
		 */
		static public const SS : Lang = new Lang( "ss","Siswati" 		);
		/**
		 * <strong>Sotho</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Sotho</code>) de la norme ISO 639-1.</p>
		 */
		static public const ST : Lang = new Lang( "st","Sotho" 			);
		/**
		 * <strong>Sundanais</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Sundanais</code>) de la norme ISO 639-1.</p>
		 */
		static public const SU : Lang = new Lang( "su","Sundanais" 		);
		/**
		 * <strong>Suédois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Suédois</code>) de la norme ISO 639-1.</p>
		 */
		static public const SV : Lang = new Lang( "sv","Suédois" 		);
		/**
		 * <strong>Swahili</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Swahili</code>) de la norme ISO 639-1.</p>
		 */
		static public const SW : Lang = new Lang( "sw","Swahili" 		);
		/**
		 * <strong>Tamoul</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tamoul</code>) de la norme ISO 639-1.</p>
		 */
		static public const TA : Lang = new Lang( "ta","Tamoul" 		);
		/**
		 * <strong>Télougou</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Télougou</code>) de la norme ISO 639-1.</p>
		 */
		static public const TE : Lang = new Lang( "te","Télougou" 		);
		/**
		 * <strong>Tadjik</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tadjik</code>) de la norme ISO 639-1.</p>
		 */
		static public const TG : Lang = new Lang( "tg","Tadjik" 		);
		/**
		 * <strong>Thaï</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Thaï</code>) de la norme ISO 639-1.</p>
		 */
		static public const TH : Lang = new Lang( "th","Thaï" 			);
		/**
		 * <strong>Tigrinya</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tigrinya</code>) de la norme ISO 639-1.</p>
		 */
		static public const TI : Lang = new Lang( "ti","Tigrinya" 		);
		/**
		 * <strong>Turkmène</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Turkmène</code>) de la norme ISO 639-1.</p>
		 */
		static public const TK : Lang = new Lang( "tk","Turkmène" 		);
		/**
		 * <strong>Tagalog</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tagalog</code>) de la norme ISO 639-1.</p>
		 */
		static public const TL : Lang = new Lang( "tl","Tagalog" 		);
		/**
		 * <strong>Tswana</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tswana</code>) de la norme ISO 639-1.</p>
		 */
		static public const TN : Lang = new Lang( "tn","Tswana" 		);
		/**
		 * <strong>Tongien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tongien</code>) de la norme ISO 639-1.</p>
		 */
		static public const TO : Lang = new Lang( "to","Tongien" 		);
		/**
		 * <strong>Turc</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Turc</code>) de la norme ISO 639-1.</p>
		 */
		static public const TR : Lang = new Lang( "tr","Turc" 			);
		/**
		 * <strong>Tsonga</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tsonga</code>) de la norme ISO 639-1.</p>
		 */
		static public const TS : Lang = new Lang( "ts","Tsonga" 		);
		/**
		 * <strong>Tatar</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tatar</code>) de la norme ISO 639-1.</p>
		 */
		static public const TT : Lang = new Lang( "tt","Tatar" 			);
		/**
		 * <strong>Twi</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Twi</code>) de la norme ISO 639-1.</p>
		 */
		static public const TW : Lang = new Lang( "tw","Twi" 			);
		/**
		 * <strong>Tahitien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Tahitien</code>) de la norme ISO 639-1.</p>
		 */
		static public const TY : Lang = new Lang( "ty","Tahitien" 		);
		/**
		 * <strong>Ouïghour</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ouïghour</code>) de la norme ISO 639-1.</p>
		 */
		static public const UG : Lang = new Lang( "ug","Ouïghour" 		);
		/**
		 * <strong>Ukrainien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ukrainien</code>) de la norme ISO 639-1.</p>
		 */
		static public const UK : Lang = new Lang( "uk","Ukrainien" 		);
		/**
		 * <strong>Ourdou</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ourdou</code>) de la norme ISO 639-1.</p>
		 */
		static public const UR : Lang = new Lang( "ur","Ourdou" 		);
		/**
		 * <strong>Ouzbek</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Ouzbek</code>) de la norme ISO 639-1.</p>
		 */
		static public const UZ : Lang = new Lang( "uz","Ouzbek" 		);
		/**
		 * <strong>Venda</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Venda</code>) de la norme ISO 639-1.</p>
		 */
		static public const VE : Lang = new Lang( "ve","Venda" 			);
		/**
		 * <strong>Vietnamien</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Vietnamien</code>) de la norme ISO 639-1.</p>
		 */
		static public const VI : Lang = new Lang( "vi","Vietnamien" 	);
		/**
		 * <strong>Volapük</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Volapük</code>) de la norme ISO 639-1.</p>
		 */
		static public const VO : Lang = new Lang( "vo","Volapük" 		);
		/**
		 * <strong>Wallon</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Wallon</code>) de la norme ISO 639-1.</p>
		 */
		static public const WA : Lang = new Lang( "wa","Wallon" 		);
		/**
		 * <strong>Wolof</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Wolof</code>) de la norme ISO 639-1.</p>
		 */
		static public const WO : Lang = new Lang( "wo","Wolof" 			);
		/**
		 * <strong>Xhosa</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Xhosa</code>) de la norme ISO 639-1.</p>
		 */
		static public const XH : Lang = new Lang( "xh","Xhosa" 			);
		/**
		 * <strong>Yiddish</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Yiddish</code>) de la norme ISO 639-1.</p>
		 */
		static public const YI : Lang = new Lang( "yi","Yiddish" 		);
		/**
		 * <strong>Yoruba</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Yoruba</code>) de la norme ISO 639-1.</p>
		 */
		static public const YO : Lang = new Lang( "yo","Yoruba" 		);
		/**
		 * <strong>Zhuang</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Zhuang</code>) de la norme ISO 639-1.</p>
		 */
		static public const ZA : Lang = new Lang( "za","Zhuang" 		);
		/**
		 * <strong>Chinois</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Chinois</code>) de la norme ISO 639-1.</p>
		 */
		static public const ZH : Lang = new Lang( "zh","Chinois" 		);
		/**
		 * <strong>Zoulou</strong>.
		 * <p>Instance de la classe <code>Lang</code> représentant 
		 * le code de la langue correspondante (<code>Zoulou</code>) de la norme ISO 639-1.</p>
		 */
		static public const ZU : Lang = new Lang( "zu","Zoulou" 		);
				
		/*
		 * INSTANCE MEMBERS
		 */
		/**
		 * Le code de la langue sous forme de chaîne
		 */
		private var code : String;
		/**
		 * Le nom de la langue en Français
		 */
		private var name : String;
		
		/**
		 * Créer une nouvelle instance de la classe <code>Lang</code>.
		 * La nouvelle instance s'enregistrera d'elle même dans la map
		 * statique de la classe.
		 * <p>
		 * Normalement vous n'avez pas à créer vous-même d'instance de 
		 * la classe <code>Lang</code> étant donné que toutes les langues
		 * listées dans la norme ISO 639-1 sont disponibles en constantes
		 * de la classe <code>Lang</code>.
		 * </p>
		 * @param	code	le code de la langue tel que définie par 
		 * 					la norme ISO 639-1
		 * @param	name	le nom de la langue en français tel que
		 * 					définie par la norme ISO 639-1
		 */
		public function Lang( code : String, name : String )
		{
			this.code = code;
			this.name = name;
			put( code, this );
		}
		/**
		 * Renvoie le code ISO de la langue.
		 * 
		 * @return le code ISO de la langue
		 */
		public function getCode () : String 
		{
			return code;
		}
		/**
		 * Renvoie le nom de la langue en français.
		 * 
		 * @return le nom de la langue en français
		 */
		public function getName () : String 
		{
			return name;
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString () : String
		{
			return name +" (" + code + ")";
		}

	}
}
