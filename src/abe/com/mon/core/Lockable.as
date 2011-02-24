/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * A <code>Lockable</code> object allow to lock or unlock a part
	 * or all the functionalities of this instance by calling the
	 * <code>lock</code> and <code>unlock</code> methods.
	 * 
	 * <fr>
	 * Un objet <code>Lockable</code> offre la possibilité de vérrouiller
	 * ou de dévérouiller une partie de ses fonctionnalités à l'aide 
	 * des méthodes <code>lock</code> et <code>unlock</code>.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface Lockable 
	{
		/**
		 * Lock a part of the whole instance.
		 * 
		 * <fr>
		 * Vérrouille toute ou partie des fontionnalités de l'objet.
		 * </fr>
		 */
		function lock() : void;
		/**
		 * Unlock the previously locked instance.
		 * 
		 * <fr>
		 * Dévérrouille les fonctionnalités précédemment vérrouillées.
		 * </fr>
		 */
		function unlock() : void;
		/**
		 * Returns <code>true</code> if the object is currently locked
		 * by a called to the <code>lock</code> method.
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si l'objet courant a été vérrouillé
		 * suite à un appel à la fonction <code>lock</code>.
		 * </fr>
		 * @return	<code>true</code> if the object is currently locked
		 * 			by a called to the <code>lock</code> method.
		 * 			<fr><code>true</code> si l'objet courant a été vérrouillé
		 * 			suite à un appel à la fonction <code>lock</code></fr>
		 */
		function get isLocked () : Boolean;
	}
}
