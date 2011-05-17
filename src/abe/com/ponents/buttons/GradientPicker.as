/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mands.*;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.builtin.GradientPickerAction;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.layouts.display.DOStretchLayout;

	import flash.events.IEventDispatcher;

	
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
	public class GradientPicker extends AbstractButton  implements IDisplayObject, 
																  IInteractiveObject, 
																  IDisplayObjectContainer, 
																  Component, 
																  Focusable,
														 		  LayeredSprite,
														 		  IEventDispatcher,
														 		  FormComponent
	{
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
		 */
		protected var _disabledMode : uint;
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		protected var _disabledValue : *;
		
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
		
		protected var _dataChanged : Signal;
		public function get _dataChanged() : Signal { return _dataChanged; }
		/**
		 * Une référence vers l'objet <code>Gradient</code> de ce composant.
		 */
		public function get value () : * { return (action as GradientPickerAction).gradient; }		
		public function set value (value : * ) : void
		{
			(action as GradientPickerAction).gradient = value as Gradient;
			invalidate();
		}
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
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
		override protected function commandEnded (c:Command) : void
		{
			super.commandEnded( e );
			fireDataChangedSignal();
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
		 * Diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code> aux écouteurs
		 * de ce composant.
		 */
		protected function fireDataChangedSignal () : void 
		{
			_dataChanged.dispatch( this, value );
		}
	}
}
