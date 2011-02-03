package aesia.com.ponents.nodes.tools 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.nodes.actions.UnlinkNodesCommand;
	import aesia.com.ponents.nodes.core.NodeLink;
	import flash.display.DisplayObject;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.tools.canvas.Tool;
	import aesia.com.ponents.tools.canvas.core.AbstractTool;
	/**
	 * @author cedric
	 */
	public class UnlinkNodesTool extends AbstractTool implements Tool 
	{
		public function UnlinkNodesTool (cursor : Cursor = null)
		{
			super( cursor );
		}
		override public function actionFinished (e : ToolEvent) : void 
		{
			var o : DisplayObject = e.canvas.getObjectUnderTheMouse();
			
			if( o is NodeLink )
				new UnlinkNodesCommand(o as NodeLink).execute();
			
			StageUtils.stage.focus = e.canvas;
			
			super.actionFinished( e );
		}
	}
}
