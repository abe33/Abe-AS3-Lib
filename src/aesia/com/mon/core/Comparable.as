/**
 * @license
 */
package  aesia.com.mon.core 
{
	/**
	 * Les objets <code>Comparable</code> fournissent une méthode permettant
	 * de se comparer entre-eux lors d'opérations de tri.
	 */
	public interface Comparable 
	{
		/**
		 * Compare l'objet passé en paramète à l'instance courante et renvoie
		 * un entier.
		 * 
		 * @param	o	objet à comparér à l'instance courante 
		 * @return	un entier tel que : 
		 * 			<ul>
		 * 			<li>-1 : l'instance courante sera placée après <code>o</code></li>
		 * 			<li>&#xA0;0 : les positions des deux objets restent inchangés</li>
		 * 			<li>&#xA0;1 : l'instance courante sera placé avant <code>o</code></li>
		 * 			</ul>
		 */
		function compare( o : * ) : Number;
	}
}
