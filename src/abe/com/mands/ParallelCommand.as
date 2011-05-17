/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;

	/**
	 * Macro-Commande permettant d'éxécuter plusieurs autres commandes 
	 * simultanément et de ne renvoyer un évènement <code>CommandEvent.COMMAND_END</code> 
	 * qu'une fois toutes les commandes terminées.
	 * <p>
	 * On pourrait dire qu'il s'agit là d'un <code>Batch</code>, mais l'implémentation
	 * du <code>Batch</code> prend en compte la nature asynchrone des commandes, 
	 * ici le principe est d'éxécuter les commandes en parallèle 
	 * (alors que le <code>Batch</code> les éxécute en série).
	 * </p>
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
				registerToCommandEvents( command );
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
				unregisterToCommandEvents( command );
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
				( _aCommands[ i ] as Command ).execute( e );
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
		 * Recoit les évènements de fin d'éxécution des sous-commandes et diffuse un
		 * évènement <code>CommandEvent.COMMAND_FAIL</code>
		 * 
		 * @param	e	évènement diffusé par la sous commande
		 */
		protected function onCommandEnded ( command : Command ) : void
		{
			_nCallbackCount++;
			if( _nCallbackCount == _aCommands.length )
			{
				commandEnded.dispatch();
				reset();
			}
		}	
		
		/**
		 * Rediffuse un évènement <code>CommandEvent.COMMAND_FAIL</code> lorsqu'une
		 * commande à échouée.
		 * 
		 * @param	e	évènement diffusé par la sous commande
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
