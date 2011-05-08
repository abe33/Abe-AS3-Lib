/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Iterable;
	import abe.com.mon.core.Runnable;
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