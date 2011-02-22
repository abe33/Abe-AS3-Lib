/**
 * @license
 */
package  abe.com.mon.core.impl 
{
	import abe.com.mon.core.Sealable;

	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * Implémentation standard d'un objet <code>Sealable</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	final public dynamic class SealableImpl extends Proxy implements Sealable
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
		 * Créer une nouvelle instance de la classe <code>SealableObject</code>.
		 * 
		 * @param	initialContent	un objet représentant les données initialements
		 * 							présente dans l'objet
		 */
		public function SealableImpl ( initialContent : Object = null )
		{
			content = initialContent ? initialContent : {};
			sealed = false;
		}		
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
		 * Intercepte les appels à une fonction de l'objet.
		 * 
		 * @param	name	nom de la fonction
		 * @param	args	arguments passé à la fonction
		 * @return	le renvoie de la fonction si elle existe, 
		 * 			ou <code>null</code> si elle n'existe pas
		 */
		final override flash_proxy function callProperty ( name : *, ... args ) : *
		{
			return ( content[ name ] as Function ).apply( this, args );
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
