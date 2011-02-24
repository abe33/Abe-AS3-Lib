/**
 * @license
 */
package  abe.com.mon.core
{
	import abe.com.mon.core.Runnable;

	/**
	 * A <code>Suspendable</code> object is a <code>Runnable</code>
	 * whose execution can be paused and resumed.
	 * 
	 * <fr>
	 * Un objet <code>Suspendable</code> est un objet <code>Runnable</code>
	 * dont l'éxécution peut-être suspendue et reprise indéfiniment.
	 * </fr>
	 */
	public interface Suspendable extends Runnable
	{
		/**
		 * Start or restart the process.
		 * <fr>
		 * Démarre ou redémarre le processus.
		 * </fr>
		 */
		function start () : void;
		/**
		 * Stop the process.
		 * <fr>
		 * Interrompt le processus.
		 * </fr>
		 */
		function stop () : void;
	}
}
