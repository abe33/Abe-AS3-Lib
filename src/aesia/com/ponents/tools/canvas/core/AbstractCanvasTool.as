package aesia.com.ponents.tools.canvas.core 
{
	import aesia.com.ponents.skinning.cursors.Cursor;
	
	import aesia.com.ponents.tools.CameraCanvas;
	/**
	 * @author cedric
	 */
	public class AbstractCanvasTool extends AbstractTool 
	{
		protected var _canvas : CameraCanvas;

		public function AbstractCanvasTool ( canvas : CameraCanvas, cursor : Cursor = null)
		{
			super( cursor );
			_canvas = canvas;
		}
		
		public function get canvas () : CameraCanvas { return _canvas; }
		public function set canvas (canvas : CameraCanvas) : void
		{
			_canvas = canvas;
		}
	}
}
