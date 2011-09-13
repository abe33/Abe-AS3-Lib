/**
 * @license
 */
package  abe.com.mands
{
    import abe.com.mon.core.Runnable;

	/**
	 * Une commande <code>Batch</code> éxécute un lot de commandes les unes à la suites des autres
	 * dans l'ordre inverse de leur ajour avec les mêmes paramètres d'entrée que la commande 
	 * <code>Batch</code> elle-même. 
	 */
	public class ReversedBatch extends Batch implements Command, MacroCommand, Runnable
	{
		/**
		 * Créer une nouvelle instance de la classe <code>ReversedBatch</code>.
		 */
		public function ReversedBatch()
		{
			super();
		}
		/**
		 * @inheritDoc 
		 */
		override public function execute( ... args ) : void
		{
			_args = args;
			_nIndex = _aCommands.length;
			_isRunning = true;
			_bCancelled = false;
			
			if( _hasNext() )
				_next().execute( _args );
		}
		/**
		 * @inheritDoc
		 */
		override protected function _next () : Command
		{
			if( _oLastCommand )
				unregisterToCommandSignals( _oLastCommand );
			
			_oLastCommand = _aCommands[ --_nIndex ] as Command;
			
			registerToCommandSignals( _oLastCommand );
			
			return _oLastCommand;
		}
		/**
		 * @inheritDoc
		 */
		override protected function _hasNext () : Boolean
		{
			return _nIndex - 1 >= 0;
		}
	}
}
