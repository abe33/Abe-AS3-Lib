/**
 * @license
 */
package aesia.com.mon.core 
{

	/**
	 * Interface permettant à des objets de se comparer mutuellement, même si il ne s'agit pas
	 * de la même instance.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Equatable 
	{
		/**
		 * Renvoie <code>true</code> si <code>o</code> est égal à l'instance courante 
		 * en l'état de l'algorythme de comparaison.
		 * 
		 * @param	o	instance à comparer avec l'instance courante
		 * @return	<code>true</code> si <code>o</code> est égal à l'instance courante
		 */
		function equals( o : * ) : Boolean;
	}
}
