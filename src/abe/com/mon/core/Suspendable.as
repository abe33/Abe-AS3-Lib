/**
 * @license
 */
package  abe.com.mon.core
{
	import abe.com.mon.core.Runnable;

	/**
	 * Un objet <code>Suspendable</code> est un objet <code>Runnable</code>
	 * dont l'éxécution peut-être suspendue et reprise indéfiniment.
	 */
	public interface Suspendable extends Runnable
	{
		/**
		 * Démarre ou redémarre le processus.
		 */
		function start () : void;
		/**
		 * Interrompt le processus.
		 */
		function stop () : void;
	}
}
