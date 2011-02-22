/**
 * @license
 */
package abe.com.ponents.actions
{
	/**
	 * Classe permettant de décrire les options disponibles pour une commande de terminal.
	 * 
	 * @author Cédric Néhémie
	 */
	public class TerminalActionOption
	{
		/**
		 * Nom, ou alias, de l'option de la commande.
		 */
		public var name : String;
		/**
		 * Description de l'option de la commande.
		 */
		public var description : String;
		
		/**
		 * Créer une nouvelle instance de la classe <code>TerminalCommandOption</code>.
		 * 
		 * @param	name		nom, ou alias, de l'option de la commande
		 * @param	description description de l'option de la commande
		 */
		public function TerminalActionOption( name : String, description : String = "" )
		{
			this.name = name;
			this.description = description;
		}

	}
}