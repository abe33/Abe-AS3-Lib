/**
 * @license
 */
package abe.com.ponents.buttons 
{
    import abe.com.mon.colors.Gradient;
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.ponents.actions.builtin.GradientPickerAction;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.layouts.display.DOStretchLayout;

    import org.osflash.signals.Signal;
	
	/**
	 * Le composant <code>GradientPicker</code> permet l'édition d'objets <code>Gradient</code>
	 * à travers un popup d'édition.
	 * <p>
	 * La classe <code>GradientPicker</code> utilise un objet <code>GradientPickerAction</code>
	 * en interne.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.ponents.actions.builtin.GradientPickerAction
	 * @see abe.com.mon.utils.Gradient
	 */
	public class GradientPicker extends AbstractFormButton  implements IDisplayObject, 
																  IInteractiveObject, 
																  IDisplayObjectContainer, 
																  Component, 
																  Focusable,
														 		  LayeredSprite,
														 		  FormComponent
	{
		
		/**
		 * Constructeur de la classe <code>GradientPicker</code>.
		 * 
		 * @param	gradient	un objet <code>Gradient</code> à éditer
		 */
		public function GradientPicker ( gradient : Gradient = null )
		{
			super();
			action = new GradientPickerAction(gradient);
			childrenLayout = new DOStretchLayout();
			buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
		    _dataChanged = new Signal();
		}
		
		/**
		 * Une référence vers l'objet <code>Gradient</code> de ce composant.
		 */
		override public function get value () : * { return (action as GradientPickerAction).gradient; }		
		override public function set value (value : * ) : void
		{
			(action as GradientPickerAction).gradient = value as Gradient;
			invalidate();
		}
	}
}
