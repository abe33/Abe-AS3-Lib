/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.core.Runnable;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * Diffusé par la commande à la fin de son éxécution.
	 * 
	 * @eventType abe.com.mands.events.CommandEvent.COMMAND_END
	 */
	[Event(name="commandEnd", type="abe.com.mands.events.CommandEvent")]
	
	/**
	 * Diffusé par la commande en cas d'échec de son processus.
	 * 
	 * @eventType abe.com.mands.events.CommandEvent.COMMAND_FAIL
	 */
	[Event(name="commandFail", type="abe.com.mands.events.CommandEvent")]
	
	/**
	 * Implémentation de base de l'interface <code>Command</code>. En règle
	 * générale, il suffit d'étendre <code>AbstractCommand</code> et de réécrire
	 * la méthode <code>execute</code> afin de créer une nouvelle commande.
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractCommand extends EventDispatcher implements Command, Runnable, IEventDispatcher
	{
		/**
		 * Indique si la commande est actuellement en court de traitement.
		 */
		protected var _isRunning : Boolean;
		
		/**
		 * Instancier une <code>AbstractCommand</code> est possible mais
		 * inutile. Par contre appeler le super-constructeur permet de
		 * mettre la propriété <code>_bRunning</code> à <code>false</code>. 
		 */
		public function AbstractCommand ()
		{
			super( );
			_isRunning = false;
		}
		
		/**
		 * Réécrivez cette fonction pour implémenter le comportement de votre 
		 * commande. Par défaut la méthode <code>execute</code> appelle 
		 * automatiquement la fin de l'éxécution.
		 * 
		 * @param	e	évènement reçue par la commande
		 */
		public function execute ( e : Event = null ) : void
		{
			_isRunning = true;
			fireCommandEnd();
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
			addEventListener( CommandEvent.COMMAND_END, closure );
		}
		public function unregister ( closure : Function ) : void
		{
			removeEventListener( CommandEvent.COMMAND_END, closure );
		}
		/**
		 * Notifie les éventuels écouteurs de la commande que son opération 
		 * est terminée. Un évènement de type <code>CommandEvent.COMMAND_END</code>
		 * est diffusé par la classe. 
		 * <p>
		 * A la fin de l'appel, la commande n'est plus considérée 
		 * comme en cours d'exécution.
		 * </p>
		 */
		public function fireCommandEnd () : void
		{
			_isRunning = false;
			dispatchEvent( new CommandEvent( CommandEvent.COMMAND_END ) );
		}
		/**
		 * Notifie les éventuels écouteurs de la commande que son opération 
		 * a échouée. Un évènement de type <code>CommandEvent.COMMAND_FAIL</code>
		 * est diffusé par la classe. 
		 * <p>
		 * A la fin de l'appel, la commande n'est plus considérée comme 
		 * en cours d'exécution.
		 * </p>
		 */
		public function fireCommandFailed ( message : String = "" ) : void
		{
			_isRunning = false;
			dispatchEvent( new ErrorEvent( CommandEvent.COMMAND_FAIL, true, false, message ) );
		}
		/**
		 * Réécriture de la méthode <code>dispatchEvent</code> afin d'éviter la diffusion
		 * d'évènement en l'absence d'écouteurs pour cet évènement.
		 * 
		 * @param	evt	objet évènement à diffuser
		 * @return	<code>true</code> si l'évènement a bien été diffusé, <code>false</code>
		 * 			en cas d'échec ou d'appel de la méthode <code>preventDefault</code>
		 * 			sur cet objet évènement
		 */
		override public function dispatchEvent( evt : Event) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		 	{
		  		return super.dispatchEvent(evt);
		  	}
		 	return true;
		}
	}
}