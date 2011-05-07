/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.IEventDispatcher;
	/**
	 * La classe <code>Button</code> étend <code>AbstractButton</code> afin de fournir une
	 * implémentation concrète de base d'un bouton.
	 * 
	 * @author Cédric Néhémie
	 */
	public class Button extends AbstractButton  implements IDisplayObject, 
															 IInteractiveObject, 
															 IDisplayObjectContainer, 
															 Component, 
															 Focusable,
													 		 LayeredSprite, 
													 		 IEventDispatcher
	{
		/**
		 * Constructeur de la classe <code>Button</code>.
		 * <p>
		 * Si le premier paramètre transmi au constructeur est un objet <code>Action</code>
		 * le label et l'icône de ce bouton seront déterminé à l'aide des données contenues
		 * dans l'objet <code>Action</code>. Auquel cas le second paramètre sera tout simplement
		 * ignoré.
		 * </p>
		 * <p>Si le premier paramètre transmi est une <code>String</code>, celle-ci sera utilisé
		 * comme valeur pour le label de ce bouton, et le second paramètre ne sera pas ignoré.
		 * </p>
		 * 
		 * @param	actionOrLabel	un objet <code>Action</code> ou une chaîne de caractère
		 * @param	icon			un objet <code>Icon</code>
		 */
		public function Button ( actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
		}
	}
}
