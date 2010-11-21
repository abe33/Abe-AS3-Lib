/**
 * @license
 */
package  aesia.com.mon.core 
{
	/**
	 * Un objet <code>Iterator</code> permet de parcourir une collection 
	 * d'objets de façon sécurisée.
	 */
	public interface Iterator 
	{
		/**
		 * Renvoie <code>true</code> si il reste encore un élément
		 * à parcourir dans la collection d'objets après l'élément
		 * courant.
		 * 
		 * @return	<code>true</code> si il reste encore un élément
		 * 			à parcourir dans la collection d'objets
		 */
		function hasNext () : Boolean;
		/**
		 * Renvoie le prochain objets dans la collection, si il en
		 * reste un, sinon la fonction lève une exception.
		 * 
		 * @return le prochain objets dans la collection
		 * @throws Error Error - Il n'y a pas d'élément suivant 
		 * 		  dans la collection
		 */
		function next () : *;
		/**
		 * Supprime l'élément courant. Si une implémentation
		 * ne peut garantir la suppression, celle-si doit alors
		 * levé une exception en cas d'appel de la méthode
		 * <code>remove</code>.
		 */
		function remove () : void;
		/**
		 * Remet l'objet <code>Iterator</code>.
		 */
		function reset() : void;
	}
}
