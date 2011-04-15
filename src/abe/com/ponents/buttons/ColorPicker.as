/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.builtin.ColorPickerAction;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.layouts.display.DOStretchLayout;

	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
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
	public class ColorPicker extends AbstractButton  implements IDisplayObject, 
															  IInteractiveObject, 
															  IDisplayObjectContainer, 
															  Component, 
															  Focusable,
													 		  LayeredSprite,
													 		  IEventDispatcher,
													 		  FormComponent
	{
		/**
		 * Un entier représentant le mode de désactivation courant de ce <code>ColorPicker</code>.
		 */
		protected var _disabledMode : uint;
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		protected var _disabledValue : *;
		
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
		public function get value () : * { return (_action as ColorPickerAction).color; }		
		public function set value (value : *) : void
		{
			(_action as ColorPickerAction).color = value as Color;
			invalidate();
		}
		/**
		 * Un entier représentant le mode de désactivation courant de ce <code>ColorPicker</code>.
		 */
		public function get disabledMode () : uint { return _disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			if( !_enabled )
				checkDisableMode();
		}
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		public function get disabledValue () : * { return _disabledValue; }		
		public function set disabledValue (v : *) : void 
		{
			_disabledValue = v;
			
		}
		/**
		 * @inheritDoc
		 */
		override public function set enabled (b : Boolean) : void 
		{
			super.enabled = b;
			checkDisableMode();
			
			if( _enabled && _buttonDisplayMode != ButtonDisplayModes.ICON_ONLY )
				buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			
		}
		/**
		 * Définie l'état du composant lorsque celuici est désactivé.
		 */
		protected function checkDisableMode() : void
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY : 
					disabledValue = _("different values across many");
					affectLabelText();
					buttonDisplayMode = ButtonDisplayModes.TEXT_ONLY;
					break;
					
				case FormComponentDisabledModes.UNDEFINED : 
					disabledValue = _("not defined");
					affectLabelText();
					buttonDisplayMode = ButtonDisplayModes.TEXT_ONLY;
					break;				
				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED : 
				default : 
					buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
					break;
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function affectLabelText () : void 
		{
			if( _enabled )
				super.affectLabelText();
			else
				_labelTextField.htmlText = String( _disabledValue );
		}
		/**
		 * @inheritDoc
		 */
		override protected function commandEnded (e : CommandEvent) : void
		{
			super.commandEnded( e );
			fireDataChange();
		}
		/**
		 * Diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code> aux écouteurs
		 * de ce <code>ColorPicker</code>.
		 */
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}