/**
 * @license
 */
package abe.com.ponents.buttons 
{
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.ponents.actions.builtin.CalendarAction;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.skinning.icons.Icon;

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
	public class DatePicker extends AbstractFormButton  implements IDisplayObject, 
															  IInteractiveObject, 
															  IDisplayObjectContainer, 
															  Component, 
															  Focusable,
													 		  LayeredSprite,
													 		  FormComponent
	{
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
		override public function get value () : * { return (_action as CalendarAction).date; }		
		override public function set value (value : *) : void
		{
			(_action as CalendarAction).date = value as Date;
			invalidate();
		}
	}
}
