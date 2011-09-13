package abe.com.ponents.tools.canvas.selections
{
    import abe.com.ponents.nodes.core.CanvasElement;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelection;
    import abe.com.ponents.tools.canvas.ToolGestureData;

    import flash.display.DisplayObject;

    /**
     * @author cedric
     */
    public class SelectAndMoveSubObjects extends SelectAndMove
    {
        private var _subObjectsSelection : ObjectSelection;
        private var _objectsSelection : ObjectSelection;
        private var _objectsSelectionFilter : Function;
        public var subObjectsSelectionFilter : Function;
        
        private var _operateOnSubObjects : Boolean;
        
        public function SelectAndMoveSubObjects ( canvas : CameraCanvas, 
        										  selection : ObjectSelection, 
        										  subObjectSelection : ObjectSelection, 
                                                  cursor : Cursor = null, 
                                                  allowMoves : Boolean = true )
        {
            super ( canvas, selection, allowMoves, cursor );
            _subObjectsSelection = subObjectSelection;
            _objectsSelection = selection;
        }
        
        
        override public function actionStarted ( e : ToolGestureData ) : void
        {
            if( !selection.isEmpty() && hasSubObjects() )
            {
                var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
                
                if( o && isSubObject( o ) )
                {
                	selection = _subObjectsSelection;
                    
                    _objectsSelectionFilter = selectionFilter;
                    selectionFilter = subObjectsSelectionFilter;
                    _operateOnSubObjects = true;
                }
            }
            super.actionStarted ( e );
        }

        override public function actionFinished ( e : ToolGestureData ) : void
        {
            if( _operateOnSubObjects )
            	var hasSubObjectsSelection : Boolean = selection.isEmpty();
            
            super.actionFinished ( e );
            if( _operateOnSubObjects )
            {
	            selection = _objectsSelection;
//                if( hasSubObjectsSelection )
//                	selection.removeAll();
//               
	            selectionFilter = _objectsSelectionFilter;
                _operateOnSubObjects = false;
            }
            else if( !_subObjectsSelection.isEmpty() )
            	_subObjectsSelection.removeAll();
        }

        private function hasSubObjects () : Boolean
        {
            for each( var o : Object in selection.objects )
                if( o is CanvasElement && (o as CanvasElement).hasSubObjects )
                	return true;
            return false;
        }
        private function isSubObject( o : DisplayObject ):Boolean
        {
            for each( var d : Object in selection.objects )
                if( d is CanvasElement && (d as CanvasElement).isSubObject(o) )
                	return true;
            return false;
        }

        public function get subObjectsSelection () : ObjectSelection {
            return _subObjectsSelection;
        }
    }
}
