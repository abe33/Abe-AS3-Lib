/**
 * @license
 */
package aesia.com.mon.core 
{

	/**
	 * Un objet <code>Clearable</code> fournie une méthode permettant de néttoyer l'instance
	 * de données résultant de calculs intensifs tel un cache, une map de calcul, etc...
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Clearable 
	{
		/**
		 * Nettoye l'instance des données calculées et sauvegardées dans l'instance.
		 */
		function clear() : void;
	}
}
