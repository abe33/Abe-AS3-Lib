/**
 * @license
 */
package  abe.com.mands
{
    import abe.com.mon.core.Cancelable;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.core.Suspendable;

    import org.osflash.signals.Signal;
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
		 * Référence à la dernière commande éxécutée.
		 */
		protected var _oLastCommand : Command;
		protected var _args : Array;
		/**
		 * Un booléen indiquant si la dernière éxécution a été annulé.
		 * <p>
		 * Cette valeur est à <code>true</code> immédiatement après un 
		 * appel à <code>cancel</code>.
		 * </p>
		 */
		protected var _bCancelled : Boolean;
		
		protected var _commandCancelled : Signal;

		/**
		 * Créer une nouvelle instance de la classe <code>Batch</code>.
		 */
		public function Batch ( ... commands )
		{
			super( );
			_commandCancelled = new Signal( Command );
			addCommands.apply( this, commands );
		}
		
		public function get commandCancelled () : Signal { return _commandCancelled; }
		
		/**
		 * Annule l'éxécution de la commande <code>Batch</code> courante.
		 * <p>
		 * Si la commande en cours d'éxécution implémente elle aussi l'interface
		 * <code>Cancelable</code>, la commande <code>Batch</code> poursuit l'appel
		 * de <code>cancel</code> à la sous-commande.
		 * </p><p>
		 * Si la commande en cours d'éxécution est une commande classique, la
		 * commande <code>Batch</code> attendra la fin d'éxécution de celle-ci
		 * avant de diffusé l'évènement <code>commandCancelled</code>.
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
		override public function execute( ... args ) : void
		{
			_args = args;
			_nIndex = -1;
			_bCancelled = false;
			_isRunning = true;
			
			if( _hasNext() )
				_next().execute( _args );
		}
		/**
		 */
		override protected function onCommandEnded ( command : Command ) : void
		{
			unregisterToCommandSignals( _oLastCommand );
			
			if( _bCancelled )
				commandCancelled.dispatch( this );
			else if( _hasNext() )
				_next().execute( _args );
			else
				commandEnded.dispatch( this );
		}
		
		/**
		 */
		override protected function onCommandFailed ( command : Command, msg : String ) : void
		{
			unregisterToCommandSignals( _oLastCommand );
			commandFailed.dispatch( this, msg );
		}
		
		/**
		 */
		override protected function onCommandCancelled ( command : Command ) : void 
		{
			unregisterToCommandSignals( _oLastCommand );
			commandCancelled.dispatch( this );
		}	
		 
		/**
		 * Renvoie la commande suivante dans la liste d'éxécution.
		 * 
		 * @return la commande suivante dans la liste d'éxécution
		 */
		protected function _next () : Command
		{
			_oLastCommand = _aCommands[ ++_nIndex ] as Command;
			
			registerToCommandSignals( _oLastCommand );
			
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
	}
}
