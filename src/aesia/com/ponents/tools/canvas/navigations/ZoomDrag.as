package aesia.com.ponents.tools.canvas.navigations 
{
	import aesia.com.edia.camera.Camera;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.tools.canvas.core.AbstractTool;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ZoomDrag extends AbstractTool 
	{
		protected var _camera : Camera;
		protected var _startPoint : Point;
		
		public function ZoomDrag ( camera : Camera, cursor : Cursor = null)
		{
			super( cursor );
			this._camera = camera;
		}
		
		override public function actionStarted (e : ToolEvent) : void
		{
			_startPoint = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
		}

		override public function mousePositionChanged (e : ToolEvent) : void
		{
			var pt : Point = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
			
			var dif : Number = _startPoint.y - pt.y;					
			_camera.zoom += dif/200;
						
			_startPoint = pt;
		}
	}
}
