package aesia.com.ponents.tools 
{
	import aesia.com.edia.camera.Camera;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public class ZoomIn extends AbstractTool implements Tool 
	{
		protected var _camera : Camera;

		public function ZoomIn ( camera : Camera, cursor : Cursor = null)
		{
			super( cursor );
			this._camera = camera;
		}

		override public function actionFinished (e : ToolEvent) : void
		{
			var pt : Point = e.mousePosition;
			_camera.zoomInAroundPoint( pt );
		}
	}
}
