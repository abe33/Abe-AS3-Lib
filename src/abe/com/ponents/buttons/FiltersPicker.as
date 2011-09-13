/**
 * @license 
 */
package abe.com.ponents.buttons 
{
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.ponents.actions.builtin.EditFiltersAction;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.skinning.icons.Icon;

	/**
	 * La classe <code>FiltersPicker</code> permet l'édition d'un tableau de filtres
	 * tel utilisable dans le cadre de la propriété <code>filters</code> d'un <code>DisplayObject</code>.
	 * <p>
	 * La classe <code>FiltersPicker</code> utilise en interne une instance de la classe
	 * <code>EditFiltersAction</code>.
	 * </p>
	 * <p>
	 * <strong>Note :</strong> À l'heure actuelle, tout les filtres ne peuvent être créer et 
	 * éditer à l'aide de ce composant. Les filtres faisant appel à des bitmaps ne sont pour
	 * le moment pas fonctionnels.
	 * </p>
	 * @author	Cédric Néhémie
	 * @see	abe.com.ponents.actions.builtin.EditFiltersAction
	 */
	public class FiltersPicker extends AbstractFormButton  implements IDisplayObject, 
															  IInteractiveObject, 
															  IDisplayObjectContainer, 
															  Component, 
															  Focusable,
													 		  LayeredSprite,
													 		  FormComponent 
	{
		/**
		 * Constructeur de la classe <code>FiltersPicker</code>.
		 * 
		 * @param	filters	un tableau d'objet <code>BitmapFilter</code>
		 * @param	icon	un icône représentant l'action du composant
		 */
		public function FiltersPicker ( filters : Array = null, icon : Icon = null)
		{
			super( new EditFiltersAction( filters ? filters : [], icon) );
		}
		/**
		 * Une référence vers le tableau de filtres de cet objet <code>FiltersPicker</code>.
		 */
		override public function get value () : * { return (_action as EditFiltersAction).filters; }		
		override public function set value (value : *) : void
		{
			(_action as EditFiltersAction).filters = value as Array;
			invalidate();
		}
	}
}
