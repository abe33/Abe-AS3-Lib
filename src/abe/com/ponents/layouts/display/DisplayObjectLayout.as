/**
 * @license
 */
package abe.com.ponents.layouts.display 
{
	import abe.com.ponents.layouts.Layout;

	import flash.display.DisplayObjectContainer;

	/**
	 * L'interface <code>DisplayObjectLayout</code> définie l'accès au 
	 * type de container utilisé pour la mise en page d'objets <code>DisplayObject</code>.
	 * <p>
	 * Les objets <code>DisplayObjectLayout</code> permettent de mettre en page les éléments
	 * de base constituant les composants simples tel que les <code>Button</code> ou les
	 * <code>TextInput</code>.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface DisplayObjectLayout extends Layout
	{
		/**
		 * Une référence vers l'objet <code>DisplayObjectContainer</code>
		 * contenant les éléments à mettre en page.
		 */
		function set container( o : DisplayObjectContainer ) : void;
		function get container() : DisplayObjectContainer;
	}
}
