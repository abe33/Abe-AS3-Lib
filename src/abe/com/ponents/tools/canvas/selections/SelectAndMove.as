package abe.com.ponents.tools.canvas.selections 
{
    import abe.com.ponents.tools.canvas.dummies.Duplicable;
    import abe.com.mon.closures.core.isA;
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.pt;
    import abe.com.ponents.nodes.core.CanvasElement;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelection;
    import abe.com.ponents.tools.canvas.Tool;
    import abe.com.ponents.tools.canvas.ToolGestureData;
    import abe.com.ponents.tools.canvas.core.AbstractCanvasDragTool;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class SelectAndMove extends AbstractCanvasDragTool implements Tool 
	{
		static public var SELECTION_COLOR : Color = new Color( "52aed3" );
        
        static public function noFilter( o : DisplayObject ):Boolean{
            return true;
        }
		
		static protected const NONE : Number = 0;		static protected const SELECT : Number = 1;		static protected const MOVE : Number = 2;
        
        public var selectionFilter : Function = noFilter;
		
		protected var mode : Number;
        
        protected var addToSelection : Boolean;
        protected var duplicateSelection : Boolean;
        
		protected var selection : ObjectSelection;
		
		protected var allowMoves : Boolean;
		
		protected var _objectsOffset : Dictionary;
        
        protected var _originalSelection : Array;
        
        protected var _selectCursor : Cursor;
        protected var _moveCursor : Cursor;
        protected var _selectAddCursor : Cursor;
        protected var _duplicateCursor : Cursor;

		public function SelectAndMove ( canvas : CameraCanvas,
										selection : ObjectSelection, 
										allowMoves : Boolean = true,
										selectCursor : Cursor = null, 
										moveCursor : Cursor = null, 
										selectAddCursor : Cursor = null, 
										duplicateCursor : Cursor = null
                                       )
		{
			super( canvas, selectCursor );
			this.selection = selection;
			this.allowMoves = allowMoves;
            _selectCursor = selectCursor;
            _moveCursor = moveCursor;
            _selectAddCursor = selectAddCursor;
            _duplicateCursor = duplicateCursor;
			mode = NONE;
		}
		override public function actionStarted (e : ToolGestureData) : void
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			initDragGesture();
			if( o == null || !selectionFilter(o) )
			{
				mode = SELECT;
                if( e.ctrlPressed )
                {
                    addToSelection = true;
                    _originalSelection = selection.objects;
                }
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
                
                if( e.ctrlPressed )
                {
                    var b : Boolean = selection.objects.every( isA( Duplicable ) );
                    if( b )
                    {
                        var a : Array = [];
                     	for each( var d : Duplicable in selection.objects )
                             a.push( d.duplicate() );  
                        selection.set(a);
                    }
                }
				
				_objectsOffset = new Dictionary(true);
				for each( var obj:DisplayObject in selection.objects  )
					_objectsOffset[obj] = pt( obj.x - e.canvasMousePosition.x, obj.y - e.canvasMousePosition.y );
			}
		}
		override public function actionFinished (e : ToolGestureData) : void
		{
			if( mode == SELECT )
			{
				clearDrag();
                if(!addToSelection)
					selection.removeAll();
				selection.addMany( getObjectsInRectangle(e) );
			}
			mode = NONE;
            
            addToSelection = false;
            duplicateSelection = false;
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
                    
                    if( !o.visible || !selectionFilter(o) )
                    	continue;
                    
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
