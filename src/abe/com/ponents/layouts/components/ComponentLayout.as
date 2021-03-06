/**
 * @license
 */
package abe.com.ponents.layouts.components 
{
	import abe.com.ponents.core.Container;
	import abe.com.ponents.layouts.Layout;

	/**
	 * L'interface <code>ComponentLayout</code> définie le type de container
	 * contenant les éléments à mettre en page.
	 * <p>
	 * Un objet <code>ComponentLayout</code> est spécifiquement concus pour
	 * mettre en page des objets de type <code>Component</code> contenu
	 * par un objet <code>Container</code>.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public interface ComponentLayout extends Layout
	{
		/**
		 * Une référence vers un objet <code>Container</code> contenant 
		 * les composants à mettre en page.
		 */
		function get container() : Container;
		function set container( o : Container ) : void;
	}
}
