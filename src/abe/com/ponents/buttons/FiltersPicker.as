/**
 * @license 
 */
package abe.com.ponents.buttons 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.builtin.EditFiltersAction;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
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
	public class FiltersPicker extends AbstractButton  implements IDisplayObject, 
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
		 * Constructeur de la classe <code>FiltersPicker</code>.
		 * 
		 * @param	filters	un tableau d'objet <code>BitmapFilter</code>
		 * @param	icon	un icône représentant l'action du composant
		 */
		public function FiltersPicker (filters : Array = null, icon : Icon = null)
		{
			super( new EditFiltersAction( filters ? filters : [], icon) );
		}
		/**
		 * Une référence vers le tableau de filtres de cet objet <code>FiltersPicker</code>.
		 */
		public function get value () : * { return (_action as EditFiltersAction).filters; }		
		public function set value (value : *) : void
		{
			(_action as EditFiltersAction).filters = value as Array;
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
					break;
					
				case FormComponentDisabledModes.UNDEFINED : 
					disabledValue = _("not defined");
					affectLabelText();
					break;
				
				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED : 
				default : 
					affectLabelText();
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
		override protected function commandEnd (e : CommandEvent) : void
		{
			super.commandEnd( e );
			fireDataChange();
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
