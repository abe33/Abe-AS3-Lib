/**
 * @license
 */
package  aesia.com.mands
{
	import aesia.com.mon.core.Runnable;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

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
	public interface Command extends Runnable, IEventDispatcher
	{
		/**
		 * Exécute la commande. Le paramètre optionnel peut
		 * et doit être utilisé en tant que source de donnée
		 * pour les commandes <i>stateless</i>.
		 *
		 * @param	e	un objet <code>Event</code> utilisé
		 * 				comme source de donnée pour la commande
		 */
		function execute ( e : Event = null ) : void;
		/**
		 * Notifie les éventuels écouteurs de la commande que
		 * son opération est terminée.
		 */
		function fireCommandEnd() : void;
		/**
		 * Notifie les éventuels écouteurs de la commande que
		 * l'opération à échouée ou a été interrompue.
		 *
		 * @param	message	un message permettant d'identifier l'erreur
		 */
		function fireCommandFailed( message : String = "" ) : void;
	}
}
