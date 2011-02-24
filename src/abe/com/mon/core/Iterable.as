/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * <code>Iterable</code> objects provides any time an 
	 * <code>Iterator</code> object.
	 * 
	 * <fr>
	 * Les objets <code>Iterable</code> fournissent à tout moment
	 * un objet <code>Iterator</code> prêt à l'emploi.
	 * </fr>
	 */
	public interface Iterable 
	{
		/**
		 * Returns an <code>Iterator</code> object.
		 * 
		 * <fr>
		 * Renvoie un objet <code>Iterator</code> prêt à l'emploi.
		 * </fr>
		 * @return	an <code>Iterator</code> object
		 * 			<fr>un objet <code>Iterator</code> prêt à l'emploi</fr>
		 */
		function iterator() : Iterator;
	}
}
