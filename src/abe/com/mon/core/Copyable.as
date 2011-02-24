/**
 * @license
 */
package abe.com.mon.core 
{
	/**
	 * A <code>Copyable</code> provides methods to copy datas from or to a specified
	 * object. Each implementation should define which datas need to be copied.
	 * 
	 * <fr>
	 * Un object <code>Copyable</code> fournit des méthodes permettant de copier
	 * des données vers ou depuis un objet. Chaque implémentation peut définir les
	 * données à copier.
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Copyable 
	{
		/**
		 * Copy the data from this instance into the object <code>o</code>.
		 * 
		 * <fr>
		 * Réalise la copie des données de l'objet courant vers l'objet <code>o</code>.
		 * </fr>
		 * @param	o	an object in which copy the data from this instance
		 * 				<fr>un objet dans lequel copier les données provenant de l'instance courante</fr>
		 */
		function copyTo( o : Object ) : void;
		/**
		 * Copy the data from <code>o</code> and copy it into this instance.
		 * 
		 * <fr>
		 * Réalise la copie des données depuis l'objet <code>o</code> vers l'objet courant.
		 * </fr>
		 * @param	o	an object from which copy the data to this instance
		 * 				<fr>un objet duquel copier les données vers l'instance courante</fr>
		 */
		function copyFrom( o : Object ) : void;
	}
}
