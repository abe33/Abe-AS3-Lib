/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Runnable;

	import org.osflash.signals.Signal;

	/**
	 * Encapsule une opération au sein d'un objet. Par simplicité
	 * on considère toute les commandes comme étant des processus
	 * asynchrones, la commande doit donc notifier un éventuel écouteur
	 * de la fin de son exécution ou en cas d'échec de celle-ci.
	 * <p>
	 * Une commande est considérée comme <i>stateless</i> (sans état)
	 * si, et seulement si, celle-ci peut réaliser son opération avec
	 * les seules informations fournies en arguments de la méthode
	 * <code>execute</code>.
	 * </p>
	 */
	public interface Command extends Runnable
	{
		/**
		 * Exécute la commande. Le paramètre optionnel peut
		 * et doit être utilisé en tant que source de donnée
		 * pour les commandes <i>stateless</i>.
		 */
		function execute( ... args ) : void;
		
		function get commandEnded () : Signal;
		function get commandFailed () : Signal;
	}
}
