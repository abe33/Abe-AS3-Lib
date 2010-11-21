package aesia.com.ponents.containers 
{
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.dnd.gestures.PressAndMoveGesture;

	/**
	 * @author Cédric Néhémie
	 */
	public class DraggablePanel extends Panel implements DragSource 
	{
		static public const DRAG_THRESHOLD : Number = 6;
		
		public function DraggablePanel ()
		{
			super();
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			this.allowDrag = true;
			this.gesture = new PressAndMoveGesture();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}
