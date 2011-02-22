/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.dnd.DragSource;
	import abe.com.ponents.dnd.gestures.PressAndMoveGesture;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.IEventDispatcher;

	/**
	 * La classe <code>DraggableButton</code> est une implémentation standard 
	 * d'un bouton autorisant les actions de glisser/déposer à travers un 
	 * objet <code>PressAndMoveGesture</code>.
	 * <p>
	 * Dans la plupart des cas il suffit d'étendre cette classe et de redéfinir
	 * le getter de la propriété <code>transferData</code> afin de créer un bouton 
	 * déclenchant des glisser/déposer de données spécifiques.
	 * </p>
	 * <p>
	 * Par défaut ce composant transmet un objet <code>ComponentTransferable</code>
	 * lors d'une action de glisser/déposer.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.ponents.transfer.ComponentTransferable
	 */
	public class DraggableButton extends AbstractButton implements IDisplayObject, 
																   IInteractiveObject, 
																   IDisplayObjectContainer, 
																   Component, 
																   Focusable,
														 		   LayeredSprite,
														 		   IEventDispatcher,
														 		   DragSource
	{
		/**
		 * Constructeur de la classe <code>DraggableButton</code>.
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
		public function DraggableButton ( actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			this.allowDrag = true;
			this.gesture = new PressAndMoveGesture();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}
