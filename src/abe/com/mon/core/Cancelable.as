/**
 * @license
 */
package  abe.com.mon.core 
{
	import org.osflash.signals.Signal;
	/**
	 * A <code>Cancelable</code> object is a <code>Runnable</code> whose run
	 * can be interrupted.
	 * 
	 * <fr>
	 * Un objet <code>Cancelable</code> est un objet <code>Runnable</code> dont
	 * l'éxécution peut-être interrompue.
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Cancelable extends Runnable
	{
		/**
		 * Cancel the current execution of this object if it's running. Concret implementations
		 * of the <code>Cancelable</code> interface can choose to dispatch an event after the
		 * cancelation. In that case, the implementers should take care of dispatching the event
		 * only after the real cancelation of the execution, and not simply in the <code>cancel</code>
		 * call.
		 * <p>
		 * After a call to the <code>cancel</code> method, whether the execution was effectively 
		 * cancelled or not, the <code>isCancelled</code> method must return <code>true</code>.
		 * </p>
		 * 
		 * <fr>
		 * Annule l'éxécution en court. Les classes implémentant cette interface peuvent
		 * choisir de diffuser un évènement lors de l'annulation du processus, cependant
		 * il serait préférable que l'évènement soit diffusé au moment de l'annulation
		 * effective, et non pas seulement de l'appel de la méthode <code>cancel</code>.
		 * <p>
		 * Après un appel à la méthode <code>cancel</code>, que le processus ait été 
		 * effectivement annulé ou non, la méthode <code>isCancelled</code> doit renvoyer
		 * <code>true</code>.
		 * </p>
		 * </fr>
		 */
		function cancel () : void;
		/**
		 * Returns <code>true</code> if the last run of this object
		 * was cancelled with a call to the <code>cancel</code> method. 
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si la dernière éxécution de cette
		 * commande a été annulé.
		 * </fr>
		 * 
		 * @return	<code>true</code> if the last run was cancelled 
		 * 			<fr><code>true</code> si la dernière éxécution de cette
		 * 			objet a été annulé</fr>
		 */
		function isCancelled () : Boolean;
		
		function get commandCancelled () : Signal;
	}
}
