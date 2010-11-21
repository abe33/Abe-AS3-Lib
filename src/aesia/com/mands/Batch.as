/**
 * @license
 */
package  aesia.com.mands
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.core.Cancelable;
	import aesia.com.mon.core.Runnable;
	import aesia.com.mon.core.Suspendable;

	import flash.events.ErrorEvent;
	import flash.events.Event;

	/**
	 * Diffusé lorsqu'un appel à <code>cancel</code> conduit à l'arrêt de la commande.
	 * 
	 * @eventType aesia.com.mands.events.CommandEvent.COMMAND_CANCEL
	 */
	[Event(name="commandCancel", type="aesia.com.mands.events.CommandEvent")]
	
	/**
	 * Une commande <code>Batch</code> éxécute un lot de commandes les unes à la suites des autres
	 * avec les mêmes paramètres d'entrée que la commande <code>Batch</code> elle-même. 
	 */
	public class Batch extends AbstractMacroCommand implements Command, MacroCommand, Runnable, Cancelable, Suspendable
	{
		/**
		 * Index de la sous-commande courante.
		 */
		protected var _nIndex : Number;
		/**
		 * Évènement reçu dans un appel d'<code>execute</code> et diffusé à toutes les sous-commandes.
		 */
		protected var _eEvent : Event;
		/**
		 * Référence à la dernière commande éxécutée.
		 */
		protected var _oLastCommand : Command;
		/**
		 * Un booléen indiquant si la dernière éxécution a été annulé.
		 * <p>
		 * Cette valeur est à <code>true</code> immédiatement après un 
		 * appel à <code>cancel</code>.
		 * </p>
		 */
		protected var _bCancelled : Boolean;

		/**
		 * Créer une nouvelle instance de la classe <code>Batch</code>.
		 */
		public function Batch ( ... commands )
		{
			super();
			addCommands.apply( this, commands );
		}
		
		/**
		 * Annule l'éxécution de la commande <code>Batch</code> courante.
		 * <p>
		 * Si la commande en cours d'éxécution implémente elle aussi l'interface
		 * <code>Cancelable</code>, la commande <code>Batch</code> poursuit l'appel
		 * de <code>cancel</code> à la sous-commande.
		 * </p><p>
		 * Si la commande en cours d'éxécution est une commande classique, la
		 * commande <code>Batch</code> attendra la fin d'éxécution de celle-ci
		 * avant de diffusé l'évènement <code>CommandEvent.COMMAND_CANCEL</code>.
		 * </p> 
		 */
		public function cancel () : void
		{
			if( _isRunning )
				_bCancelled = true;
			
			if( _oLastCommand is Cancelable )
			  ( _oLastCommand as Cancelable ).cancel();
		}
		/**
		 * Renvoie <code>true</code> si la dernière éxécution de cette
		 * commande a été annulé.
		 * 
		 * @return	<code>true</code> si la dernière éxécution de cette
		 * 			commande a été annulé
		 */	
		public function isCancelled () : Boolean
		{
			return _bCancelled;
		}
			
		public function start () : void
		{
			if( _oLastCommand is Suspendable )
			  (	_oLastCommand as Suspendable ).start();
		}

		public function stop () : void
		{
			if( _oLastCommand is Suspendable )
			  (	_oLastCommand as Suspendable ).stop();
		}	
		
		/**
		 * Lance l'éxécution de la suite de commandes.
		 * 
		 * @param	e	évènement qui sera transmis à toutes les sous-commandes
		 * 				de cette instance
		 */
		override public function execute ( e : Event = null ) : void
		{
			_eEvent = e;
			_nIndex = -1;
			_bCancelled = false;
			_isRunning = true;
			
			if( _hasNext() )
				_next().execute( _eEvent );
		}
		/**
		 * Intercepte l' évènement de fin d'éxécution de la sous-commande courante
		 * et éxécute la suivante si :
		 * <ul>
		 * <li>La commande <code>Batch</code> n'a pas été annulé entre-temps. 
		 * <p>
		 * Si la commande a été annulé, un évènement <code>CommandEvent.COMMAND_CANCEL</code>
		 * sera diffusé.
		 * </p></li>
		 * <li>Il reste des commandes à éxécuter.<p>
		 * Si il ne reste aucune commande à éxécuter, un évènement 
		 * <code>CommandEvent.COMMAND_END</code> sera diffusé.
		 * </p></li>
		 * </ul>
		 * 
		 * @param	e	évènement de fin diffusé par la sous-commande
		 */
		override protected function commandEnd ( e : Event ) : void
		{
			unregisterToCommandEvents( _oLastCommand );
			
			if( _bCancelled )
			{
				fireCommandCancelled();
			}
			else if( _hasNext() )
			{
				_next().execute( _eEvent );
			}			
			else
			{
				fireCommandEnd();
			}
		}
		
		/**
		 * Intercepte l'évènement <code>CommandEvent.COMMAND_FAIL</code> de 
		 * la sous-commande courante et déclenche à son tour la diffusion de cet
		 * évènement.
		 * 
		 * @param	e	évènement diffusé par la sous-commande
		 */
		override protected function commandFailed ( e : Event ) : void
		{
			unregisterToCommandEvents( _oLastCommand );
			var evt : ErrorEvent = e as ErrorEvent;
			fireCommandFailed( evt.text );
		}
		
		/**
		 * Intercepte l'évènement <code>CommandEvent.COMMAND_CANCEL</code> de 
		 * la sous-commande courante et déclenche à son tour la diffusion de cet
		 * évènement.
		 * 
		 * @param	e	évènement diffusé par la sous-commande
		 */
		override protected function commandCancelled ( e : Event ) : void 
		{
			unregisterToCommandEvents( _oLastCommand );
			fireCommandCancelled();
		}	
		 
		/**
		 * Renvoie la commande suivante dans la liste d'éxécution.
		 * 
		 * @return la commande suivante dans la liste d'éxécution
		 */
		protected function _next () : Command
		{
			_oLastCommand = _aCommands[ ++_nIndex ] as Command;
			
			registerToCommandEvents( _oLastCommand );
			
			return _oLastCommand;
		}		
		/**
		 * Renvoie <code>true</code> si il reste au moins une commande
		 * à éxécuter dans la liste de commandes.
		 * 
		 * @return	<code>true</code> si il reste au moins une commande
		 * à éxécuter dans la liste de commandes
		 */
		protected function _hasNext () : Boolean
		{
			return _nIndex + 1 < _aCommands.length;
		}	
		
		/**
		 * Notifie les éventuels écouteurs de la commande que son opération 
		 * a été annulé par un appel à la méthode <code>cancel</code>. 
		 * Un évènement de type <code>CommandEvent.COMMAND_CANCEL</code>
		 * est alors diffusé par la classe. 
		 * <p>
		 * A la fin de l'appel, la commande n'est plus considérée comme 
		 * en cours d'exécution.
		 * </p>
		 */
		protected function fireCommandCancelled () : void
		{
			_isRunning = false;
			dispatchEvent( new CommandEvent( CommandEvent.COMMAND_CANCEL ) );
		}
	}
}