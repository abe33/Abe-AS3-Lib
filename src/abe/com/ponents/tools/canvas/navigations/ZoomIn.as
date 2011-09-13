package abe.com.ponents.tools.canvas.navigations 
{
    import abe.com.edia.camera.Camera;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.canvas.Tool;
    import abe.com.ponents.tools.canvas.ToolGestureData;
    import abe.com.ponents.tools.canvas.core.AbstractTool;

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

		override public function actionFinished (e : ToolGestureData) : void
		{
			var pt : Point = e.mousePosition;
			_camera.zoomInAroundPoint( pt );
		}
	}
}
