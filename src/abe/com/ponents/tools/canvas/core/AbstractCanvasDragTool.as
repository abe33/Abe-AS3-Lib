package abe.com.ponents.tools.canvas.core
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.CameraCanvas;
	import abe.com.ponents.tools.canvas.ToolGestureData;
	import abe.com.ponents.utils.ToolKit;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AbstractCanvasDragTool extends AbstractCanvasTool
	{
		protected var pressPoint : Point;
		protected var stagePressPoint : Point;
		protected var geometryShape : Shape;

		static public var GEOMETRY_COLOR : Color = new Color( "52aed3" );
		
		public function AbstractCanvasDragTool( canvas:CameraCanvas, cursor : Cursor = null )
		{
			super(canvas, cursor);
			geometryShape = new Shape();
		}
		override public function actionStarted (e : ToolGestureData) : void
		{
			initDragGesture();
		}
		override public function actionFinished (e : ToolGestureData) : void
		{
			clearDrag();
		}
		override public function actionAborted (e : ToolGestureData) : void
		{
			clearDrag();
		}
		override public function mousePositionChanged(e:ToolGestureData):void
		{
			drawDragGeometry( getStageDragRectangle(), GEOMETRY_COLOR );
		}
		protected function initDragGesture():void
		{
			pressPoint = new Point( _canvas.topLayer.mouseX, _canvas.topLayer.mouseY );
			stagePressPoint = new Point( StageUtils.stage.mouseX, StageUtils.stage.mouseY );
			ToolKit.toolLevel.addChild( geometryShape );
		}
		protected function clearDrag():void
		{
			if( !geometryShape || !geometryShape.stage )
				return;
			
			ToolKit.toolLevel.removeChild( geometryShape );	
			geometryShape.graphics.clear();
		}
		protected function getDragRectangle() : Rectangle
		{
			var xstart : Number = Math.min( pressPoint.x, _canvas.topLayer.mouseX );
			var ystart : Number = Math.min( pressPoint.y, _canvas.topLayer.mouseY);
			
			var xend : Number = Math.max( pressPoint.x, _canvas.topLayer.mouseX );
			var yend : Number = Math.max( pressPoint.y, _canvas.topLayer.mouseY);
			
			var area : Rectangle = new Rectangle ( xstart, ystart, xend - xstart, yend - ystart );
			return area;
		}
		protected function getStageDragRectangle() : Rectangle
		{
			var pt : Point = new Point( StageUtils.stage.mouseX, StageUtils.stage.mouseY );
			
			var xstart : Number = Math.min( stagePressPoint.x, pt.x );
			var ystart : Number = Math.min( stagePressPoint.y, pt.y);
			
			var xend : Number = Math.max( stagePressPoint.x, pt.x );
			var yend : Number = Math.max( stagePressPoint.y, pt.y);
			
			var area : Rectangle = new Rectangle ( xstart, ystart, xend - xstart, yend - ystart );
			return area;
		}
		protected function drawDragGeometry( r : Rectangle, color : Color ):void
		{
			geometryShape.graphics.clear();
			geometryShape.graphics.lineStyle( 0, color.hexa );
			geometryShape.graphics.beginFill( color.hexa, .3 );
			geometryShape.graphics.drawRect( r.x, r.y, r.width, r.height );
			geometryShape.graphics.endFill();
		}
	}
}