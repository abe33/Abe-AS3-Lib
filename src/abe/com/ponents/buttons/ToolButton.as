/**
 * @license 
 */
package abe.com.ponents.buttons 
{
	import abe.com.ponents.actions.Action;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.tools.canvas.actions.SetToolAction;

	import flash.events.Event;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	/**
	 * Un objet <code>ToolButton</code> est un <code>ToggleButton</code> chargé 
	 * de représenter la sélection d'outil d'un objet <code>ToolManager</code>.
	 * <p>
	 * Un <code>ToolButton</code> se voit en général associer un objet 
	 * <code>SetToolAction</code> en tant qu'action.
	 * </p>
	 * @author Cédric Néhémie
	 * @see	abe.com.ponents.tools.SetToolAction
	 */
	public class ToolButton extends ToggleButton 
	{
		/**
		 * Constructeur de classe <code>ToolButton</code>.
		 * <p>
		 * Si le premier paramètre transmi au constructeur est un objet <code>Action</code>
		 * le label et l'icône de ce bouton seront déterminé à l'aide des données contenues
		 * dans l'objet <code>Action</code>. Auquel cas le second paramètre sera tout simplement
		 * ignoré.
		 * </p>
		 * <p>Si le premier paramètre transmi est une <code>String</code>, celle-ci sera utilisé
		 * comme valeur pour le label de ce bouton, et le second paramètre ne sera pas ignoré.
		 * </p>
		 * 
		 * @param	actionOrLabel	un objet <code>Action</code> ou une chaîne de caractère
		 * @param	icon			un objet <code>Icon</code>
		 */	
		public function ToolButton ( action : Action )
		{
			super( action );
			selected = ( action as SetToolAction ).selected;
		}
		/**
		 * @inheritDoc
		 */
		override public function click (e : Event = null) : void
		{
			swapSelect(true);
		}
		/**
		 * @inheritDoc
		 */
		override protected function actionPropertyChanged (event : PropertyEvent) : void
		{
			switch( event.propertyName )
			{
				case "selected" : 
					this.selected = event.propertyValue;
					break;
				default : 
					super.actionPropertyChanged( event );
					break;
			}
			
		}
	}
}
