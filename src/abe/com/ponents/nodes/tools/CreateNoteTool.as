package abe.com.ponents.nodes.tools
{
    import abe.com.patibility.lang._;
    import abe.com.ponents.nodes.core.CanvasNote;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.canvas.ToolGestureData;
    import abe.com.ponents.tools.canvas.core.AbstractCanvasDragTool;

    import flash.geom.Rectangle;
	
	public class CreateNoteTool extends AbstractCanvasDragTool
	{
		public function CreateNoteTool(canvas:CameraCanvas, cursor:Cursor=null)
		{
			super(canvas, cursor);
		}
		override public function actionFinished (e : ToolGestureData) : void
		{
			super.actionFinished(e);
			
			var area : Rectangle = getDragRectangle();
			
			var note : CanvasNote = new CanvasNote(_("Note"));
			note.x = area.x;
			note.y = area.y;
			note.width = area.width;
			note.height = area.height;
			
			_canvas.addComponentToLayer( note, 0 );
		}
	}
}