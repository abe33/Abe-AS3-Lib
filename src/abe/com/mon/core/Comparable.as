/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * <code>Comparable</code> objects provide a method that allow
	 * these objects to compare themselves in a sorting operation.
	 * 
	 * <fr>
	 * Les objets <code>Comparable</code> fournissent une méthode permettant
	 * de se comparer entre-eux lors d'opérations de tri.
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Comparable 
	{
		/**
		 * Returns an integer corresponding to the comparison between the 
		 * current instance and the passed-in value <code>o</code>.
		 * 
		 * <fr>
		 * Compare l'objet passé en paramète à l'instance courante et renvoie
		 * un entier.
		 * </fr>
		 * @param	o	an object to compare to the current instance
		 * 				<fr>objet à comparér à l'instance courante</fr>
		 * @return	an integer such as :
		 * 			<ul>
		 * 			<li>-1 : the current instance will be placed after <code>o</code></li>
		 * 			<li>&#xA0;0 : the two objects position will remain the same</li>
		 * 			<li>&#xA0;1 : the current instance will be placed before <code>o</code></li>
		 * 			</ul>
		 * 			
		 * 			<fr>un entier tel que : 
		 * 			<ul>
		 * 			<li>-1 : l'instance courante sera placée après <code>o</code></li>
		 * 			<li>&#xA0;0 : les positions des deux objets restent inchangés</li>
		 * 			<li>&#xA0;1 : l'instance courante sera placé avant <code>o</code></li>
		 * 			</ul></fr>
		 */
		function compare( o : * ) : Number;
	}
}
