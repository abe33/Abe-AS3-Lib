/**
 * @license
 */
package  aesia.com.mon.core 
{
	/**
	 * Un objet <code>Serializable</code> garantir de pouvoir renvoyer
	 * le code source permettant de la recréer.
	 */
	public interface Serializable 
	{
		/**
		 * Renvoie la représentation du code source permettant 
		 * de recréer l'instance courante.
		 * 
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 */
		function toSource () : String;
		/**
		 * Renvoie la représentation du code source permettant de
		 * recréer l'instance courante via la méthode <code>Reflection.get()</code>.
		 * 
		 * @return la représentation du code source permettant de
		 * 			recréer l'instance courante via la méthode <code>Reflection.get()</code>
		 * 			
		 * @see aesia.com.mmon.utils.Reflection#get()
		 */
		function toReflectionSource() : String
	}
}
