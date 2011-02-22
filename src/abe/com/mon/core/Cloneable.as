/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * Les objets implémentant l'interface <code>Cloneable</code> garantissent 
	 * de pouvoir renvoyer une nouvelle instance qui est une copie de l'instance
	 * courante.
	 */
	public interface Cloneable 
	{
		/**
		 * Renvoie une copie de l'instance courante.
		 * 
		 * @return	une copie de l'instance courante
		 */
		function clone () : *;
	}
}
