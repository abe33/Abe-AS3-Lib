/**
 * @license
 */
package aesia.com.ponents.actions 
{
	import aesia.com.mands.Command;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.skinning.icons.Icon;

	/**
	 * Un objet <code>Action</code> est une commande vouée à être utilisé
	 * dans le cadre d'une interface graphique. Une même commande peut 
	 * ainsi être partagée entre plusieurs composants, tel un bouton,
	 * un menu ou tout autre composant.
	 * <p>
	 * Une action possède des propriétés permettant au différent composants
	 * aggrégeant des actions de modifier leur apparence à l'aide des informations
	 * de l'objet <code>Action</code>. Ainsi, le texte et l'icône d'un bouton
	 * seront récupéré prioritairement sur l'objet <code>Action</code> si celui-ci
	 * a été définit.
	 * </p>
	 * 
	 * @author	Cédric Néhémie
	 */
	public interface Action extends Command 
	{
		/**
		 * Une chaîne de caractère utilisé comme texte d'affichage pour cette
		 * action.
		 */
		function get name () : String;		function set name ( s : String ) :void;
		/**
		 * Une référence vers un objet <code>Icon</code> représentant cette action.
		 */		function get icon () : Icon;
		function set icon ( i : Icon ) : void;		/**
		 * Une chaîne de caractère servant de description à l'action.
		 */
		function get longDescription () : String;
		/**
		 * Une référence vers un objet <code>KeyStroke</code> représentant
		 * la combinaison de touches à réaliser afin de déclencher cette action.
		 */
		function get accelerator () : KeyStroke;
		/**
		 * Une valeur booléenne indiquant si cette action est actuellement active
		 * et utilisable par les composants l'aggrégeant.
		 */		function get actionEnabled () : Boolean;
	}
}
