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
	import abe.com.ponents.actions.builtin.CalendarAction;
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
	 * Le composant <code>DatePicker</code> permet l'édition d'objet <code>Date</code>
	 * à travers un calendrier.
	 * <p>
	 * Le composant <code>DatePicker</code> utilise en interne une instance de la classe
	 * <code>CalendarAction</code>.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.ponents.actions.builtin.CalendarAction
	 */
	public class DatePicker extends AbstractButton  implements IDisplayObject, 
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
		 * Constructeur de la classe <code>DatePicker</code>.
		 * 
		 * @param	date		l'objet <code>Date</code> pour cette instance
		 * @param	dateFormat	une chaîne de caractère représentant le format de la date
		 * 						tel que définie dans la fonction 
		 * 						<a href="../../mon/utils/DateUtils.html#format()"><code>DateUtils.format</code></a>
		 * @param	icon		un objet <code>Icon</code> 
		 * @see	abe.com.mon.utils.DateUtils#format()
		 */
		public function DatePicker ( date : Date = null, dateFormat : String = "d/m/Y", icon : Icon = null)
		{
			super( new CalendarAction( date ? date : new Date(), dateFormat, icon ) );
		}
		/**
		 * Une référence vers l'objet <code>Date</code> de ce composant <code>DatePicker</code>.
		 */
		public function get value () : * { return (_action as CalendarAction).date; }		
		public function set value (value : *) : void
		{
			(_action as CalendarAction).date = value as Date;
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
		 * @inheritDoc
		 */
		override protected function commandEnd (e : CommandEvent) : void
		{
			super.commandEnd( e );
			fireDataChange();
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
		 * Diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code> aux écouteurs
		 * de ce composant.
		 */
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}
