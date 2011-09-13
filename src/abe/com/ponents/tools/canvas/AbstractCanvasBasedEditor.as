package abe.com.ponents.tools.canvas
{
    import abe.com.edia.camera.Camera;
    import abe.com.edia.camera.CameraLayer;
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.Range;
    import abe.com.mon.geom.dm;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.layouts.components.BorderLayout;
    import abe.com.ponents.layouts.components.Box9Layout;
    import abe.com.ponents.models.DefaultBoundedRangeModel;
    import abe.com.ponents.scrollbars.ScrollBar;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.CanvasRuler;
    import abe.com.ponents.tools.ObjectSelection;
    import abe.com.ponents.tools.canvas.dummies.SceneDummy;
    import abe.com.ponents.utils.Orientations;

    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    [Skinable(skin="DefaultComponent")]
    public class AbstractCanvasBasedEditor extends Panel
    {
        protected var _canvas : CameraCanvas;
        protected var _toolbar : DefaultCanvasToolBar;
        
        protected var _objectSelection : ObjectSelection;
        protected var _subObjectSelection : ObjectSelection;
        
        protected var _rightCanvasScrollbar : ScrollBar;
        protected var _bottomCanvasScrollbar : ScrollBar;
        
        protected var _sceneDummy : SceneDummy;
        protected var _canvasPane : Panel;
        
        protected var _panDoneProgramatically : Boolean;
        protected var _scrollDoneProgramatically : Boolean;
        
        protected var _sceneColor : Color;
        protected var _canvasColor : Color;
        
        private var _leftMin : Number;
        private var _topMin : Number;

        public function AbstractCanvasBasedEditor ( sceneSize : Dimension = null, color : Color = null, canvasColor : Color = null )
        {
            _objectSelection = new ObjectSelection();
            _subObjectSelection = new ObjectSelection();
            _canvas = new CameraCanvas();
            _canvas.allowMask = true;
            _canvas.camera.zoomRange = new Range(0.1,5);
            _canvas.camera.cameraChanged.add( cameraChanged );
            _canvas.createLayer();

            _toolbar = new DefaultCanvasToolBar(_canvas, _objectSelection, _subObjectSelection );

            var bl : BorderLayout = new BorderLayout( this );
            childrenLayout = bl;
            
            _canvasPane = new Panel();            
            var l : Box9Layout = new Box9Layout(_canvasPane);
            _canvasPane.childrenLayout = l;
            _canvasPane.styleKey = "DefaultComponent";
            
            _rightCanvasScrollbar =new ScrollBar(Orientations.VERTICAL, 0, 1, 0, 100);
            _bottomCanvasScrollbar =new ScrollBar(Orientations.HORIZONTAL, 0, 1, 0, 100);
            
            _rightCanvasScrollbar.model.dataChanged.add(rightScrollDataChanged);
            _bottomCanvasScrollbar.model.dataChanged.add(bottomScrollDataChanged);
            
            var topRuler : CanvasRuler = new CanvasRuler(_canvas, Orientations.HORIZONTAL );
            var leftRuler : CanvasRuler = new CanvasRuler(_canvas, Orientations.VERTICAL );
            
            l.center = _canvas;
            l.right = _rightCanvasScrollbar;
            l.lower = _bottomCanvasScrollbar;
            l.left = leftRuler;
            l.upper = topRuler;
            
            _canvasPane.addComponents( _canvas, _rightCanvasScrollbar, _bottomCanvasScrollbar, leftRuler, topRuler );
            
            bl.north = _toolbar;
            bl.center = _canvasPane;
            
            addComponents(_canvasPane, _toolbar);
            
            setupScene(color, sceneSize, canvasColor);
        }

        public function get canvas () : CameraCanvas { return _canvas; }
        public function get toolbar () : DefaultCanvasToolBar { return _toolbar; }
        public function get objectSelection () : ObjectSelection { return _objectSelection; }
        public function get subObjectSelection () : ObjectSelection { return _subObjectSelection; }
        public function get canvasPane () : Panel { return _canvasPane; }
        public function get sceneDummy () : SceneDummy {return _sceneDummy;}

		public function clearScene():void
        {
            var l : int = _canvas.layers.length;
            clearLayer(0);
            while(--l)
            {
                clearLayer(l);
                _canvas.removeComponentChildAt(l);
            }
        }
        public function clearLayer(l:int):void
        {
            var layer : CameraLayer = _canvas.getLayerAt( l );
            var n : int = layer.numChildren;
            while(--n-(-1))
                layer.removeChildAt(n);
        }
        public function get sceneSize() : Dimension {
            return _sceneDummy ? _sceneDummy.sceneSize : null;
        }
        public function set sceneSize( d : Dimension ) : void 
        {
            if( d )
            {
	            if( !_sceneDummy )
	            {
	                _canvas.style.background = _canvasColor ;
	                _sceneDummy = new SceneDummy( d, Color.White );
		            _canvas.addLayerObject( _sceneDummy, 0 );
	            }
	            _sceneDummy.sceneSize = d;
            }
            else
            {
                if( _sceneDummy )
                {
                	_canvas.topLayer.removeChild( _sceneDummy );
                    _sceneDummy = null;
                }
                _canvas.style.background = _sceneColor ;
            }
        }
        public function setupScene( color : Color = null, size : Dimension = null, canvasColor : Color = null ):void
        {
            clearScene();
            _canvasColor = canvasColor ? canvasColor : Color.Silver;
            _sceneColor = color ? color : Color.White;
            if( size )
            {
	            _canvas.style.background = _canvasColor ;
	            _sceneDummy = new SceneDummy( size ? size : dm(200,150), _sceneColor );
	            _canvas.addLayerObject( _sceneDummy, 0 );
	            _canvas.camera.centerDisplayObject( _sceneDummy );
            }
            else
            {
                _canvas.style.background = color ? color : Color.White;
                _canvas.camera.centerXY(0, 0);
            }
        }

		private function bottomScrollDataChanged ( m : DefaultBoundedRangeModel, v : Number ) : void
        {
            if( _scrollDoneProgramatically )
            	return;
            
            _panDoneProgramatically = true;
            _canvas.camera.x = _leftMin + v/_canvas.camera.zoom;
            _panDoneProgramatically = false;
        }
        private function rightScrollDataChanged ( m : DefaultBoundedRangeModel, v : Number ) : void
        {
            if( _scrollDoneProgramatically )
            	return;
            
            _panDoneProgramatically = true;
            _canvas.camera.y = _topMin + v/_canvas.camera.zoom;
            _panDoneProgramatically = false;
        }
        private function cameraChanged ( c : Camera ) : void
        {
            if( _panDoneProgramatically )
            	return;
            
            if( _sceneDummy == null )
            {
                _rightCanvasScrollbar.enabled = false;
                _bottomCanvasScrollbar.enabled = false;
                return;
            }
            
            _scrollDoneProgramatically = true;
            var bb : Rectangle = _sceneDummy.getBounds( StageUtils.root );
            var a : Rectangle = _canvas.screenVisibleArea;
            
            if( a.containsRect( bb ) )
            {
                _rightCanvasScrollbar.enabled = false;
                _bottomCanvasScrollbar.enabled = false;
            }
            else
            {
                var visibleWidth : Number;
                var visibleHeight : Number;
                
                var inter : Rectangle = a.intersection(bb);
                
                visibleWidth = inter.width;
                visibleHeight = inter.height;
                
                if( visibleWidth < bb.width )
                {
                    _bottomCanvasScrollbar.enabled = true;
                    _bottomCanvasScrollbar.model.maximum = bb.width-visibleWidth;
                    _bottomCanvasScrollbar.model.minimum = 0;
                    _bottomCanvasScrollbar.model.extent = visibleWidth;
                    _bottomCanvasScrollbar.model.value = inter.x - bb.x;
                    _leftMin = _canvas.camera.x - ( inter.x - bb.x )/_canvas.camera.zoom ;
                }
                else
                    _bottomCanvasScrollbar.enabled = false;
                
                if( visibleHeight < bb.height )
                {
                    _rightCanvasScrollbar.enabled = true;
                    _rightCanvasScrollbar.model.maximum = bb.height-visibleHeight;
                    _rightCanvasScrollbar.model.minimum = 0;
                    _rightCanvasScrollbar.model.extent = visibleHeight;
                    _rightCanvasScrollbar.model.value = inter.y - bb.y;
                    _topMin = _canvas.camera.y - (inter.y - bb.y)/_canvas.camera.zoom;
                }
                else
                    _rightCanvasScrollbar.enabled = false;
                
            }
            _scrollDoneProgramatically = false;
        }
    }
}
