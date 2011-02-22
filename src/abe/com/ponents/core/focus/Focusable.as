/**
 * @license
 */
package abe.com.ponents.core.focus 
{
	import flash.events.FocusEvent;

	/**
	 * L'interface <code>Focusable</code> définie les méthodes qu'un composant
	 * doit implémenter s'il souhaite être pris en compte par la gestion du focus
	 * clavier proposé par ce kit de composants.
	 * <p>
	 * La gestion du focus reste essentiellement celle fournie par défaut par le
	 * flash player. Cependant, un objet <code>Focusable</code> possède des propriétés
	 * et des méthodes simplifiant la gestion de ce focus.
	 * </p>
	 * <p>
	 * Afin de résoudre les problématiques liées à l'imbrication d'objets <code>Focusable</code>
	 * entre eux, un objet <code>Focusable</code> sera amené à faire appel aux méthodes définies
	 * dans l'interface <code>FocusGroup</code>.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public interface Focusable 
	{
		/**
		 * Place le focus sur le prochain objet <code>Focusable</code>.
		 * <p>
		 * Une implémentation standard prendra en compte les deux cas suivants :
		 * </p>
		 * <ul>
		 * <li>Si un objet <code>FocusGroup</code> a été défini en tant que 
		 * <code>focusParent</code> de ce cet objet, la méthode donne suite
		 * à un appel de la méthode <code>focusNextChild</code> sur le 
		 * <code>focusParent</code>.</li>
		 * <li>Si au contraire, aucun <code>focusParent</code> n'est défini,
		 * l'objet doit rechercher dans la <code>Display List</code> un objet
		 * <code>InteractiveObject</code> susceptible de recevoir le focus.</li>
		 * </ul>
		 */
		function focusNext() : void;
		/**
		 * Place le focus sur le précédent objet <code>Focusable</code>.
		 * <p>
		 * Une implémentation standard prendra en compte les deux cas suivants :
		 * </p>
		 * <ul>
		 * <li>Si un objet <code>FocusGroup</code> a été défini en tant que 
		 * <code>focusParent</code> de ce cet objet, la méthode donne suite
		 * à un appel de la méthode <code>focusPreviousChild</code> sur le 
		 * <code>focusParent</code>.</li>
		 * <li>Si au contraire, aucun <code>focusParent</code> n'est défini,
		 * l'objet doit rechercher dans la <code>Display List</code> un objet
		 * <code>InteractiveObject</code> susceptible de recevoir le focus.</li>
		 * </ul>
		 */		function focusPrevious() : void;
		/**
		 * Renvoie <code>true</code> si l'objet <code>Focusable</code> courant
		 * possède actuellement le focus clavier.
		 * 
		 * @return	<code>true</code> si l'objet <code>Focusable</code> courant
		 * 			possède actuellement le focus clavier
		 */		function hasFocus () : Boolean;
		/**
		 * Force l'objet <code>Focusable</code> courant à prendre le focus clavier.
		 * <p>
		 * Une implémentation standard utilisera le code suivant pour réaliser cette
		 * opération : 
		 * </p>
		 * <listing>StageUtils.stage.focus = this;</listing>
		 */
		function grabFocus () : void;	
		
		/**
		 * Une référence vers un objet <code>FocusGroup</code>
		 * servant de parent dans les mécaniques de recherches
		 * des objets <code>Focusable</code> dans le cadre des
		 * déplacements de focus avec la touche tabulation. 
		 * <p>
		 * Afin de rendre la gestion de la transmission du focus
		 * dans certains composants plus naturel, le <code>focusParent</code>
		 * n'est pas nécessairement le parent direct de cet objet, mais
		 * un autre objet, ou un parent plus éloigné.
		 * </p>
		 * @default null
		 */
		function get focusParent () : FocusGroup;		function set focusParent ( parent : FocusGroup ) : void;
		
		/**
		 * Recoit l'évènement <code>FocusEvent.FOCUS_IN</code> de l'objet
		 * implémentant <code>Focusable</code>;
		 * 
		 * @param	e	évènement diffusé par la classe 
		 */
		function focusIn( e : FocusEvent) : void;
		/**
		 * Recoit l'évènement <code>FocusEvent.FOCUS_OUT</code> de l'objet
		 * implémentant <code>Focusable</code>;
		 * 
		 * @param	e	évènement diffusé par la classe 
		 */		function focusOut( e : FocusEvent) : void;
		/**
		 * Recoit l'évènement <code>FocusEvent.KEY_FOCUS_CHANGE</code> de l'objet
		 * implémentant <code>Focusable</code>;
		 * 
		 * @param	e	évènement diffusé par la classe 
		 */		function keyFocusChange( e : FocusEvent) : void;
	}
}
