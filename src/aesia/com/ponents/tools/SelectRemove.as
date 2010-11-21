package aesia.com.ponents.tools 
{
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	/**
	 * @author Cédric Néhémie
	 */
	public class SelectRemove extends AbstractTool implements Tool 
	{
		private var selection : ObjectSelection;

		public function SelectRemove ( selection : ObjectSelection, cursor : Cursor = null )
		{
			super( cursor );
			this.selection = selection;
		}

		override public function actionFinished (e : ToolEvent) : void
		{
			if( e.manager.canvasChildUnderTheMouse != null )
				selection.remove( e.manager.canvasChildUnderTheMouse );	
		}
			
	}
}
