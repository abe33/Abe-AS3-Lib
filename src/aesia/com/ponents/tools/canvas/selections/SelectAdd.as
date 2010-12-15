package aesia.com.ponents.tools.canvas.selections 
{
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.tools.ObjectSelection;
	import aesia.com.ponents.tools.canvas.Tool;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	/**
	 */
	public class SelectAdd extends SelectAndMove implements Tool 
	{
		public function SelectAdd ( selection : ObjectSelection, cursor : Cursor=null ) 
		{
			super( selection, cursor );
		}
		override public function actionStarted (e : ToolEvent) : void 
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			pressPoint = new Point( e.canvas.topLayer.mouseX, e.canvas.topLayer.mouseY );
			stagePressPoint = new Point( ToolKit.toolLevel.mouseX, ToolKit.toolLevel.mouseY );
			
			if( o != null )
			{
				selection.add(o);
			}
			ToolKit.toolLevel.addChild( selectionShape );
			mode = SELECT;
		}
		override public function actionFinished (e : ToolEvent) : void
		{
			if( mode == SELECT )
			{
				ToolKit.toolLevel.removeChild( selectionShape );
				selectionShape.graphics.clear();
				
				selection.addMany( getObjectsInRectangle(e) );
				mode = NONE;
			}
			else
				super.actionFinished(e);
		}
	}
}
