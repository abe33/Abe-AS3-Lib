/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * Les objets <code>Iterable</code> fournissent à tout moment
	 * un objet <code>Iterator</code> prêt à l'emploi.
	 */
	public interface Iterable 
	{
		/**
		 * Renvoie un objet <code>Iterator</code> prêt à l'emploi.
		 * 
		 * @return	un objet <code>Iterator</code> prêt à l'emploi
		 */
		function iterator() : Iterator;
	}
}
