package abe.com.ponents.tools.canvas.navigations 
{
	import abe.com.edia.camera.Camera;
	import abe.com.ponents.events.ToolEvent;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.canvas.core.AbstractTool;
	import abe.com.ponents.tools.canvas.Tool;

	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public class ZoomOut extends AbstractTool implements Tool 
	{
		protected var _camera : Camera;

		public function ZoomOut ( camera : Camera, cursor : Cursor = null)
		{
			super( cursor );
			this._camera = camera;
		}

		override public function actionFinished (e : ToolEvent) : void
		{
			var pt : Point = e.mousePosition;
			_camera.zoomOutAroundPoint(pt);
		}
	}
}