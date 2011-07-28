package abe.com.ponents.tools.canvas.geom
{
	import abe.com.mon.geom.Rectangle2;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.CameraCanvas;
	import abe.com.ponents.tools.canvas.ToolGestureData;
	import abe.com.ponents.tools.canvas.core.AbstractCanvasDragTool;
	
	import flash.geom.Rectangle;
	
	public class CreateRectangleTool extends AbstractCanvasDragTool
	{
		public function CreateRectangleTool(canvas:CameraCanvas, cursor:Cursor=null)
		{
			super(canvas, cursor);
		}
		
		override public function actionFinished(e:ToolGestureData):void{
			super.actionFinished(e);
			
			var r : Rectangle = getDragRectangle();
			var r2 : Rectangle2 = new Rectangle2(r);
			
			var spr : GeometrySprite = new RectangleSprite( r2 );
			
			_canvas.topLayer.addChild( spr ); 
		}
	}
}