/**
 * @license 
 */
package  aesia.com.ponents.actions
{
	import aesia.com.mands.Command;
	import aesia.com.mon.core.Runnable;

	/**
	 * Interface définissant les propriétés spécifique que doit fournir une commande
	 * pour être utilisée dans le <code>Terminal</code>.
	 * 
	 * @author	Cédric Néhémie
	 */
	public interface TerminalAction extends Action, Command, Runnable
	{
		/**
		 * Description de la commande. La description comprend en général
		 * une explication sur l'opération réalisée par la commande ainsi
		 * que sur la façon d'utiliser la commande et les options disponibles.
		 */
		function get documentation () : String;
		/**
		 * Une description de la façon d'appeler la commande.
		 */
		function get usage () : String;
		/**
		 * La chaîne déclenchant l'éxécution de la commande.
		 */
		function get command () : String;
		/**
		 * Un tableau contenant les différentes options disponible pour la commande
		 * afin de permettre l'autocomplétion des options. 
		 * <p>
		 * Les options sont des objets <code>TerminalCommandOption</code>.
		 * </p>
		 */
		function get optionsList () : Vector.<TerminalActionOption>;
	}
}