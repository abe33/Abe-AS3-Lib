/**
 * @license
 */
package  aesia.com.mands
{
	import aesia.com.mands.Command;
	import aesia.com.mon.core.Iterable;
	import aesia.com.mon.core.Runnable;

	/**
	 * Encapsule l'éxécution d'une itération de boucle au sein d'un objet
	 * pour un usage avec une commande <code>LoopCommand</code>.
	 * <p>
	 * Un objet <code>IterationCommand</code> utilisé à l'aide d'une 
	 * <code>LoopCommand</code> verra sa méthode <code>execute</code>
	 * appelée autant de fois que d'itérations dans la boucle avec en
	 * paramètre les données extraite de l'objet <code>Iterator</code>
	 * renvoyée par l'<code>IterationCommand</code>.
	 * </p>
	 */
	public interface IterationCommand extends Command, Iterable, Runnable
	{}
}