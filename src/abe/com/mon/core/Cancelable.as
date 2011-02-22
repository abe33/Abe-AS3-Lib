/**
 * @license
 */
package  abe.com.mon.core 
{
	import abe.com.mon.core.Runnable;

	/**
	 * Un objet <code>Cancelable</code> est un objet <code>Runnable</code> dont
	 * l'éxécution peut-être interrompue.
	 */
	public interface Cancelable extends Runnable
	{
		/**
		 * Annule l'éxécution en court. Les classes implémentant cette interface peuvent
		 * choisir de diffuser un évènement lors de l'annulation du processus, cependant
		 * il serait préférable que l'évènement soit diffusé au moment de l'annulation
		 * effective, et non pas seulement de l'appel de la méthode <code>cancel</code>.
		 * <p>
		 * Après un appel à la méthode <code>cancel</code>, que le processus ait été 
		 * effectivement annulé ou non, la méthode <code>isCancelled</code> doit renvoyer
		 * <code>true</code>.
		 * </p>
		 */
		function cancel () : void;
		/**
		 * Renvoie <code>true</code> si la dernière éxécution de cette
		 * commande a été annulé.
		 * 
		 * @return	<code>true</code> si la dernière éxécution de cette
		 * 			commande a été annulé
		 */
		function isCancelled () : Boolean;
	}
}
