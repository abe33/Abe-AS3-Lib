/**
 * @license
 */
package aesia.com.ponents.core 
{
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.LayeredSprite;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.dnd.gestures.PressAndMoveGesture;

	import flash.events.IEventDispatcher;
	
	/**
	 * Implémentation standard d'un composant activant la fonctionalité de glisser/déposer.
	 * <p>
	 * L'implémentation de base utilise un objet <code>PressAndMoveGesture</code> comme 
	 * gestionnaire de déclenchement des actions de glisser/déposer.
	 * </p>
	 * @see aesia.com.ponents.dnd.gestures.PressAndMoveGesture
	 */
	public class DraggableComponent extends AbstractComponent implements DragSource,
																		 Component, 
																		 IDisplayObject, 
																		 IInteractiveObject, 
																		 IDisplayObjectContainer, 
																		 Focusable,
																		 LayeredSprite, 
																		 IEventDispatcher
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
