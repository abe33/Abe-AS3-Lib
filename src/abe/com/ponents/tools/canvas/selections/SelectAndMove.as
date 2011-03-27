package abe.com.ponents.tools.canvas.selections 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.mon.geom.pt;
	import abe.com.mon.colors.Color;
	import abe.com.ponents.events.ToolEvent;
	import abe.com.ponents.nodes.core.CanvasElement;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.ObjectSelection;
	import abe.com.ponents.tools.canvas.Tool;
	import abe.com.ponents.tools.canvas.core.AbstractTool;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class SelectAndMove extends AbstractTool implements Tool 
	{
		static public var SELECTION_COLOR : Color = new Color( "52aed3" );
		
		static protected const NONE : Number = 0;		static protected const SELECT : Number = 1;		static protected const MOVE : Number = 2;
		
		protected var pressPoint : Point;		protected var stagePressPoint : Point;
		protected var selectionShape : Shape;
		
		protected var mode : Number;
		protected var selection : ObjectSelection;
		
		protected var allowMoves : Boolean;
		
		protected var _objectsOffset : Dictionary;

		public function SelectAndMove ( selection : ObjectSelection, 
										cursor : Cursor = null, 
										allowMoves : Boolean = true )
		{
			super( cursor );
			this.selection = selection;
			this.allowMoves = allowMoves;
			selectionShape = new Shape();
			mode = NONE;
		}
		override public function actionStarted (e : ToolEvent) : void
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			pressPoint = new Point( e.canvas.topLayer.mouseX, e.canvas.topLayer.mouseY );			stagePressPoint = new Point( StageUtils.stage.mouseX, StageUtils.stage.mouseY );
			
			if( o == null )
			{
				ToolKit.toolLevel.addChild( selectionShape );
				mode = SELECT;
			}
			else if( allowMoves )
			{
				mode = MOVE;
				
				//if( this.selection.numObjects > 0 )
				if( !selection.contains( o ) )
				{
					selection.removeAll();
					selection.add( o );
				}
				
				_objectsOffset = new Dictionary(true);
				for each( var obj:DisplayObject in selection.objects  )
					_objectsOffset[obj] = pt( obj.x - pressPoint.x, obj.y - pressPoint.y );
			}
		}
		override public function actionFinished (e : ToolEvent) : void
		{
			if( mode == SELECT )
			{
				ToolKit.toolLevel.removeChild( selectionShape );
				selectionShape.graphics.clear();
				
				selection.removeAll();
				selection.addMany( getObjectsInRectangle(e) );
			}
			mode = NONE;
		}
		protected function getObjectsInRectangle( e : ToolEvent ) : Array
		{
			var a : Array = [];
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
						a.push( o );
				}
			}
			return a;
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
				selectionShape.graphics.lineStyle( 0, SELECTION_COLOR.hexa );				selectionShape.graphics.beginFill( SELECTION_COLOR.hexa, .3 );
				selectionShape.graphics.drawRect( xstart, ystart, xend - xstart, yend - ystart );
				selectionShape.graphics.endFill();
			}
			else if( mode == MOVE )
			{
				for each ( var o : DisplayObject in selection.objects )
				{
					if( o is CanvasElement && !( o as CanvasElement ).isMovable )
						continue;
					
					o.x = e.canvas.topLayer.mouseX + _objectsOffset[o].x;
					o.y = e.canvas.topLayer.mouseY + _objectsOffset[o].y;
				}
				//pressPoint.x = e.canvas.topLayer.mouseX;				//pressPoint.y = e.canvas.topLayer.mouseY;
			}
		}
	}
}
