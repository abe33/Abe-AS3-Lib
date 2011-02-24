/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * <code>Cloneable</code> objects guarantee that they can return a perfect
	 * clone of itself when the <code>clone</code> method is called.
	 * 
	 * <fr>
	 * Les objets implémentant l'interface <code>Cloneable</code> garantissent 
	 * de pouvoir renvoyer une nouvelle instance qui est une copie de l'instance
	 * courante.
	 * </fr>
	 */
	public interface Cloneable 
	{
		/**
		 * Returns a clone of the current instance.
		 * <fr>
		 * Renvoie une copie de l'instance courante.
		 * </fr>
		 * @return	a clone of the current instance
		 * 			<fr>une copie de l'instance courante</fr>
		 */
		function clone () : *;
	}
}
