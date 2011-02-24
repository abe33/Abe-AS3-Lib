/**
 * @license
 */
package  abe.com.mon.core
{
	import abe.com.mon.core.Iterator;

	/**
	 * A <code>ListIterator</code> is an <code>Iterator</code> that can
	 * iterate over a collection in both ways.
	 * 
	 * <fr>
	 * Un <code>ListIterator</code> est un <code>Iterator</code> parcourant
	 * une collection dans les deux sens.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface ListIterator extends Iterator
	{
		/**
		 * Add an element after the current element and place
		 * the cursor on the newly added element. If an implementation
		 * can't guarantee the addition of an element it must raise
		 * an exception when the <code>add</code> method is called.
		 * 
		 * <fr>
		 * Ajoute un élément après l'élément courant et avance
		 * son pointeur à l'élément nouvellement ajouté.
		 * Si une implémentation ne peut garantir l'ajout d'un
		 * élément, celle-si doit alors levé une exception 
		 * en cas d'appel de la méthode <code>add</code>.
		 * </fr>
		 * @param	o	an element to add in the collection
		 * 				<fr>objet à ajouter dans la collection</fr>
		 */
		function add ( o : Object ) : void;
		/**
		 * Returns <code>true</code> if there's at least one element
		 * onto which iterate in the collection before the current
		 * element.
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si il reste encore un élément
		 * à parcourir dans la collection d'objets avant l'élément
		 * courant.
		 * </fr>
		 * @return	<code>true</code> if there's at least one element
		 * 			onto which iterate in the collection
		 * 			<fr><code>true</code> si il reste encore un élément
		 * 			à parcourir dans la collection d'objets</fr>
		 */
		function hasPrevious () : Boolean;
		/**
		 * Returns the index of the next element. The method returns
		 * always the index of the element returned by the next call
		 * to the <code>next</code> method.
		 *  
		 * <fr>
		 * Renvoie l'index du prochain élément. La fonction renvoie
		 * toujours l'index de l'élément retourné par le prochain
		 * appel de la méthode <code>next</code>.
		 * </fr>
		 * @return	l'index du prochain élément
		 */
		function nextIndex () : uint;
		/**
		 * Returns the previous element in the collection, if there is
		 * at least one remaining, otherwise the function raise
		 * an exception.
		 * 
		 * <fr>
		 * Renvoie l'objet précédent dans la collection, si il en
		 * reste un, sinon la fonction lève une exception.
		 * </fr>
		 * 
		 * @return the previous element in the collection
		 * 			<fr>l'objet précédent dans la collection</fr>
		 * @throws Error There's no more previous elements in the collection
		 * 				 <fr>Il n'y a pas d'élément précédent 
		 * 		   		 dans la collection</fr>
		 */
		function previous () : *;
		/**
		 * Returns the index of the previous element. The method returns
		 * always the index of the element returned by the next call
		 * to the <code>previous</code> method.
		 * 
		 * <fr>
		 * Renvoie l'index de l'élément précédent. la fonction renvoie
		 * toujours l'index de l'élément retourné par le prochain
		 * appel de la méthode <code>previous</code>.
		 * </fr>
		 * @return	the index of the previous element
		 * 			<fr>l'index du prochain élément</fr>
		 */
		function previousIndex () : uint;
		/**
		 * Set the element at the current index in the collection
		 * with the passed-in value. If an implementation can't guarantee
		 * an element change, it must raise an exception when the <code>set</code>
		 * method is called.
		 * 
		 * <fr>
		 * Change la valeur situé à l'index courant dans la collection
		 * d'objets. Si une implémentation ne peut garantir l'ajout d'un
		 * élément, celle-si doit alors levé une exception en cas d'appel
		 * de la méthode <code>set</code>
		 * </fr>
		 * @param	o	the new value for the current index element
		 * 				<fr>nouvelle valeur pour l'index courant</fr>
		 */
		function set ( o : * ) : void;
	}
}