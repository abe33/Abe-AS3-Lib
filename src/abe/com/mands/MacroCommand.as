/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Runnable;
	/**
	 * Une <code>MacroCommand</code> est une commande aggrégeant d'autres
	 * commandes.
	 */
	public interface MacroCommand extends Command, Runnable
	{
		/**
		 * Ajoute une <code>Command</code> à l'instance courante. 
		 * Aucun ordre particulier n'est imposé quant à l'ajout
		 * de commande au sein d'une <code>MacroCommand</code>.
		 * 
		 * @param	c	commande à ajouter à cette instance
		 * @return	<code>true</code> si la commande a été
		 * 			ajouté avec succès, <code>false</code>
		 * 			autrement
		 */
		function addCommand ( c : Command ) : Boolean;
		/**
		 * Enlève une <code>Command</code> à l'instance courante.  
		 * 
		 * @param	c	commande à supprimer de cette instance
		 * @return	<code>true</code> si la commande a été
		 * 			supprimé avec succès, <code>false</code>
		 * 			autrement
		 */
		function removeCommand ( c : Command ) : Boolean;	
	}
}