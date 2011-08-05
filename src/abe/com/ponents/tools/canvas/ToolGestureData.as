package abe.com.ponents.tools.canvas
{
	import abe.com.ponents.tools.CameraCanvas;
	
	import flash.geom.Point;

	public class ToolGestureData
	{
		public var manager : ToolManager;
		public var mousePosition : Point;
		public var altPressed : Boolean;
		public var ctrlPressed : Boolean;
		public var shiftPressed : Boolean;
		public var canvas : CameraCanvas;
		
		public function ToolGestureData( manager : ToolManager, 
										 mousePos : Point, 
										 ctrlPressed : Boolean, 
										 shiftPressed : Boolean, 
										 altPressed : Boolean )
		{
			this.manager = manager;
			this.canvas = manager.canvas;
			this.mousePosition = mousePos;
			this.ctrlPressed = ctrlPressed;
			this.shiftPressed = shiftPressed;
			this.altPressed = altPressed;
		}
	}
}