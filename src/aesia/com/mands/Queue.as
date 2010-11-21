/**
 * @license
 */
package  aesia.com.mands
{
	import aesia.com.mands.Batch;
	import aesia.com.mands.Command;
	import aesia.com.mands.MacroCommand;
	import aesia.com.mon.core.Runnable;

	import flash.events.Event;

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
		 * Intercepte l' évènement de fin d'éxécution de la sous-commande courante
		 * et éxécute la suivante si :
		 * <ul>
		 * <li>La commande <code>Queue</code> n'a pas été annulé entre-temps. 
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
				_next().execute( e );
			}
			else
			{
				fireCommandEnd();
			}
		}
	}
}