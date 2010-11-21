/**
 * @license
 */
package  aesia.com.ponents.history 
{

	/**
	 * Un objet <code>Undoable</code> garantit de pouvoir revenir
	 * à l'état précédent son éxécution.
	 * <p>
	 * Un objet <code>Undoable</code> est dit signifiant si il constitue
	 * à lui tout seul un état particulier. Marquant un point d'arrêt
	 * lors d'un retour en arrière dans l'historique.
	 * Ainsi un système d'historique parcourera toutes les actions enregistrées
	 * jusqu'à la première instance d'<code>Undoable</code> dans la direction
	 * du parcours. 
	 * </p>
	 */
	public interface Undoable
	{
		/**
		 * Annule l'opération précédemment réalisée par l'instance courante.
		 */
		function undo () : void;
		/**
		 * Refait l'opération précédemment annulée par l'instance courante.
		 */
		function redo () : void;
		/**
		 * Renvoie <code>true</code> si un appel de <code>undo</code> est 
		 * possible.
		 * 
		 * @return <code>true</code> si un appel de <code>undo</code> est 
		 * 			possible
		 */
		function get canUndo () : Boolean;
		/**
		 * Renvoie <code>true</code> si un appel de <code>redo</code> est 
		 * possible.
		 * 
		 * @return <code>true</code> si un appel de <code>redo</code> est 
		 * 			possible
		 */
		function get canRedo () : Boolean;
		/**
		 * Renvoie <code>true</code> si l'objet est considéré comme signifiant.
		 * 
		 * @return <code>true</code> si l'objet est considéré comme signifiant
		 */
		function get isSignificant () : Boolean;
		
		/**
		 * Renvoie une chaîne lisible pour un humain, et décrivant l'action à annuler/refaire.
		 * 
		 * @return une chaîne lisible pour un humain, et décrivant l'action à annuler/refaire
		 */
		function get label () : String;
	}
}