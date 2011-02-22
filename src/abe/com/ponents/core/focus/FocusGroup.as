/**
 * @license
 */
package abe.com.ponents.core.focus 
{

	/**
	 * Un objet <code>FocusGroup</code> est un objet <code>Focusable</code>
	 * ayant la charge de la gestion du focus sur un ensemble de sous-objets
	 * <code>Focusable</code>.
	 * <p>
	 * L'interface définit pour ce faire un certains nombre de méthodes sur 
	 * lesquels les objets <code>Focusable</code> peuvent s'appuyer afin de
	 * gérer la transmission du focus à travers une hierarchie d'objets imbriqués.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public interface FocusGroup extends Focusable
	{
		/**
		 * Place le focus sur le premier enfant de cet objet <code>FocusGroup</code>.
		 */
		function focusFirstChild() : void;
		/**
		 * Place le focus sur le dernier enfant de cet objet <code>FocusGroup</code>.
		 */		function focusLastChild() : void;
		/**
		 * Place le focus sur l'objet <code>Focusable</code> actif le plus proche
		 * après <code>child</code> dans les enfants de cet objet <code>FocusGroup</code>.
		 * <p>
		 * Une implémentation devrait toujours permettre que le focus remonte d'un niveau
		 * lorsqu'il n'existe plus d'objet <code>Focusable</code> après <code>child</code>
		 * dans les enfants de cet objet <code>FocusGroup</code>.
		 * </p>
		 * 
		 * @param	child	objet ayant actuellement le focus et servant de point de départ
		 * 					pour la recherche d'un nouvel objet <code>Focusable</code>
		 */		function focusNextChild( child : Focusable ) : void;
		/**
		 * Place le focus sur l'objet <code>Focusable</code> actif le plus proche
		 * avant <code>child</code> dans les enfants de cet objet <code>FocusGroup</code>.
		 *  <p>
		 * Une implémentation devrait toujours permettre que le focus remonte d'un niveau
		 * lorsqu'il n'existe plus d'objet <code>Focusable</code> avant <code>child</code>
		 * dans les enfants de cet objet <code>FocusGroup</code>.
		 * </p>
		 * 
		 * @param	child	objet ayant actuellement le focus et servant de point de départ
		 * 					pour la recherche d'un nouvel objet <code>Focusable</code>
		 */		function focusPreviousChild( child : Focusable ) : void;
	}
}
