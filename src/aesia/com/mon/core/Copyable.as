package aesia.com.mon.core 
{
	/**
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Copyable 
	{
		/**
		 * Réalise la copie des données de l'objet courant vers l'objet <code>o</code>.
		 * 
		 */
		function copyTo( o : Object ) : void;
		/**
		 * Réalise la copie des données depuis l'objet <code>o</code> vers l'objet courant.
		 */
		function copyFrom( o : Object ) : void;
	}
}
