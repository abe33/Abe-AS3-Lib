/**
 * @license
 */
package abe.com.mon.core 
{

	/**
	 * An <code>Equatable</code> object is an object that can compare itself
	 * with another instance to define if the two instances are equals.
	 * <p>
	 * The two objects don't necessary have to be of the same type, it's possible
	 * to compare two objects from different types in an implementation.
	 * </p>
	 * 
	 * <fr>
	 * Interface permettant à des objets de se comparer mutuellement, même si il ne s'agit pas
	 * de la même instance.
	 * <p>
	 * Le deux objets n'ont pas nécessairement besoin d'être du même type, il est tout
	 * à fait possible de comparer des objets de types différents.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface Equatable 
	{
		/**
		 * Returns <code>true</code> if <code>o</code> is equal to the current instance.
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si <code>o</code> est égal à l'instance courante 
		 * en l'état de l'algorythme de comparaison.
		 * </fr>
		 * 
		 * @param	o	an object to compare to the current instance
		 * 				<fr>instance à comparer avec l'instance courante</fr>
		 * @return	<code>true</code> if <code>o</code> is equal to the current instance
		 * 			<fr><code>true</code> si <code>o</code> est égal à l'instance courante</fr>
		 */
		function equals( o : * ) : Boolean;
	}
}
