/**
 * @license
 */
package  aesia.com.mon.core
{
	import aesia.com.mon.core.Iterator;

	/**
	 * Un <code>ListIterator</code> est un <code>Iterator</code> parcourant
	 * une collection dans les deux sens.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface ListIterator extends Iterator
	{
		/**
		 * Ajoute un élément après l'élément courant et avance
		 * son pointeur à l'élément nouvellement ajouté.
		 * Si une implémentation ne peut garantir l'ajout d'un
		 * élément, celle-si doit alors levé une exception 
		 * en cas d'appel de la méthode <code>add</code>.
		 * 
		 * @param	o	objet à ajouter dans la collection
		 */
		function add ( o : Object ) : void;
		/**
		 * Renvoie <code>true</code> si il reste encore un élément
		 * à parcourir dans la collection d'objets avant l'élément
		 * courant.
		 * 
		 * @return	<code>true</code> si il reste encore un élément
		 * 			à parcourir dans la collection d'objets
		 */
		function hasPrevious () : Boolean;
		/**
		 * Renvoie l'index du prochain élément. la fonction renvoie
		 * toujours l'index de l'élément retourné par le prochain
		 * appel de la méthode <code>next</code>.
		 * 
		 * @return	l'index du prochain élément
		 */
		function nextIndex () : uint;
		/**
		 * Renvoie l'objet précédent dans la collection, si il en
		 * reste un, sinon la fonction lève une exception.
		 * 
		 * @return l'objet précédent dans la collection
		 * @throws Error Error - Il n'y a pas d'élément précédent 
		 * 		   dans la collection
		 */
		function previous () : *;
		/**
		 * Renvoie l'index de l'élément précédent. la fonction renvoie
		 * toujours l'index de l'élément retourné par le prochain
		 * appel de la méthode <code>previous</code>.
		 * 
		 * @return	l'index du prochain élément
		 */
		function previousIndex () : uint;
		/**
		 * Change la valeur situé à l'index courant dans la collection
		 * d'objets. Si une implémentation ne peut garantir l'ajout d'un
		 * élément, celle-si doit alors levé une exception en cas d'appel
		 * de la méthode <code>set</code>
		 *
		 * @param	o	nouvelle valeur pour l'index courant
		 */
		function set ( o : Object ) : void;
	}
}