/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mands.*;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.builtin.ColorPickerAction;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.layouts.display.DOStretchLayout;

	import org.osflash.signals.Signal;

	/**
	 * La classe <code>ColorPicker</code> permet de créer un bouton servant
	 * à l'édition d'un objet <code>Color</code>. Lorsque l'on clique sur un
	 * objet <code>ColorPicker</code>, une boîte d'édition s'ouvre permettant
	 * de modifier la couleur définie pour ce <code>ColorPicker</code>.
	 * <p>
	 * La classe <code>colorPicker</code> utilise en interne une instance de la
	 * classe <code>ColorPickerAction</code>.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.ponents.actions.builtin.ColorPickerAction
	 */
	public class ColorPicker extends AbstractFormButton  implements IDisplayObject, 
															  IInteractiveObject, 
															  IDisplayObjectContainer, 
															  Component, 
															  Focusable,
													 		  LayeredSprite,
													 		  FormComponent
	{
		
		/**
		 * Constructeur de la classe <code>ColorPicker</code>.
		 * 
		 * @param	color	la couleur affectée à ce <code>ColorPicker</code>	
		 */
		public function ColorPicker ( color : Color = null )
		{
			super();
			action = new ColorPickerAction(color);
			childrenLayout = new DOStretchLayout();
			buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_isComponentLeaf = true;
			_disabledMode = 0;
		}
		
		/**
		 * Une référence vers l'objet <code>Color</code> de ce <code>ColorPicker</code>.
		 */
		override public function get value () : * { return (_action as ColorPickerAction).color; }		
		override public function set value (value : *) : void
		{
			(_action as ColorPickerAction).color = value as Color;
			invalidate();
		}
	}
}
