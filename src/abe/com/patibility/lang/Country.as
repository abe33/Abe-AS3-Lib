/**
 * @license
 */
package  abe.com.patibility.lang 
{
	import flash.utils.getQualifiedClassName;
	import  abe.com.mon.core.Serializable;	
	
	/**
	 * Enumération de tout les codes de pays tel que définit
	 * par la norme ISO 3166-1. Chaque objet <code>Country</code>
	 * contient le code ISO du pays ainsi que son nom ISO
	 * en français.
	 * 
	 * @author Cédric Néhémie
	 */
	public class Country implements Serializable
	{
		/*
		 * CLASS MEMBERS
		 */
		/**
		 * Un objet permettant de relier les codes sous formes de chaînes 
		 * et les objets <code>Country</code> correspondant.
		 */
		static private const map : Object = {};
		/**
		 * Insère un objet <code>Country</code> dans la map de liaison.
		 * Les objets s'insère automatiquement lors de la création.
		 * 
		 * @param	key		le code du pays qui servira d'index
		 * @param	value	l'objet <code>Country</code> correspondant
		 */
		static private function put ( key : String, value : Country ) : void
		{
			map[ key ] = value;
		}
		/**
		 * Permet de récupérer un objet <code>Country</code> à partir de son
		 * code ISO sous forme de chaîne.
		 * 
		 * @param	key		le code ISO du pays
		 * @return	l'objet <code>Country</code> correspondant au code du pays
		 */	
		static public function get ( key : String ) : Country
		{
			return map[ key ] as Country;
		}
		 
		/*
		 * ISO CODES ENUM
		 * 
		 * Tous les pays répertoriées dans la norme ISO 3166-1
		 * sous forme de constantes. 
		 * Les constantes sont triées dans l'ordre alphabétique des
		 * noms de pays.
		 *
		 * RegExp pour manipuler les constantes : 
		 * static public const ([^\s:]+)\s*: Country = new Country \( "([^"]+)", "([^"]+)"\s*\);
		 * Remplacement pour la doc (penser à virer le backslash devant le slash de fermeture de commentaire) :
		 * /**\n\t\t * <strong>$3</strong>.\n\t\t * <p>Instance de la classe <code>Country</code> représentant \n\t\t * le code du pays correspondant (<code>$3</code>) de la norme ISO 3166-1.</p>\n\t\t *\/\n\t\t$0
		 */
		/**
		 * <strong><img src="../../../countries/AF.png"/> Afghanistan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Afghanistan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AF : Country = new Country ( "AF", "Afghanistan" 								);
		/**
		 * <strong><img src="../../../countries/ZA.png"/> Afrique du Sud</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Afrique du Sud</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ZA : Country = new Country ( "ZA", "Afrique du Sud" 							);
		/**
		 * <strong><img src="../../../countries/AX.png"/> Åland Aland</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Åland Aland</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AX : Country = new Country ( "AX", "Åland Aland" 								);
		/**
		 * <strong><img src="../../../countries/AL.png"/> Albanie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Albanie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AL : Country = new Country ( "AL", "Albanie" 									);
		/**
		 * <strong><img src="../../../countries/DZ.png"/> Algérie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Algérie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const DZ : Country = new Country ( "DZ", "Algérie" 									);
		/**
		 * <strong><img src="../../../countries/DE.png"/> Allemagne</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Allemagne</code>) de la norme ISO 3166-1.</p>
		 */
		static public const DE : Country = new Country ( "DE", "Allemagne" 									);
		/**
		 * <strong><img src="../../../countries/AD.png"/> Andorre</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Andorre</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AD : Country = new Country ( "AD", "Andorre" 									);
		/**
		 * <strong><img src="../../../countries/AO.png"/> Angola</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Angola</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AO : Country = new Country ( "AO", "Angola" 									);
		/**
		 * <strong><img src="../../../countries/AI.png"/> Antigua-et-Barbuda</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Antigua-et-Barbuda</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AI : Country = new Country ( "AI", "Antigua-et-Barbuda" 						);
		/**
		 * <strong><img src="../../../countries/AN.png"/> Antilles néerlandaises</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Antilles néerlandaises</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AN : Country = new Country ( "AN", "Antilles néerlandaises" 					);
		/**
		 * <strong><img src="../../../countries/SA.png"/> Argentine</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Argentine</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SA : Country = new Country ( "SA", "Argentine" 									);
		/**
		 * <strong><img src="../../../countries/AM.png"/> Arménie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Arménie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AM : Country = new Country ( "AM", "Arménie" 									);
		/**
		 * <strong><img src="../../../countries/AW.png"/> Aruba</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Aruba</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AW : Country = new Country ( "AW", "Aruba" 										);
		/**
		 * <strong><img src="../../../countries/AU.png"/> Australie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Australie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AU : Country = new Country ( "AU", "Australie" 									);
		/**
		 * <strong><img src="../../../countries/AT.png"/> Autriche</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Autriche</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AT : Country = new Country ( "AT", "Autriche" 									);
		/**
		 * <strong><img src="../../../countries/AZ.png"/> Azerbaïdjan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Azerbaïdjan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AZ : Country = new Country ( "AZ", "Azerbaïdjan" 								);
		/**
		 * <strong><img src="../../../countries/BS.png"/> Bahamas</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bahamas</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BS : Country = new Country ( "BS", "Bahamas" 									);
		/**
		 * <strong><img src="../../../countries/BH.png"/> Bahreïn</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bahreïn</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BH : Country = new Country ( "BH", "Bahreïn" 									);
		/**
		 * <strong><img src="../../../countries/BD.png"/> Barbade</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Barbade</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BD : Country = new Country ( "BD", "Barbade" 									);
		/**
		 * <strong><img src="../../../countries/BY.png"/> Biélorussie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Biélorussie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BY : Country = new Country ( "BY", "Biélorussie" 								);
		/**
		 * <strong><img src="../../../countries/BE.png"/> Belize</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Belize</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BE : Country = new Country ( "BE", "Belize" 									);
		/**
		 * <strong><img src="../../../countries/BJ.png"/> Bénin</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bénin</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BJ : Country = new Country ( "BJ", "Bénin" 										);
		/**
		 * <strong><img src="../../../countries/BM.png"/> Bhoutan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bhoutan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BM : Country = new Country ( "BM", "Bhoutan" 									);
		/**
		 * <strong><img src="../../../countries/BO.png"/> Bolivie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bolivie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BO : Country = new Country ( "BO", "Bolivie" 									);
		/**
		 * <strong><img src="../../../countries/BA.png"/> Bosnie-Herzégovine</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bosnie-Herzégovine</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BA : Country = new Country ( "BA", "Bosnie-Herzégovine" 						);
		/**
		 * <strong><img src="../../../countries/BW.png"/> Botswana</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Botswana</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BW : Country = new Country ( "BW", "Botswana" 									);
		/**
		 * <strong><img src="../../../countries/BV.png"/> Brésil</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Brésil</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BV : Country = new Country ( "BV", "Brésil" 									);
		/**
		 * <strong><img src="../../../countries/BN.png"/> Bulgarie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Bulgarie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BN : Country = new Country ( "BN", "Bulgarie" 									);
		/**
		 * <strong><img src="../../../countries/BF.png"/> Burkina Faso</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Burkina Faso</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BF : Country = new Country ( "BF", "Burkina Faso" 								);
		/**
		 * <strong><img src="../../../countries/BI.png"/> îles Caïman</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>îles Caïman</code>) de la norme ISO 3166-1.</p>
		 */
		static public const BI : Country = new Country ( "BI", "îles Caïman" 								);
		/**
		 * <strong><img src="../../../countries/KH.png"/> Cambodge Cambodge</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Cambodge Cambodge</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KH : Country = new Country ( "KH", "Cambodge Cambodge" 							);
		/**
		 * <strong><img src="../../../countries/CM.png"/> Cameroun</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Cameroun</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CM : Country = new Country ( "CM", "Cameroun" 									);
		/**
		 * <strong><img src="../../../countries/CA.png"/> Canada</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Canada</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CA : Country = new Country ( "CA", "Canada" 									);
		/**
		 * <strong><img src="../../../countries/CV.png"/> Cap-Vert</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Cap-Vert</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CV : Country = new Country ( "CV", "Cap-Vert" 									);
		/**
		 * <strong><img src="../../../countries/CF.png"/> Chili</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Chili</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CF : Country = new Country ( "CF", "Chili" 										);
		/**
		 * <strong><img src="../../../countries/CN.png"/> République populaire de Chine</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>République populaire de Chine</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CN : Country = new Country ( "CN", "République populaire de Chine" 				);
		/**
		 * <strong><img src="../../../countries/CX.png"/> Chypre</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Chypre</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CX : Country = new Country ( "CX", "Chypre" 									);
		/**
		 * <strong><img src="../../../countries/CC.png"/> Comores</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Comores</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CC : Country = new Country ( "CC", "Comores" 									);
		/**
		 * <strong><img src="../../../countries/CG.png"/> République démocratique du Congo</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>République démocratique du Congo</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CG : Country = new Country ( "CG", "République démocratique du Congo" 			);
		/**
		 * <strong><img src="../../../countries/CK.png"/> Îles Cook</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Îles Cook</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CK : Country = new Country ( "CK", "Îles Cook" 									);
		/**
		 * <strong><img src="../../../countries/KR.png"/> Corée du Sud</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Corée du Sud</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KR : Country = new Country ( "KR", "Corée du Sud" 								);
		/**
		 * <strong><img src="../../../countries/KP.png"/> Corée du Nord</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Corée du Nord</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KP : Country = new Country ( "KP", "Corée du Nord" 								);
		/**
		 * <strong><img src="../../../countries/CR.png"/> Costa Rica</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Costa Rica</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CR : Country = new Country ( "CR", "Costa Rica" 								);
		/**
		 * <strong><img src="../../../countries/CI.png"/> Côte d'Ivoire</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Côte d'Ivoire</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CI : Country = new Country ( "CI", "Côte d'Ivoire" 								);
		/**
		 * <strong><img src="../../../countries/HR.png"/> Croatie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Croatie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const HR : Country = new Country ( "HR", "Croatie" 									);
		/**
		 * <strong><img src="../../../countries/CU.png"/> Danemark</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Danemark</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CU : Country = new Country ( "CU", "Danemark" 									);
		/**
		 * <strong><img src="../../../countries/DJ.png"/> Djibouti</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Djibouti</code>) de la norme ISO 3166-1.</p>
		 */
		static public const DJ : Country = new Country ( "DJ", "Djibouti" 									);
		/**
		 * <strong><img src="../../../countries/DO.png"/> République dominicaine</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>République dominicaine</code>) de la norme ISO 3166-1.</p>
		 */
		static public const DO : Country = new Country ( "DO", "République dominicaine" 					);
		/**
		 * <strong><img src="../../../countries/DM.png"/> Égypte</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Égypte</code>) de la norme ISO 3166-1.</p>
		 */
		static public const DM : Country = new Country ( "DM", "Égypte" 									);
		/**
		 * <strong><img src="../../../countries/SV.png"/> Salvador</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Salvador</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SV : Country = new Country ( "SV", "Salvador" 									);
		/**
		 * <strong><img src="../../../countries/AE.png"/> Équateur</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Équateur</code>) de la norme ISO 3166-1.</p>
		 */
		static public const AE : Country = new Country ( "AE", "Équateur" 									);
		/**
		 * <strong><img src="../../../countries/ER.png"/> Estonie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Estonie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ER : Country = new Country ( "ER", "Estonie" 									);
		/**
		 * <strong><img src="../../../countries/US.png"/> États-Unis</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>États-Unis</code>) de la norme ISO 3166-1.</p>
		 */
		static public const US : Country = new Country ( "US", "États-Unis" 								);
		/**
		 * <strong><img src="../../../countries/ET.png"/> Éthiopie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Éthiopie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ET : Country = new Country ( "ET", "Éthiopie" 									);
		/**
		 * <strong><img src="../../../countries/FK.png"/> Fidji</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Fidji</code>) de la norme ISO 3166-1.</p>
		 */
		static public const FK : Country = new Country ( "FK", "Fidji" 										);
		/**
		 * <strong><img src="../../../countries/FI.png"/> Finlande</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Finlande</code>) de la norme ISO 3166-1.</p>
		 */
		static public const FI : Country = new Country ( "FI", "Finlande" 									);
		/**
		 * <strong><img src="../../../countries/FR.png"/> France</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>France</code>) de la norme ISO 3166-1.</p>
		 */
		static public const FR : Country = new Country ( "FR", "France" 									);
		/**
		 * <strong><img src="../../../countries/GA.png"/> Gambie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Gambie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GA : Country = new Country ( "GA", "Gambie" 									);
		/**
		 * <strong><img src="../../../countries/GE.png"/> Ghana</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Ghana</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GE : Country = new Country ( "GE", "Ghana" 										);
		/**
		 * <strong><img src="../../../countries/GI.png"/> Grèce</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Grèce</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GI : Country = new Country ( "GI", "Grèce" 										);
		/**
		 * <strong><img src="../../../countries/GD.png"/> Grenade</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Grenade</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GD : Country = new Country ( "GD", "Grenade" 									);
		/**
		 * <strong><img src="../../../countries/GL.png"/> Guam</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Guam</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GL : Country = new Country ( "GL", "Guam" 										);
		/**
		 * <strong><img src="../../../countries/GT.png"/> Guatemala</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Guatemala</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GT : Country = new Country ( "GT", "Guatemala" 									);
		/**
		 * <strong><img src="../../../countries/GG.png"/> Guernesey</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Guernesey</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GG : Country = new Country ( "GG", "Guernesey" 									);
		/**
		 * <strong><img src="../../../countries/GN.png"/> Guinée-Bissau</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Guinée-Bissau</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GN : Country = new Country ( "GN", "Guinée-Bissau" 								);
		/**
		 * <strong><img src="../../../countries/GQ.png"/> Guinée équatoriale</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Guinée équatoriale</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GQ : Country = new Country ( "GQ", "Guinée équatoriale" 						);
		/**
		 * <strong><img src="../../../countries/GY.png"/> Guyana Guyana</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Guyana Guyana</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GY : Country = new Country ( "GY", "Guyana Guyana" 								);
		/**
		 * <strong><img src="../../../countries/GF.png"/> Haïti</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Haïti</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GF : Country = new Country ( "GF", "Haïti" 										);
		/**
		 * <strong><img src="../../../countries/HM.png"/> Hong Kong</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Hong Kong</code>) de la norme ISO 3166-1.</p>
		 */
		static public const HM : Country = new Country ( "HM", "Hong Kong" 									);
		/**
		 * <strong><img src="../../../countries/HU.png"/> Hongrie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Hongrie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const HU : Country = new Country ( "HU", "Hongrie" 									);
		/**
		 * <strong><img src="../../../countries/IM.png"/> Îles Vierges britanniques</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Îles Vierges britanniques</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IM : Country = new Country ( "IM", "Îles Vierges britanniques" 					);
		/**
		 * <strong><img src="../../../countries/VI.png"/> Îles Vierges américaines</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Îles Vierges américaines</code>) de la norme ISO 3166-1.</p>
		 */
		static public const VI : Country = new Country ( "VI", "Îles Vierges américaines" 					);
		/**
		 * <strong><img src="../../../countries/IN.png"/> Inde</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Inde</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IN : Country = new Country ( "IN", "Inde" 										);
		/**
		 * <strong><img src="../../../countries/ID.png"/> Indonésie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Indonésie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ID : Country = new Country ( "ID", "Indonésie" 									);
		/**
		 * <strong><img src="../../../countries/IR.png"/> Iran</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Iran</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IR : Country = new Country ( "IR", "Iran" 										);
		/**
		 * <strong><img src="../../../countries/IQ.png"/> Irak</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Irak</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IQ : Country = new Country ( "IQ", "Irak" 										);
		/**
		 * <strong><img src="../../../countries/IE.png"/> Irlande</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Irlande</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IE : Country = new Country ( "IE", "Irlande" 									);
		/**
		 * <strong><img src="../../../countries/IS.png"/> Islande</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Islande</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IS : Country = new Country ( "IS", "Islande" 									);
		/**
		 * <strong><img src="../../../countries/IL.png"/> Israël</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Israël</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IL : Country = new Country ( "IL", "Israël" 									);
		/**
		 * <strong><img src="../../../countries/IT.png"/> Italie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Italie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IT : Country = new Country ( "IT", "Italie" 									);
		/**
		 * <strong><img src="../../../countries/JM.png"/> Jamaïque</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Jamaïque</code>) de la norme ISO 3166-1.</p>
		 */
		static public const JM : Country = new Country ( "JM", "Jamaïque" 									);
		/**
		 * <strong><img src="../../../countries/JP.png"/> Japon</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Japon</code>) de la norme ISO 3166-1.</p>
		 */
		static public const JP : Country = new Country ( "JP", "Japon" 										);
		/**
		 * <strong><img src="../../../countries/JE.png"/> Jordanie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Jordanie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const JE : Country = new Country ( "JE", "Jordanie" 									);
		/**
		 * <strong><img src="../../../countries/KZ.png"/> Kazakhstan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Kazakhstan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KZ : Country = new Country ( "KZ", "Kazakhstan" 								);
		/**
		 * <strong><img src="../../../countries/KE.png"/> Kenya</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Kenya</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KE : Country = new Country ( "KE", "Kenya" 										);
		/**
		 * <strong><img src="../../../countries/KG.png"/> Kirghizistan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Kirghizistan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KG : Country = new Country ( "KG", "Kirghizistan" 								);
		/**
		 * <strong><img src="../../../countries/KI.png"/> Koweït</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Koweït</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KI : Country = new Country ( "KI", "Koweït" 									);
		/**
		 * <strong><img src="../../../countries/LA.png"/> Laos</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Laos</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LA : Country = new Country ( "LA", "Laos" 										);
		/**
		 * <strong><img src="../../../countries/LS.png"/> Lettonie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Lettonie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LS : Country = new Country ( "LS", "Lettonie" 									);
		/**
		 * <strong><img src="../../../countries/LB.png"/> Liban</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Liban</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LB : Country = new Country ( "LB", "Liban" 										);
		/**
		 * <strong><img src="../../../countries/LR.png"/> Liechtenstein</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Liechtenstein</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LR : Country = new Country ( "LR", "Liechtenstein" 								);
		/**
		 * <strong><img src="../../../countries/LT.png"/> Lituanie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Lituanie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LT : Country = new Country ( "LT", "Lituanie" 									);
		/**
		 * <strong><img src="../../../countries/LU.png"/> Luxembourg</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Luxembourg</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LU : Country = new Country ( "LU", "Luxembourg" 								);
		/**
		 * <strong><img src="../../../countries/MO.png"/> Macédoine</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Macédoine</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MO : Country = new Country ( "MO", "Macédoine" 									);
		/**
		 * <strong><img src="../../../countries/MG.png"/> Malaisie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Malaisie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MG : Country = new Country ( "MG", "Malaisie" 									);
		/**
		 * <strong><img src="../../../countries/MW.png"/> Malawi</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Malawi</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MW : Country = new Country ( "MW", "Malawi" 									);
		/**
		 * <strong><img src="../../../countries/MV.png"/> Mali</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Mali</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MV : Country = new Country ( "MV", "Mali" 										);
		/**
		 * <strong><img src="../../../countries/MT.png"/> Malte</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Malte</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MT : Country = new Country ( "MT", "Malte" 										);
		/**
		 * <strong><img src="../../../countries/MP.png"/> Maroc</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Maroc</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MP : Country = new Country ( "MP", "Maroc" 										);
		/**
		 * <strong><img src="../../../countries/MH.png"/> Maurice</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Maurice</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MH : Country = new Country ( "MH", "Maurice" 									);
		/**
		 * <strong><img src="../../../countries/MR.png"/> Mauritanie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Mauritanie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MR : Country = new Country ( "MR", "Mauritanie" 								);
		/**
		 * <strong><img src="../../../countries/YT.png"/> Mexique</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Mexique</code>) de la norme ISO 3166-1.</p>
		 */
		static public const YT : Country = new Country ( "YT", "Mexique" 									);
		/**
		 * <strong><img src="../../../countries/FM.png"/> Micronésie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Micronésie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const FM : Country = new Country ( "FM", "Micronésie" 								);
		/**
		 * <strong><img src="../../../countries/MD.png"/> Monaco</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Monaco</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MD : Country = new Country ( "MD", "Monaco" 									);
		/**
		 * <strong><img src="../../../countries/MN.png"/> Mongolie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Mongolie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MN : Country = new Country ( "MN", "Mongolie" 									);
		/**
		 * <strong><img src="../../../countries/ME.png"/> Monténégro</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Monténégro</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ME : Country = new Country ( "ME", "Monténégro" 								);
		/**
		 * <strong><img src="../../../countries/MS.png"/> Mozambique</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Mozambique</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MS : Country = new Country ( "MS", "Mozambique" 								);
		/**
		 * <strong><img src="../../../countries/MM.png"/> Namibie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Namibie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const MM : Country = new Country ( "MM", "Namibie" 									);
		/**
		 * <strong><img src="../../../countries/NR.png"/> Nicaragua</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Nicaragua</code>) de la norme ISO 3166-1.</p>
		 */
		static public const NR : Country = new Country ( "NR", "Nicaragua" 									);
		/**
		 * <strong><img src="../../../countries/NE.png"/> Niger</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Niger</code>) de la norme ISO 3166-1.</p>
		 */
		static public const NE : Country = new Country ( "NE", "Niger" 										);
		/**
		 * <strong><img src="../../../countries/NG.png"/> Nigeria</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Nigeria</code>) de la norme ISO 3166-1.</p>
		 */
		static public const NG : Country = new Country ( "NG", "Nigeria" 									);
		/**
		 * <strong><img src="../../../countries/NU.png"/> Norvège</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Norvège</code>) de la norme ISO 3166-1.</p>
		 */
		static public const NU : Country = new Country ( "NU", "Norvège" 									);
		/**
		 * <strong><img src="../../../countries/NC.png"/> Nouvelle-Zélande</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Nouvelle-Zélande</code>) de la norme ISO 3166-1.</p>
		 */
		static public const NC : Country = new Country ( "NC", "Nouvelle-Zélande" 							);
		/**
		 * <strong><img src="../../../countries/IO.png"/> Territoire britannique de l'océan Indien</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Territoire britannique de l'océan Indien</code>) de la norme ISO 3166-1.</p>
		 */
		static public const IO : Country = new Country ( "IO", "Territoire britannique de l'océan Indien" 	);
		/**
		 * <strong><img src="../../../countries/OM.png"/> Oman</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Oman</code>) de la norme ISO 3166-1.</p>
		 */
		static public const OM : Country = new Country ( "OM", "Oman" 										);
		/**
		 * <strong><img src="../../../countries/UG.png"/> Ouganda</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Ouganda</code>) de la norme ISO 3166-1.</p>
		 */
		static public const UG : Country = new Country ( "UG", "Ouganda" 									);
		/**
		 * <strong><img src="../../../countries/UZ.png"/> Ouzbékistan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Ouzbékistan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const UZ : Country = new Country ( "UZ", "Ouzbékistan" 								);
		/**
		 * <strong><img src="../../../countries/PK.png"/> Pakistan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Pakistan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PK : Country = new Country ( "PK", "Pakistan" 									);
		/**
		 * <strong><img src="../../../countries/PW.png"/> Panamá</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Panamá</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PW : Country = new Country ( "PW", "Panamá" 									);
		/**
		 * <strong><img src="../../../countries/PG.png"/> Papouasie-Nouvelle-Guinée</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Papouasie-Nouvelle-Guinée</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PG : Country = new Country ( "PG", "Papouasie-Nouvelle-Guinée" 					);
		/**
		 * <strong><img src="../../../countries/PY.png"/> Pays-Bas</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Pays-Bas</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PY : Country = new Country ( "PY", "Pays-Bas" 									);
		/**
		 * <strong><img src="../../../countries/PE.png"/> Pérou</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Pérou</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PE : Country = new Country ( "PE", "Pérou" 										);
		/**
		 * <strong><img src="../../../countries/PH.png"/> Porto Rico </strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Porto Rico </code>) de la norme ISO 3166-1.</p>
		 */
		static public const PH : Country = new Country ( "PH", "Porto Rico " 								);
		/**
		 * <strong><img src="../../../countries/PT.png"/> Portugal</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Portugal</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PT : Country = new Country ( "PT", "Portugal" 									);
		/**
		 * <strong><img src="../../../countries/QA.png"/> Qatar</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Qatar</code>) de la norme ISO 3166-1.</p>
		 */
		static public const QA : Country = new Country ( "QA", "Qatar" 										);
		/**
		 * <strong><img src="../../../countries/RE.png"/> Roumanie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Roumanie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const RE : Country = new Country ( "RE", "Roumanie" 									);
		/**
		 * <strong><img src="../../../countries/GB.png"/> Royaume-Uni</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Royaume-Uni</code>) de la norme ISO 3166-1.</p>
		 */
		static public const GB : Country = new Country ( "GB", "Royaume-Uni" 								);
		/**
		 * <strong><img src="../../../countries/RU.png"/> Russie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Russie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const RU : Country = new Country ( "RU", "Russie" 									);
		/**
		 * <strong><img src="../../../countries/RW.png"/> Rwanda</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Rwanda</code>) de la norme ISO 3166-1.</p>
		 */
		static public const RW : Country = new Country ( "RW", "Rwanda" 									);
		/**
		 * <strong><img src="../../../countries/EH.png"/> Saint-Barthelemy</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Saint-Barthelemy</code>) de la norme ISO 3166-1.</p>
		 */
		static public const EH : Country = new Country ( "EH", "Saint-Barthelemy" 							);
		/**
		 * <strong><img src="../../../countries/KN.png"/> Saint-Christophe-et-Niévès</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Saint-Christophe-et-Niévès</code>) de la norme ISO 3166-1.</p>
		 */
		static public const KN : Country = new Country ( "KN", "Saint-Christophe-et-Niévès" 				);
		/**
		 * <strong><img src="../../../countries/SM.png"/> Saint-Martin</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Saint-Martin</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SM : Country = new Country ( "SM", "Saint-Martin" 								);
		/**
		 * <strong><img src="../../../countries/PM.png"/> Vatican</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Vatican</code>) de la norme ISO 3166-1.</p>
		 */
		static public const PM : Country = new Country ( "PM", "Vatican" 									);
		/**
		 * <strong><img src="../../../countries/VC.png"/> Saint-Vincent-et-les Grenadines</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Saint-Vincent-et-les Grenadines</code>) de la norme ISO 3166-1.</p>
		 */
		static public const VC : Country = new Country ( "VC", "Saint-Vincent-et-les Grenadines" 			);
		/**
		 * <strong><img src="../../../countries/SH.png"/> Sainte-Hélène</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Sainte-Hélène</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SH : Country = new Country ( "SH", "Sainte-Hélène" 								);
		/**
		 * <strong><img src="../../../countries/LC.png"/> Samoa américaines</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Samoa américaines</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LC : Country = new Country ( "LC", "Samoa américaines" 							);
		/**
		 * <strong><img src="../../../countries/ST.png"/> São Tomé-et-Principe</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>São Tomé-et-Principe</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ST : Country = new Country ( "ST", "São Tomé-et-Principe" 						);
		/**
		 * <strong><img src="../../../countries/SN.png"/> Sénégal</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Sénégal</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SN : Country = new Country ( "SN", "Sénégal" 									);
		/**
		 * <strong><img src="../../../countries/RS.png"/> Serbie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Serbie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const RS : Country = new Country ( "RS", "Serbie" 									);
		/**
		 * <strong><img src="../../../countries/SC.png"/> Seychelles</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Seychelles</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SC : Country = new Country ( "SC", "Seychelles" 								);
		/**
		 * <strong><img src="../../../countries/SL.png"/> Sierra Leone</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Sierra Leone</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SL : Country = new Country ( "SL", "Sierra Leone" 								);
		/**
		 * <strong><img src="../../../countries/SG.png"/> Singapour</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Singapour</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SG : Country = new Country ( "SG", "Singapour" 									);
		/**
		 * <strong><img src="../../../countries/SK.png"/> Slovénie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Slovénie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SK : Country = new Country ( "SK", "Slovénie" 									);
		/**
		 * <strong><img src="../../../countries/SO.png"/> Somalie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Somalie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SO : Country = new Country ( "SO", "Somalie" 									);
		/**
		 * <strong><img src="../../../countries/SD.png"/> Soudan</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Soudan</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SD : Country = new Country ( "SD", "Soudan" 									);
		/**
		 * <strong><img src="../../../countries/LK.png"/> Sri Lanka</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Sri Lanka</code>) de la norme ISO 3166-1.</p>
		 */
		static public const LK : Country = new Country ( "LK", "Sri Lanka" 									);
		/**
		 * <strong><img src="../../../countries/SE.png"/> Suède</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Suède</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SE : Country = new Country ( "SE", "Suède" 										);
		/**
		 * <strong><img src="../../../countries/CH.png"/> Suisse</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Suisse</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CH : Country = new Country ( "CH", "Suisse" 									);
		/**
		 * <strong><img src="../../../countries/SR.png"/> Suriname</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Suriname</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SR : Country = new Country ( "SR", "Suriname" 									);
		/**
		 * <strong><img src="../../../countries/SJ.png"/> Swaziland</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Swaziland</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SJ : Country = new Country ( "SJ", "Swaziland" 									);
		/**
		 * <strong><img src="../../../countries/SY.png"/> Syrie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Syrie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const SY : Country = new Country ( "SY", "Syrie" 										);
		/**
		 * <strong><img src="../../../countries/TJ.png"/> Tchad</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Tchad</code>) de la norme ISO 3166-1.</p>
		 */
		static public const TJ : Country = new Country ( "TJ", "Tchad" 										);
		/**
		 * <strong><img src="../../../countries/CZ.png"/> République tchèque</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>République tchèque</code>) de la norme ISO 3166-1.</p>
		 */
		static public const CZ : Country = new Country ( "CZ", "République tchèque" 						);
		/**
		 * <strong><img src="../../../countries/TF.png"/> Trinité-et-Tobago</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Trinité-et-Tobago</code>) de la norme ISO 3166-1.</p>
		 */
		static public const TF : Country = new Country ( "TF", "Trinité-et-Tobago" 							);
		/**
		 * <strong><img src="../../../countries/TN.png"/> Tunisie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Tunisie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const TN : Country = new Country ( "TN", "Tunisie" 									);
		/**
		 * <strong><img src="../../../countries/TM.png"/> Turquie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Turquie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const TM : Country = new Country ( "TM", "Turquie" 									);
		/**
		 * <strong><img src="../../../countries/TV.png"/> Ukraine</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Ukraine</code>) de la norme ISO 3166-1.</p>
		 */
		static public const TV : Country = new Country ( "TV", "Ukraine" 									);
		/**
		 * <strong><img src="../../../countries/UY.png"/> Venezuela</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Venezuela</code>) de la norme ISO 3166-1.</p>
		 */
		static public const UY : Country = new Country ( "UY", "Venezuela" 									);
		/**
		 * <strong><img src="../../../countries/VN.png"/> Viêt Nam</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Viêt Nam</code>) de la norme ISO 3166-1.</p>
		 */
		static public const VN : Country = new Country ( "VN", "Viêt Nam" 									);
		/**
		 * <strong><img src="../../../countries/WF.png"/> Yémen</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Yémen</code>) de la norme ISO 3166-1.</p>
		 */
		static public const WF : Country = new Country ( "WF", "Yémen" 										);
		/**
		 * <strong><img src="../../../countries/ZM.png"/> Zambie</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Zambie</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ZM : Country = new Country ( "ZM", "Zambie" 									);
		/**
		 * <strong><img src="../../../countries/ZW.png"/> Zimbabwe</strong>.
		 * <p>Instance de la classe <code>Country</code> représentant 
		 * le code du pays correspondant (<code>Zimbabwe</code>) de la norme ISO 3166-1.</p>
		 */
		static public const ZW : Country = new Country ( "ZW", "Zimbabwe" 									);		
		
		/*
		 * INSTANCE MEMBERS
		 */
		/**
		 * Le code du pays sous forme de chaîne
		 */
		private var code : String;
		/**
		 * Le nom du pays en Français
		 */
		private var name : String;
		
		/**
		 * Créer une nouvelle instance de la classe <code>Country</code>.
		 * La nouvelle instance s'enregistrera d'elle même dans la map
		 * statique de la classe.
		 * <p>
		 * Normalement vous n'avez pas à créer vous-même d'instance de 
		 * la classe <code>Country</code> étant donné que tout ls pays
		 * listés dans la norme ISO 3166-1 sont disponibles en constantes
		 * de la classe <code>Country</code>.
		 * </p>
		 * @param	code	le code du pays tel que définie par 
		 * 					la norme ISO 3166-1
		 * @param	name	le nom du pays en français tel que
		 * 					définie par la norme ISO 3166-1
		 */					
		public function Country ( code : String, name : String )
		{
			this.code = code;
			this.name = name;
			put( code, this );
		}
		/**
		 * Renvoie le code ISO du pays.
		 * 
		 * @return le code ISO du pays
		 */
		public function getCode () : String
		{
			return code;
		}
		/**
		 * Renvoie le nom du pays en français.
		 * 
		 * @return le nom du pays en français
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
		/**
		 * Renvoie la représentation du code source ayant permis
		 * de créer l'instance courante.
		 * 
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 */
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this)+ "('"+ code + "', '" + name + "')";
		}
	}
}
