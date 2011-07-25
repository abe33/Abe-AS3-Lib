package abe.com.ponents.nodes.tools
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.pt;
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.nodes.core.CanvasNode;
	import abe.com.ponents.nodes.core.CanvasNote;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.CameraCanvas;
	import abe.com.ponents.tools.canvas.ToolGestureData;
	import abe.com.ponents.tools.canvas.core.AbstractCanvasTool;
	import abe.com.ponents.utils.ToolKit;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CreateNoteTool extends AbstractCanvasTool
	{
		static public var SELECTION_COLOR : Color = new Color( "52aed3" );
		
		protected var pressPoint : Point;
		protected var stagePressPoint : Point;
		protected var selectionShape : Shape;
		
		public function CreateNoteTool(canvas:CameraCanvas, cursor:Cursor=null)
		{
			super(canvas, cursor);
			selectionShape = new Shape();
		}
		override public function actionStarted (e : ToolGestureData) : void
		{
			pressPoint = new Point( e.canvas.topLayer.mouseX, e.canvas.topLayer.mouseY );
			stagePressPoint = new Point( StageUtils.stage.mouseX, StageUtils.stage.mouseY );
			ToolKit.toolLevel.addChild( selectionShape );
		}
		override public function actionFinished (e : ToolGestureData) : void
		{
			ToolKit.toolLevel.removeChild( selectionShape );
			selectionShape.graphics.clear();
			
			var xstart : Number = Math.min( pressPoint.x, e.canvas.topLayer.mouseX );
			var ystart : Number = Math.min( pressPoint.y, e.canvas.topLayer.mouseY);
			
			var xend : Number = Math.max( pressPoint.x, e.canvas.topLayer.mouseX );
			var yend : Number = Math.max( pressPoint.y, e.canvas.topLayer.mouseY);
			
			var area : Rectangle = new Rectangle ( xstart, ystart, xend - xstart, yend - ystart );
			
			var note : CanvasNote = new CanvasNote(_("Note"));
			note.x = area.x;
			note.y = area.y;
			note.width = area.width;
			note.height = area.height;
			
			_canvas.addComponentToLayer( note, 0 );
		}
		override public function actionAborted (e : ToolGestureData) : void
		{
			if( !selectionShape || !selectionShape.stage )
				return;
			
			ToolKit.toolLevel.removeChild( selectionShape );
			selectionShape.graphics.clear();
		}
		override public function mousePositionChanged (e : ToolGestureData) : void
		{
			var xstart : Number = Math.min( stagePressPoint.x, ToolKit.toolLevel.mouseX );
			var ystart : Number = Math.min( stagePressPoint.y, ToolKit.toolLevel.mouseY);
			
			var xend : Number = Math.max( stagePressPoint.x, ToolKit.toolLevel.mouseX );
			var yend : Number = Math.max( stagePressPoint.y, ToolKit.toolLevel.mouseY);
			
			selectionShape.graphics.clear();
			selectionShape.graphics.lineStyle( 0, SELECTION_COLOR.hexa );
			selectionShape.graphics.beginFill( SELECTION_COLOR.hexa, .3 );
			selectionShape.graphics.drawRect( xstart, ystart, xend - xstart, yend - ystart );
			selectionShape.graphics.endFill();
		}
	}
}