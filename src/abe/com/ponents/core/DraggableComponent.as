/**
 * @license
 */
package abe.com.ponents.core 
{
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.dnd.DragSource;
    import abe.com.ponents.dnd.gestures.PressAndMoveGesture;

	/**
	 * Implémentation standard d'un composant activant la fonctionalité de glisser/déposer.
	 * <p>
	 * L'implémentation de base utilise un objet <code>PressAndMoveGesture</code> comme 
	 * gestionnaire de déclenchement des actions de glisser/déposer.
	 * </p>
	 * @see abe.com.ponents.dnd.gestures.PressAndMoveGesture
	 */
	public class DraggableComponent extends AbstractComponent implements DragSource,
																		 Component, 
																		 IDisplayObject, 
																		 IInteractiveObject, 
																		 IDisplayObjectContainer, 
																		 Focusable,
																		 LayeredSprite 
	{
		/**
		 * Constructeur de la classe <code>DraggableComponent</code>.
		 */
		public function DraggableComponent ()
		{
			super();
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			this.allowDrag = true;
			this.gesture = new PressAndMoveGesture();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}
