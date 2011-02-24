/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * A <code>Serialiable</code> guarantee that it can provide the
	 * source code that can recreate it.
	 * <fr>
	 * Un objet <code>Serializable</code> garantir de pouvoir renvoyer
	 * le code source permettant de la recréer.
	 * </fr>
	 */
	public interface Serializable 
	{
		/**
		 * Returns the source code of this instance.
		 * <fr>
		 * Renvoie la représentation du code source permettant 
		 * de recréer l'instance courante.
		 * </fr>
		 * @return 	the source code of this instance
		 * 			<fr>la représentation du code source ayant permis
		 * 			de créer l'instance courante</fr>
		 */
		function toSource () : String;
		/**
		 * Returns the source code of this instance such as evaluated by the
		 * <code>Reflection.get</code> method.
		 * 
		 * <fr>
		 * Renvoie la représentation du code source permettant de
		 * recréer l'instance courante via la méthode <code>Reflection.get()</code>.
		 * </fr>
		 * @return	the source code of this instance such as evaluated by the
		 * 			<code>Reflection.get</code> method
		 * 			<fr>la représentation du code source permettant de
		 * 			recréer l'instance courante via la méthode <code>Reflection.get()</code></fr>
		 * 			
		 * @see abe.com.mmon.utils.Reflection#get()
		 */
		function toReflectionSource() : String
	}
}
