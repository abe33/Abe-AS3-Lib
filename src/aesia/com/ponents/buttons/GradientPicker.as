/**
 * @license
 */
package aesia.com.ponents.buttons 
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.LayeredSprite;
	import aesia.com.mon.utils.Gradient;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.builtin.GradientPickerAction;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.layouts.display.DOStretchLayout;

	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType aesia.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]
	
	/**
	 * Le composant <code>GradientPicker</code> permet l'édition d'objets <code>Gradient</code>
	 * à travers un popup d'édition.
	 * <p>
	 * La classe <code>GradientPicker</code> utilise un objet <code>GradientPickerAction</code>
	 * en interne.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	aesia.com.ponents.actions.builtin.GradientPickerAction
	 * @see aesia.com.mon.utils.Gradient
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
		}
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
		override protected function commandEnd (e : CommandEvent) : void
		{
			super.commandEnd( e );
			fireDataChange();
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
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}