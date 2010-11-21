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
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.builtin.CalendarAction;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType aesia.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]
	/**
	 * Le composant <code>DatePicker</code> permet l'édition d'objet <code>Date</code>
	 * à travers un calendrier.
	 * <p>
	 * Le composant <code>DatePicker</code> utilise en interne une instance de la classe
	 * <code>CalendarAction</code>.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	aesia.com.ponents.actions.builtin.CalendarAction
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
		 * @see	aesia.com.mon.utils.DateUtils#format()
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
