/**
 * @license
 */
package  abe.com.mands
{
    import abe.com.mon.core.Runnable;

	/**
	 * Une commande <code>Queue</code> éxécute un lot de commandes les unes à la suites des autres
	 * en transmettant à chaque commande l'évènement de fin reçue de la commande précédente.
	 * La première commande de la <code>Queue</code> reçoie l'évènement transmis à la méthode
	 * <code>execute</code> de la <code>Queue</code>.
	 */
	public class Queue extends Batch implements Command, MacroCommand, Runnable
	{
		/**
		 * Créer une nouvelle instance de la classe <code>Queue</code>.
		 */
		public function Queue()
		{
			super();
		}
		
		/**
		 */
		override protected function onCommandEnded ( command : Command ) : void
		{
			unregisterToCommandSignals( _oLastCommand );
			
			if( _bCancelled )
				commandCancelled.dispatch( this );
			else if( _hasNext() )
				_next().execute( command );
			else
				commandEnded.dispatch( this );
		}
	}
}
