/**
 * @license 
 */
package abe.com.ponents.buttons 
{
	import abe.com.ponents.core.*;
	import abe.com.ponents.actions.Action;
	import abe.com.ponents.tools.canvas.actions.SetToolAction;

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
		override public function click ( context : UserActionContext ) : void
		{
			swapSelect(true);
		}
		/**
		 * @inheritDoc
		 */
		override protected function actionPropertyChanged (propertyName : String, propertyValue : *) : void
		{
			switch( propertyName )
			{
				case "selected" : 
					this.selected = propertyValue;
					break;
				default : 
					super.actionPropertyChanged(propertyName, propertyValue);
					break;
			}
			
		}
	}
}
