package abe.com.ponents.tools.canvas.geom
{
    import abe.com.mon.geom.FreeFormSpline;
    import abe.com.mon.geom.FreeFormSplineVertex;
    import abe.com.mon.utils.arrays.firstIn;
    import abe.com.mon.utils.arrays.lastIn;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelection;
    import abe.com.ponents.tools.canvas.ToolGestureData;
    import abe.com.ponents.tools.canvas.core.AbstractCanvasTool;
    import abe.com.ponents.tools.canvas.dummies.CurveDummy;
    import abe.com.ponents.tools.canvas.dummies.CurveHandleDummy;
    import abe.com.ponents.tools.canvas.dummies.CurvePointDummy;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.geom.Point;


    /**
     * @author cedric
     */
    public class AbstractCurveTool extends AbstractCanvasTool
    {
        protected var _allowHandleCreation : Boolean;
        
        protected var _hasCreatedCurve : Boolean;
        protected var _hasCreatedCurvePoint : Boolean;
        protected var _hasCreatedHandle : Boolean;
        
        protected var _curve : FreeFormSpline;
        protected var _curveDummy : CurveDummy;
        protected var _startPoint : Point;
        protected var _selection : ObjectSelection;
        
        protected var _insertAtHead : Boolean;
        protected var _layer : int;
        
        public var curveCreated : Signal;
        
        public function AbstractCurveTool ( canvas : CameraCanvas, 
        									selection : ObjectSelection,
                                            layer : int = 0, 
                                            cursor : Cursor = null )
        {
            super ( canvas, cursor );
            _allowHandleCreation = true;
            _selection = selection;
            _layer = layer;
            curveCreated = new Signal();
        }

        override public function toolSelected ( e : ToolGestureData ) : void
        {
            super.toolSelected ( e );
            _hasCreatedCurve = false;            
        }

        override public function toolUnselected ( e : ToolGestureData ) : void
        {
            super.toolUnselected ( e );
        }

        override public function actionStarted ( e : ToolGestureData ) : void
        {
            _startPoint = e.canvasMousePosition;
            var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
            
            super.actionStarted ( e );
            
            if( o is CurvePointDummy )
            {
            	var c : CurvePointDummy = o as CurvePointDummy;
                var curve : CurveDummy = c.curve;
                var index : int = curve.curve.vertices.indexOf( c.point );
                if( index == 0 )
                {
                    _insertAtHead = true;
	                _hasCreatedCurve = true;
	                _hasCreatedCurvePoint = true;
	                _curve = curve.curve;
                    _curveDummy = curve;
                }
                else if( index == curve.dummies.length-1 )
                {
                    _hasCreatedCurve = true;
                    _insertAtHead = false;
                    _hasCreatedCurvePoint = true;
	                _curve = curve.curve;
                    _curveDummy = curve;
                }
                else
                {
                    if( e.ctrlPressed )
                    	c.remove();
                }
            }
            else
            {
	            if( !_hasCreatedCurve || _curveDummy.dummies == null || e.ctrlPressed )
               
	            {
	                createCurve();
	                _hasCreatedCurve = true;
	            }
	            createCurvePoint(e);
	            _hasCreatedCurvePoint = true;
            }
            
        }

        override public function actionFinished ( e : ToolGestureData ) : void
        {
            super.actionFinished ( e );
            if( _allowHandleCreation )
            {
	            _hasCreatedHandle = false;
                _hasCreatedCurvePoint = false;
                _curveDummy.updateCurve();
            }
        }
        override public function mousePositionChanged ( e : ToolGestureData ) : void
        {
            super.mousePositionChanged ( e );
            if( _allowHandleCreation && _hasCreatedCurvePoint && Point.distance( _startPoint, e.canvasMousePosition ) > 5 )
            {
                if( _hasCreatedHandle )
               		updateCurveHandle(e);
                else
                	createCurveHandle(e);
            }
        }

        protected function createCurve () : void
        {
            _curve = new FreeFormSpline([]);
            _curveDummy = new CurveDummy( _curve );
            _canvas.addLayerObject( _curveDummy, _layer );
            _selection.set([ _curveDummy ]);
            curveCreated.dispatch( this, _curve, _curveDummy );
        }

        protected function createCurvePoint(e : ToolGestureData):void
        {
            var pt : FreeFormSplineVertex = new FreeFormSplineVertex(e.canvasMousePosition.x, e.canvasMousePosition.y, 0);
            if( _insertAtHead )
            	_curve.vertices.splice(0,0,pt);
            else
            	_curve.vertices.push(pt);
            
            var dummy : CurvePointDummy = new CurvePointDummy( pt );
            _canvas.addBillboardLayerObject( dummy, _layer );
            
            var dummy1 : CurveHandleDummy = new CurveHandleDummy( pt.postHandle, pt );
            dummy1.visible = false;
            _canvas.addBillboardLayerObject( dummy1, _layer );
            
            var dummy2 : CurveHandleDummy = new CurveHandleDummy( pt.preHandle, pt );
            dummy2.visible = false;
            _canvas.addBillboardLayerObject( dummy2, _layer );
            
            dummy.preHandle = dummy2;
            dummy.postHandle = dummy1;
            
            dummy1.altHandle = dummy2;
            dummy2.altHandle = dummy1;
            
            _curveDummy.addDummy( dummy );
            updateCurve();
        }
        protected function createCurveHandle(e : ToolGestureData):void
        {
            var pt : FreeFormSplineVertex = _insertAtHead ? firstIn( _curve.vertices ) : lastIn( _curve.vertices );
            
            pt.type = 1;
            if( _insertAtHead )
            {
                pt.preHandle.x = e.canvasMousePosition.x;
	            pt.preHandle.y = e.canvasMousePosition.y;
            }
            else
            {
	            pt.postHandle.x = e.canvasMousePosition.x;
	            pt.postHandle.y = e.canvasMousePosition.y;
            }
            
            updateCurve();
            _hasCreatedHandle = true;
        }
        protected function updateCurveHandle ( e : ToolGestureData ) : void
        {
            var pt : FreeFormSplineVertex = _insertAtHead ? firstIn( _curve.vertices ) : lastIn( _curve.vertices );
            var cd : CurvePointDummy;
            var d1 : CurveHandleDummy;
            var d2 : CurveHandleDummy;
            if( _insertAtHead )
            {
            	cd = _curveDummy.getDummyForPoint(pt);
                d2 = cd.postHandle;
	            d1 = cd.preHandle;
            }
            else
            {
            	cd = _curveDummy.getDummyForPoint(pt);
	            d1 = cd.postHandle;
	            d2 = cd.preHandle;
            }
            
            d1.x = e.canvasMousePosition.x;
            d1.y = e.canvasMousePosition.y;
            
            d2.x = d1.ptTarget.x + ( d1.ptTarget.x - e.canvasMousePosition.x);
            d2.y = d1.ptTarget.y + ( d1.ptTarget.y - e.canvasMousePosition.y);
            updateCurve();
        }
        
        protected function updateCurve():void 
        {
            _curve.updateSplineData();
            _curveDummy.draw();
        }
    }
}
