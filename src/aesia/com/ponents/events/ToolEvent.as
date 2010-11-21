package aesia.com.ponents.events 
{
	import aesia.com.ponents.tools.CameraCanvas;
	import aesia.com.ponents.tools.ToolManager;

	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public class ToolEvent extends ComponentEvent 
	{
		static public const TOOL_SELECT : String = "toolSelected";		static public const TOOL_USED : String = "toolUsed";

		public var ctrlPressed : Boolean;
		public var shiftPressed : Boolean;
		public var altPressed : Boolean;
		public var mousePosition : Point;
		
		private var _manager : ToolManager;

		public function ToolEvent ( type : String, 
									manager : ToolManager, 
									bubbles : Boolean = false, 
									cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			_manager = manager;
		}

		public function get manager () : ToolManager
		{
			return _manager;
		}
		public function get canvas () : CameraCanvas
		{
			return _manager.canvas;
		}
	}
}
