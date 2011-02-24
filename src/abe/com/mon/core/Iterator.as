/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * An <code>Iterator</code> over a collection. Iterators can be used
	 * to loop safely over a collection.
	 * 
	 * <fr>
	 * Un objet <code>Iterator</code> permet de parcourir une collection 
	 * d'objets de façon sécurisée.
	 * </fr>
	 */
	public interface Iterator 
	{
		/**
		 * Returns <code>true</code> if there's at least one
		 * element onto which iterate after the current element.
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si il reste encore un élément
		 * à parcourir dans la collection d'objets après l'élément
		 * courant.
		 * </fr>
		 * @return	<code>true</code> if there's at least one
		 * 			element onto which iterate after the current element
		 * 			<fr><code>true</code> si il reste encore un élément
		 * 			à parcourir dans la collection d'objets</fr>
		 */
		function hasNext () : Boolean;
		/**
		 * Returns the next element in the collection, if there is
		 * at least one remaining, otherwise the function raise
		 * an exception.
		 * 
		 * <fr>
		 * Renvoie le prochain objet dans la collection, si il en
		 * reste un, sinon la fonction lève une exception.
		 * </fr>
		 * @return	the next object in the collection
		 * 			<fr>le prochain objets dans la collection</fr>
		 * @throws Error There's no more next elements in the collection
		 * 				 <fr>Il n'y a pas d'élément suivant 
		 * 		  		 dans la collection</fr>
		 */
		function next () : *;
		/**
		 * Remove the current element from the collection.
		 * If an implementation cannot guarantee that the
		 * object can be suppressed, it have to raise an
		 * exception if the <code>remove</code> method 
		 * is called. 
		 * <fr>
		 * Supprime l'élément courant. Si une implémentation
		 * ne peut garantir la suppression, celle-si doit alors
		 * levé une exception en cas d'appel de la méthode
		 * <code>remove</code>.
		 * </fr>
		 */
		function remove () : void;
		/**
		 * Reset the current iterator to its initial state. After a call
		 * to <code>reset</code> the value returned by the <code>next</code>
		 * method must be the first element in the collection.
		 * 
		 * <fr>
		 * Remet le curseur de cet objet <code>Iterator</code> au départ.
		 * </fr>
		 */
		function reset() : void;
	}
}
