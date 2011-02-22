/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * Un objet <code>Runnable</code> représente tout objet dont
	 * le processus se déroule dans le temps.
	 */
	public interface Runnable 
	{
		/**
		 * Renvoie <code>true</code> si le processus de cette instance
		 * est actuellement en court d'éxécution.
		 * 
		 * @return <code>true</code> si le processus de cette instance
		 * 		   est actuellement en court d'éxécution
		 */
		function isRunning () : Boolean;	
	}
}
