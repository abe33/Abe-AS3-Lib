/**
 * @license
 */
package abe.com.mon.core 
{

	/**
	 * A <code>Clearable</code> object provide a method to clean up its internal data
	 * and returning the instance to an empty state. This interface can be used for objects
	 * which use caching for instance.
	 * 
	 * <fr>
	 * Un objet <code>Clearable</code> fournie une méthode permettant de néttoyer l'instance
	 * de données résultant de calculs intensifs tel un cache, une map de calcul, etc...
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface Clearable 
	{
		/**
		 * Clean the current instance data and returns it to an empty state.
		 * 
		 * <fr>
		 * Nettoye l'instance des données calculées et sauvegardées dans l'instance.
		 * </fr>
		 */
		function clear() : void;
	}
}
