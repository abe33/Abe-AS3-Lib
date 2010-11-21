/**
 * @license
 */
package  aesia.com.mon.core 
{
	/**
	 * Un objet <code>Lockable</code> offre la possibilité de vérrouiller
	 * ou de dévérouiller une partie de ses fonctionnalités à l'aide 
	 * des méthodes <code>lock</code> et <code>unlock</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Lockable 
	{
		/**
		 * Vérrouille toute ou partie des fontionnalités de l'objet.
		 */
		function lock() : void;
		/**
		 * Dévérrouille les fonctionnalités précédemment vérrouillées.
		 */
		function unlock() : void;
		/**
		 * Renvoie <code>true</code> si l'objet courant a été vérrouillé
		 * suite à un appel à la fonction <code>lock</code>.
		 * 
		 * @return	<code>true</code> si l'objet courant a été vérrouillé
		 * 			suite à un appel à la fonction <code>lock</code>
		 */
		function get isLocked () : Boolean;
	}
}
