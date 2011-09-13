/**
 * @license
 */
package  abe.com.patibility.lang 
{
    import abe.com.mon.core.Sealable;

    import flash.utils.getQualifiedClassName;
	/**
	 * Un objet <code>Locale</code> contient tout les éléments constitutifs d'une localisation.
	 * Un objet <code>Locale</code> est identifié à l'aide de la combinaison des codes de langues
	 * et de pays.
	 * <p>
	 * Les objets <code>Locale</code> créer par une instance de la classe <code>LocalDeserializer</code>
	 * sont scellés par cette dernière à la fin du processus de déserialisation. Il est donc
	 * impossible de modifier une propriété de ces objets. 
	 * </p><p>
	 * Les objets <code>Locale</code> peuvent contenir des sous-objets, ces sous-objets sont
	 * du type <code>LocaleObject</code>. 
	 * </p>
	 * @author Cédric Néhémie
	 */
	public dynamic class Locale extends LocaleObject implements Sealable
	{
		static protected var instances : Object = {};
		
		static public function get ( key : String ) : Locale
		{
			if( instances.hasOwnProperty( key ) )
				return instances[ key ] as Locale;
			else
				return null;
		}

		/**
		 * La langue correspondant au contenu de cet objet <code>Locale</code>.
		 */
		protected var language : Lang;
		/**
		 * Le pays correspondant au contenu de cet objet <code>Locale</code>.
		 */
		protected var country : Country;
		
		/**
		 * Créer un nouvel objet <code>Locale</code> pour la langue et le pays
		 * précisé en paramètre. Lors de sa création un objet <code>Locale</code>
		 * n'est pas encore scellé.
		 * 
		 * @param	language	la langue correspondant au contenu de cet objet
		 * @param	country		le pays correspondant au contenu de cet objet
		 */
		public function Locale ( language : Lang, country : Country = null, id : String = "" )
		{
			this.language = language;
			this.country = country;
			
			if( id != "" )
				instances[ id ] = this;
		} 	
		/**
		 * Renvoie l'objet <code>Lang</code> correspondant au contenu de cet objet.
		 * 
		 * @return l'objet <code>Lang</code> correspondant au contenu de cet objet
		 */	
		public function getLang () : Lang
		{
			return language;
		}
		/**
		 * Renvoie l'objet <code>Country</code> correspondant au contenu de cet objet.
		 * 
		 * @return l'objet <code>Country</code> correspondant au contenu de cet objet
		 */	
		public function getCountry () : Country
		{
			return country;
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		override public function toString () : String
		{
			return getQualifiedClassName( this ) + "(" + language.getCode() + "-" + country.getCode() + ")";
		}
	}
	
}
