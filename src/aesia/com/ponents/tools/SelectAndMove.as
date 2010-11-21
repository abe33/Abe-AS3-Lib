package aesia.com.ponents.tools 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class SelectAndMove extends AbstractTool implements Tool 
	{
		
		static protected const NONE : Number = 0;		static protected const SELECT : Number = 1;		static protected const MOVE : Number = 2;
		
		protected var pressPoint : Point;		protected var stagePressPoint : Point;
		protected var selectionShape : Shape;
		
		protected var mode : Number;
		protected var selection : ObjectSelection;

		public function SelectAndMove ( selection : ObjectSelection, cursor : Cursor = null )
		{
			super( cursor );
			this.selection = selection;
			selectionShape = new Shape();
			mode = NONE;
		}
		
		override public function actionStarted (e : ToolEvent) : void
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			pressPoint = new Point( e.canvas.topLayer.mouseX, e.canvas.topLayer.mouseY );			stagePressPoint = new Point( ToolKit.toolLevel.mouseX, ToolKit.toolLevel.mouseY );
			
			if( o == null )
			{
				ToolKit.toolLevel.addChild( selectionShape );
				mode = SELECT;
			}
			else
			{
				mode = MOVE;
				
				if( selection.objects[ o ] == null )
				{
					selection.removeAll();
					selection.add( o );
				}
			}
		}
		
		override public function actionFinished (e : ToolEvent) : void
		{
			if( mode == SELECT )
			{
				ToolKit.toolLevel.removeChild( selectionShape );
				selectionShape.graphics.clear();
				
				selection.removeAll();
				
				var l : Number = e.canvas.layers.length;
				
				var xstart : Number = Math.min( pressPoint.x, e.canvas.topLayer.mouseX );
				var ystart : Number = Math.min( pressPoint.y, e.canvas.topLayer.mouseY);
				
				var xend : Number = Math.max( pressPoint.x, e.canvas.topLayer.mouseX );
				var yend : Number = Math.max( pressPoint.y, e.canvas.topLayer.mouseY);
				
				var area : Rectangle = new Rectangle ( xstart, ystart, xend - xstart, yend - ystart );
				
				for( var i : Number = 0; i < l; i++ )
				{
					var layer : Sprite = e.canvas.getLayerAt(i);
					var cl : Number = layer.numChildren;
					
					for( var j : Number = 0; j<cl;j++)
					{
						var o : DisplayObject = layer.getChildAt( j );
						var bb : Rectangle = o.getBounds( layer );
						if( bb.intersects( area ) )
							selection.add( o );
					}
				}
			}
			mode = NONE;
		}

		override public function actionAborted (e : ToolEvent) : void
		{
			if( mode == SELECT )
			{
				ToolKit.toolLevel.removeChild( selectionShape );
				selectionShape.graphics.clear();
			}
			mode = NONE;
		}

		override public function mousePositionChanged (e : ToolEvent) : void
		{
			if( mode == SELECT )
			{
				var xstart : Number = Math.min( stagePressPoint.x, ToolKit.toolLevel.mouseX );
				var ystart : Number = Math.min( stagePressPoint.y, ToolKit.toolLevel.mouseY);
				
				var xend : Number = Math.max( stagePressPoint.x, ToolKit.toolLevel.mouseX );
				var yend : Number = Math.max( stagePressPoint.y, ToolKit.toolLevel.mouseY);
				
				selectionShape.graphics.clear();
				selectionShape.graphics.lineStyle( 0, Color.Yellow.hexa );				selectionShape.graphics.beginFill( Color.Yellow.hexa, .3 );
				selectionShape.graphics.drawRect( xstart, ystart, xend - xstart, yend - ystart );
				selectionShape.graphics.endFill();
			}
			else
			{
				for each ( var o : DisplayObject in selection.objects )
				{
					o.x += o.parent.mouseX - pressPoint.x;
					o.y += o.parent.mouseY - pressPoint.y;
				}
				pressPoint.x = e.canvas.topLayer.mouseX;				pressPoint.y = e.canvas.topLayer.mouseY;
			}
		}
	}
}
