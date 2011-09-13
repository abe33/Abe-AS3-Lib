package abe.com.ponents.events 
{
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.canvas.ToolManager;

    import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public class ToolEvent extends ComponentEvent 
	{
		static public const TOOL_SELECT : String = "toolSelect";		static public const TOOL_USE : String = "toolUse";		static public const ACTION_START : String = "actionStart";		static public const ACTION_FINISH : String = "actionFinish";		static public const ACTION_ABORT : String = "actionAbort";

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
