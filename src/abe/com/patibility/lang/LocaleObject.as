/**
 * @license
 */
package  abe.com.patibility.lang 
{
	import abe.com.mon.core.Sealable;

	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;

	/**
	 * La classe <code>LocaleObject</code> est utilisé pour représenter les sous-objets
	 * d'un objet <code>Locale</code>. D'ailleurs la classe <code>Locale</code> hérite
	 * de <code>LocaleObject</code>, elle fournie donc les memes fonctionnalités.
	 * <p>
	 * La classe <code>LocaleObject</code> implémente <code>Sealable</code>, c'est-à-dire
	 * qu'après un appel de sa méthode <code>seal</code> il n'est plus possible de modifier
	 * les valeurs des propriétés de l'objet.
	 * </p><p>
	 * La classe <code>LocaleObject</code> fournit un moyen très pratique pour accéder aux
	 * chaînes de caractère et réaliser des remplacements de jetons au sein de celle-ci.
	 * Ainsi pour un objet <code>LocaleObject</code> contenant une propriété <code>foo</code>
	 * contenant la valeur <code>"$0 world"</code> un appel sous cette forme 
	 * <listing>trace ( localeObjet.foo );</listing>
	 * donnera : 
	 * <listing>"$0 world"</listing>
	 * et un appel sous cette forme 
	 * <listing>trace ( localObject.foo( "hello" ) );</listing>
	 * donnera : 
	 * <listing>"hello world"</listing>
	 * </p>
	 * @author Cédric Néhémie
	 */
	public class LocaleObject extends Proxy implements Sealable
	{
		/*
		 * L'objet privé contenant les données de l'objet.
		 */
		private var content : Object;
		/*
		 * Une valeur booléenne indiquant si l'objet a été scellé.
		 */
		private var sealed : Boolean;
		
		/**
		 * Crée une nouvelle instance de la classe <code>LocaleObject</code>
		 */
		public function LocaleObject ()
		{			
			content = {};
			sealed = false;
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString () : String
		{
			return getQualifiedClassName( this );
		}

		/*
		 * SEAL METHODS
		 * 
		 * Toutes ces méthodes sont finales, 
		 * car le comportement du sceau ne doit
		 * pas être altéré.
		 */
		/**
		 * @inheritDoc
		 */
		final public function seal () : void
		{
			sealed = true;
		}
		/**
		 * @inheritDoc
		 */
		final public function isSealed () : Boolean
		{
			return sealed;
		}
		
		public function get( name : String, args : Array ):*
		{
			return flash_proxy::callProperty.apply( this, [ name ].concat( args ) );
		}
		
		/**
		 * Intercepte les appels en lecture à une propriété de l'objet.
		 * 
		 * @param	name	nom de la propriété
		 * @return	valeur de la propriété ou <code>undefined</code> si
		 * 			la propriété n'existe pas
		 */
		final override flash_proxy function getProperty ( name : * ) : *
		{
			return content[ name ];
		}
		/**
		 * Intercepte les appels en écriture à une propriété de l'objet.
		 * L'écriture n'est possible que si l'objet n'a pas été encore
		 * scellé.
		 * 
		 * @param	name	nom de la propriété
		 * @param	value	valeur à affecter
		 */
		final override flash_proxy function setProperty ( name : *, value : * ) : void
		{
			if( sealed ) return;
			
			content[ name ] = value;
		}
		/**
		 * Intercepte les appels à une fonction de l'objet et renvoi la
		 * chaîne associé à la propriété du nom de la fonction mais après
		 * avoir effectué un remplacement de jetons au sein de la chaîne.
		 * 
		 * @param	name	nom de la propriété à accéder
		 * @param	args	valeurs de remplacement pour les jetons
		 * 					de la chaîne
		 * @return	la valeur de la propriété dont les jetons
		 * 			ont été remplacé par les arguments de la fonction
		 */
		final override flash_proxy function callProperty ( name : *, ... args ) : *
		{
			var a : Array = args;
			var c : * = content[ name ];
			
			if( c is LocaleObject )
				return c;
			else
			{
				if( a[0] is Array && a.length == 1 )
					a = a[0];
					
				return (c as String).replace(/\$([0-9]+)/g, function( ... rest ) : String
					{
						return a[ parseInt( rest[ 1 ] ) ];
					}
				);
			}
		}
		/**
		 * Intercepte les appels à la suppression de propriétés
		 * dynamique. Les propriétés ne peuvent être supprimée 
		 * que si l'objet n'a pas été scellé.
		 * 
		 * @param	name	nom de la propriété à supprimer
		 * @return	<code>true</code> si la propriété a pu être
		 * 			supprimé, <code>false</code> autrement
		 */
		final override flash_proxy function deleteProperty ( name : * ) : Boolean
		{
			if( sealed )
				return false;
			
			return delete content[ name ];
		}
	}
}
