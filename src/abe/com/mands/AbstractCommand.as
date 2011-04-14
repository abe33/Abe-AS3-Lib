/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Runnable;

	import org.osflash.signals.Signal;
	/**
	 * Implémentation de base de l'interface <code>Command</code>. En règle
	 * générale, il suffit d'étendre <code>AbstractCommand</code> et de réécrire
	 * la méthode <code>execute</code> afin de créer une nouvelle commande.
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractCommand implements Command, Runnable
	{
		/**
		 * Indique si la commande est actuellement en court de traitement.
		 */
		protected var _isRunning : Boolean;
		
		protected var _commandEnded : Signal;		protected var _commandFailed : Signal;
		
		/**
		 * Instancier une <code>AbstractCommand</code> est possible mais
		 * inutile. Par contre appeler le super-constructeur permet de
		 * mettre la propriété <code>_bRunning</code> à <code>false</code>. 
		 */
		public function AbstractCommand ()
		{
			_isRunning = false;
			_commandEnded = new Signal( Command );
			_commandFailed = new Signal( Command, String );
		}
		public function get commandEnded () : Signal { return _commandEnded; }
		public function get commandFailed () : Signal { return _commandFailed; }
		/**
		 * Réécrivez cette fonction pour implémenter le comportement de votre 
		 * commande. Par défaut la méthode <code>execute</code> appelle 
		 * automatiquement la fin de l'éxécution.
		 * 
		 * @param	e	évènement reçue par la commande
		 */
		public function execute( ... args ) : void
		{
			_isRunning = true;
			_commandEnded.dispatch( this );
		}
		/**
		 * Renvoie <code>true</code> si la commande est actuellement en cours 
		 * de processus.
		 * 
		 * @return	<code>true</code> si la commande est actuellement en cours 
		 * 			de processus
		 */
		public function isRunning () : Boolean
		{
			return _isRunning;
		}
		public function register ( closure : Function ) : void
		{
			_commandEnded.add( closure );
		}
		public function unregister ( closure : Function ) : void
		{
			_commandEnded.remove( closure );
		}
	}
}