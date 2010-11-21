/**
 * @license
 */
package  aesia.com.mands
{
	import aesia.com.mands.Command;
	import aesia.com.mands.Interval;
	import aesia.com.mon.core.Cancelable;
	import aesia.com.mon.core.Runnable;
	import aesia.com.mon.core.Suspendable;

	/**
	 * Une commande <code>Timeout</code> est une commande <code>Interval</code>
	 * n'éxécutant qu'un seul appel, à l'instar de la fonction <code>setTimeout</code>.
	 */
	public class Timeout extends Interval implements Suspendable, Cancelable, Runnable, Command
	{
		/**
		 * Créer une instance de la classe <code>Timeout</code>.
		 * 
		 * @param	closure	la fonction à rappeler à la fin de l'intervalle
		 * @param	delay	la durée de l'intervalle
		 * @param	args	suite d'arguments à transmettre à la fonction
		 */
		public function Timeout(closure : Function, delay : uint = 0, ... args)
		{
			super( closure, delay, 1 );
			this.arguments = args;
		}		
	}
}