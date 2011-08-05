package abe.com.ponents.tools.canvas.selections 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.pt;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.nodes.core.CanvasElement;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.CameraCanvas;
	import abe.com.ponents.tools.ObjectSelection;
	import abe.com.ponents.tools.canvas.Tool;
	import abe.com.ponents.tools.canvas.ToolGestureData;
	import abe.com.ponents.tools.canvas.core.AbstractCanvasDragTool;
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
	public class SelectAndMove extends AbstractCanvasDragTool implements Tool 
	{
		static public var SELECTION_COLOR : Color = new Color( "52aed3" );
		
		static protected const NONE : Number = 0;		static protected const SELECT : Number = 1;		static protected const MOVE : Number = 2;
		
		protected var mode : Number;
		protected var selection : ObjectSelection;
		
		protected var allowMoves : Boolean;
		
		protected var _objectsOffset : Dictionary;

		public function SelectAndMove ( canvas : CameraCanvas,
										selection : ObjectSelection, 
										cursor : Cursor = null, 
										allowMoves : Boolean = true )
		{
			super( canvas, cursor );
			this.selection = selection;
			this.allowMoves = allowMoves;
			mode = NONE;
		}
		override public function actionStarted (e : ToolGestureData) : void
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			if( o == null )
			{
				initDragGesture();
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
		override public function actionFinished (e : ToolGestureData) : void
		{
			if( mode == SELECT )
			{
				clearDrag();
				selection.removeAll();
				selection.addMany( getObjectsInRectangle(e) );
			}
			mode = NONE;
		}
		protected function getObjectsInRectangle( e : ToolGestureData ) : Array
		{
			var a : Array = [];
			var l : Number = e.canvas.layers.length;
			
			var area : Rectangle = getDragRectangle();
			
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
		override public function actionAborted (e : ToolGestureData) : void
		{
			if( mode == SELECT )
			{
				clearDrag();
			}
			mode = NONE;
		}
		override public function mousePositionChanged (e : ToolGestureData) : void
		{
			if( mode == SELECT )
			{
				super.mousePositionChanged(e);
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
