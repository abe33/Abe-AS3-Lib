package aesia.com.ponents.tools 
{
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	/**
	 */
	public class SelectAdd extends AbstractTool implements Tool 
	{
		private var selection : ObjectSelection;		

		public function SelectAdd ( selection : ObjectSelection, cursor : Cursor = null )
		{
			super( cursor );
			this.selection = selection;
		}

		override public function actionFinished (e : ToolEvent) : void
		{
			if( e.manager.canvasChildUnderTheMouse != null )
				selection.add( e.manager.canvasChildUnderTheMouse );	
		}
	}
}
