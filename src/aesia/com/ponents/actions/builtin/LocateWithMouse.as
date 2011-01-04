package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.geom.pt;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.utils.Inspect;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * @author cedric
	 */
	public class LocateWithMouse extends AbstractAction 
	{
		public function LocateWithMouse (name : String = "", 
										 icon : Icon = null, 
										 longDescription : String = null,
										 accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
		}
		
		private var lastObject : DisplayObject;
		private var shape : Shape = new Shape();
		
		override public function execute (e : Event = null) : void 
		{
			ToolKit.toolLevel.addChild( shape );
			StageUtils.stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );			StageUtils.root.addEventListener( MouseEvent.MOUSE_UP, mouseUp, true );			StageUtils.root.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown, true );
		}
		protected function mouseUp (event : MouseEvent) : void 
		{
			event.stopImmediatePropagation();
			
			if( lastObject )
				Log.debug( "clicked on "+ Inspect.pathTo( lastObject ) );

			ToolKit.toolLevel.removeChild( shape );
			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
			StageUtils.root.removeEventListener( MouseEvent.MOUSE_UP, mouseUp, true );			StageUtils.root.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown, true );
			
			fireCommandEnd();
		}
		protected function mouseDown (event : MouseEvent) : void 
		{
			event.stopImmediatePropagation();
		}
		protected function stageMouseMove (event : MouseEvent) : void 
		{
			event.stopImmediatePropagation();
			
			var a : Array = StageUtils.stage.getObjectsUnderPoint(pt(event.stageX, event.stageY ) );
			
			var o : DisplayObject = a[a.length-1];
			if( o == shape )
				o = a[a.length-2];
			shape.graphics.clear();
			if( o != lastObject )
			{
				lastObject = o;
			}
			
			if( lastObject )
			{
				var r : Rectangle = o.getBounds(StageUtils.stage);
				shape.graphics.lineStyle(0, Color.Cyan.hexa);				shape.graphics.beginFill(Color.Cyan.hexa,.2);
				shape.graphics.drawRect(r.x, r.y, r.width, r.height);
				shape.graphics.endFill();
			}
		}
	}
}
