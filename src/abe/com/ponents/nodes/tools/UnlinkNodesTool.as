package abe.com.ponents.nodes.tools 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.events.ToolEvent;
	import abe.com.ponents.nodes.actions.UnlinkNodesCommand;
	import abe.com.ponents.nodes.core.NodeLink;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.canvas.Tool;
	import abe.com.ponents.tools.canvas.core.AbstractTool;

	import flash.display.DisplayObject;
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
