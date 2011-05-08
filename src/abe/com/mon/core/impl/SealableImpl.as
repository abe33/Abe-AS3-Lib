/**
 * @license
 */
package  abe.com.mon.core.impl 
{
	import abe.com.mon.core.Sealable;

	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/**
	 * A standard implementation of the <code>Sealable</code> interface.
	 * <fr>
	 * Implémentation standard d'un objet <code>Sealable</code>.
	 * </fr>
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
		 * <code>SealableObject</code> constructor.
		 * <fr>
		 * Créer une nouvelle instance de la classe <code>SealableObject</code>.
		 * </fr>
		 * @param	initialContent	an object which contains the initial content for this instance
		 * 							<fr>un objet représentant les données initialements
		 * 							présente dans l'objet</fr>
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
		 * Catch the access to propery.
		 * <fr>
		 * Intercepte les appels en lecture à une propriété de l'objet.
		 * </fr>
		 * @param	name	name of the property
		 * 					<fr>nom de la propriété</fr>
		 * @return	value of the property, if there's any, otherwise return
		 * 			<code>undefined</code>
		 * 			<fr>valeur de la propriété ou <code>undefined</code> si
		 * 			la propriété n'existe pas</fr>
		 */
		final override flash_proxy function getProperty ( name : * ) : *
		{
			return content[ name ];
		}
		/**
		 * Catch the call to a property setup.
		 * <p>
		 * Writing in a property is possible only if the object
		 * hasn't been sealed yet. 
		 * </p>
		 * 
		 * <fr>
		 * Intercepte les appels en écriture à une propriété de l'objet.
		 * L'écriture n'est possible que si l'objet n'a pas été encore
		 * scellé.
		 * </fr>
		 * @param	name	name of the property
		 * 					<fr>nom de la propriété</fr>
		 * @param	value	value of the property
		 * 					<fr>valeur à affecter</fr>
		 */
		final override flash_proxy function setProperty ( name : *, value : * ) : void
		{
			if( sealed ) return;
			
			content[ name ] = value;
		}
		/**
		 * Catch the call to a function.
		 * <fr>
		 * Intercepte les appels à une fonction de l'objet.
		 * </fr>
		 * @param	name	name of the function
		 * 					<fr>nom de la fonction</fr>
		 * @param	args	function's arguments
		 * 					<fr>arguments passé à la fonction</fr>
		 * @return	the return of the called function od <code>null</code>
		 * 			if there's no function with that name
		 * 			<fr>le renvoie de la fonction si elle existe, 
		 * 			ou <code>null</code> si elle n'existe pas</fr>
		 */
		final override flash_proxy function callProperty ( name : *, ... args ) : *
		{
			return ( content[ name ] as Function ).apply( this, args );
		}
		/**
		 * Catch the call to a property deletion.
		 * <p>
		 * Object properties can be deleted only if the object hasn't
		 * be sealed yet.
		 * </p>
		 * <fr>
		 * Intercepte les appels à la suppression de propriétés
		 * dynamique. Les propriétés ne peuvent être supprimée 
		 * que si l'objet n'a pas été scellé.
		 * </fr>
		 * @param	name	name of the property 
		 * 					<fr>nom de la propriété à supprimer</fr>
		 * @return	<code>true</code> if the property have been successfully
		 * 			removed, <code>false</code> otherwise
		 * 			<fr><code>true</code> si la propriété a pu être
		 * 			supprimé, <code>false</code> autrement</fr>
		 */
		final override flash_proxy function deleteProperty ( name : * ) : Boolean
		{
			if( sealed )
				return false;
			
			return delete content[ name ];
		}
	}
}
