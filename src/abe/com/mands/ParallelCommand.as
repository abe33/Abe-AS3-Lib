/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;

	/**
	 */	
	public class ParallelCommand extends AbstractMacroCommand implements Command, MacroCommand, Runnable, Suspendable
	{
		/**
		 * Nombre de retour de fin d'éxécution reçu par l'instance courante.
		 */
		protected var _nCallbackCount : Number;
		
		/**
		 * Créer une nouvelle instance de la classe <code>ParallelCommand</code>.
		 */
		public function ParallelCommand( ... commands )
		{
			super();
			reset();
			
			for each ( var c : Command in commands )
				addCommand( c );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addCommand ( command : Command ) : Boolean
		{
			if( super.addCommand( command ) )
			{
				registerToCommandSignals( command );
				return true;
			}
			else return false;
		}
		/**
		 * @inheritDoc
		 */
		override public function removeCommand (command : Command) : Boolean
		{
			if( super.removeCommand( command ) )
			{
				unregisterToCommandSignals( command );
				return true;
			}
			else return false;
		}
		/**
		 * Éxécute l'ensemble des commandes lors d'un appel à la méthode
		 * <code>execute</code>.
		 * 
		 * @param	e	évènement reçue par la commande
		 */		
		override public function execute( ... args ):void
		{
			var l : Number = _aCommands.length;
			for( var i : Number = 0; i < l; i++ )
			{
				( _aCommands[ i ] as Command ).execute.apply( _aCommands[i], args );
			} 
		}
		/**
		 * Remet à zéro le compteur de fin d'éxécution de sous-commandes. 
		 */
		public function reset() : void
		{
			_nCallbackCount = 0;
		}
		
		/**
		 */
		override protected function onCommandEnded ( command : Command ) : void
		{
			_nCallbackCount++;
			if( _nCallbackCount == _aCommands.length )
			{
				commandEnded.dispatch();
				reset();
			}
		}	
		
		/**
		 */	
		override protected function onCommandFailed ( command : Command, msg : String ) : void
		{
			
			commandFailed.dispatch( msg );
			
			for each ( var c : Command in _aCommands )
			{
				if( command != c && !c.isRunning() && c is Cancelable )
				{
					( c as Cancelable ).cancel();
				}
			}
			reset();
		}
		
		public function start () : void
		{
			_isRunning = true;
			for each ( var c : Suspendable in _aCommands )
				if( c )
					c.start();
		}
		public function stop () : void
		{
			_isRunning = false;
			for each ( var c : Suspendable in _aCommands )
				if( c )
					c.stop();
		}	
	}
}
