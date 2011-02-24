/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * <code>Runnable</code> objects can be any objects that
	 * have a behavior that proceed in time.
	 * <fr>
	 * Un objet <code>Runnable</code> représente tout objet dont
	 * le processus se déroule dans le temps.
	 * </fr>
	 */
	public interface Runnable 
	{
		/**
		 * Returns <code>true</code> if the instance process is running
		 * when the call occurs.
		 * <fr>
		 * Renvoie <code>true</code> si le processus de cette instance
		 * est actuellement en court d'éxécution.
		 * </fr>
		 * @return	<code>true</code> if the instance process is running
		 * 			<fr><code>true</code> si le processus de cette instance
		 * 		   	est actuellement en court d'éxécution</fr>
		 */
		function isRunning () : Boolean;	
	}
}
