package abe.com.ponents.tools.canvas
{
    import abe.com.edia.camera.Camera;
    import abe.com.edia.camera.CameraLayer;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Keys;
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.ActionManagerInstance;
    import abe.com.ponents.actions.ProxyAction;
    import abe.com.ponents.buttons.ButtonDisplayModes;
    import abe.com.ponents.buttons.ToolButton;
    import abe.com.ponents.containers.ToolBar;
    import abe.com.ponents.containers.ToolBarSpacer;
    import abe.com.ponents.menus.ComboBox;
    import abe.com.ponents.models.DefaultBoundedRangeModel;
    import abe.com.ponents.models.LabelComboBoxModel;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.sliders.HLogarithmicSlider;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelection;
    import abe.com.ponents.tools.canvas.actions.DeleteSelection;
    import abe.com.ponents.tools.canvas.actions.SetToolAction;
    import abe.com.ponents.tools.canvas.dummies.SceneDummy;
    import abe.com.ponents.tools.canvas.navigations.Pan;
    import abe.com.ponents.tools.canvas.navigations.ZoomDrag;
    import abe.com.ponents.tools.canvas.navigations.ZoomIn;
    import abe.com.ponents.tools.canvas.navigations.ZoomOut;
    import abe.com.ponents.tools.canvas.selections.SelectAndMove;
    import abe.com.ponents.tools.canvas.selections.SelectAndPan;

    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.ui.MouseCursor;

    /**
     * @author cedric
     */
    public class DefaultCanvasToolBar extends ToolBar
    {
        [Embed(source="../../skinning/icons/tools/zoom-drag.png")]
        static public const zoomDragIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/zoom.png")]
        static public const zoomIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/select.png")]
        static public const selectIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/select-pan.png")]
        static public const selectPanIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/pan.png")]
        static public const panIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/move.png")]
        static public const moveIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/zoom-1.png")]
        static public const realSizeIcon : Class;
        
        [Embed(source="../../skinning/icons/tools/center.png")]
        static public const centerIcon : Class;
        
        static public const SELECT_PAN : String = "selectPan";
        static public const SELECT_MOVE : String = "selectMove";
        static public const ZOOM : String = "zoom";
        static public const PAN : String = "pan";
        
        protected var _canvas : CameraCanvas;
        protected var _selection : ObjectSelection;
        protected var _subObjectSelection : ObjectSelection;
        protected var _manager : ToolManager;
        protected var _zoomSlider : HLogarithmicSlider;
        protected var _selectPanButton : ToolButton;
        protected var _selectMoveButton : ToolButton;
        protected var _panButton : ToolButton;
        protected var _zoomButton : ToolButton;
        
        protected var _zoomValueSetProgramatically : Boolean;
        protected var _spacer : ToolBarSpacer;
        protected var _zoomCombo : ComboBox;
        
        public function DefaultCanvasToolBar ( canvas : CameraCanvas,
        									   selection : ObjectSelection,
        									   subObjectSelection : ObjectSelection = null,
        									   displayMode : uint = 0, 
        									   dragEnabled : Boolean = true, 
                                               spacing : Number = NaN, 
                                               forceStretch : Boolean = true )
        {
            super ( displayMode, dragEnabled, spacing, forceStretch );
            buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
            _canvas = canvas;
            _selection = selection;
            _subObjectSelection = subObjectSelection;
            _manager = new ToolManager(_canvas);
            
            registerTools();
			buildChildren();
        }
        public function get canvas () : CameraCanvas { return _canvas; }
        public function get manager () : ToolManager { return _manager; }
        public function get zoomSlider () : HLogarithmicSlider { return _zoomSlider; }
        public function get selectPanButton () : ToolButton { return _selectPanButton; }
        public function get selectMoveButton () : ToolButton { return _selectMoveButton; }
        public function get panButton () : ToolButton { return _panButton; }
        public function get zoomButton () : ToolButton { return _zoomButton; }
        public function get spacer () : ToolBarSpacer { return _spacer; }
        public function get zoomCombo () : ComboBox { return _zoomCombo; }
        
		protected function canvasMouseWheel ( e : MouseEvent) : void
		{
			if( e.delta > 0 )
				_canvas.camera.zoomInAroundPoint( new Point( _canvas.topLayer.mouseX, _canvas.topLayer.mouseY ) );
			else
				_canvas.camera.zoomOutAroundPoint( new Point( _canvas.topLayer.mouseX, _canvas.topLayer.mouseY ) );
		}
        protected function buildChildren () : void
        {
			_selectPanButton = new ToolButton( ActionManagerInstance.getAction( SELECT_PAN ) );
			addComponent( _selectPanButton );
			
			_selectMoveButton = new ToolButton( ActionManagerInstance.getAction( SELECT_MOVE ) );
			addComponent( _selectMoveButton );
			
			_panButton = new ToolButton( ActionManagerInstance.getAction( PAN ) );
			addComponent( _panButton );

			_zoomButton = new ToolButton( ActionManagerInstance.getAction( ZOOM ) );
			addComponent( _zoomButton );
            
            
			addComponent(_spacer = new ToolBarSpacer(this));
            
            addAction( new ProxyAction( function():void {
                for each( var layer : CameraLayer in _canvas.layers )
                {
                    var l : int = layer.numChildren;
                    for( var i : int = 0;i<l;i++)
                    {
                        var c : DisplayObject = layer.getChildAt(i);
                        if( c is SceneDummy )
                        {
                        	_canvas.camera.centerDisplayObject( c );
                            return;
                        }
                    }
                    _canvas.camera.centerXY(0, 0);
                }
            }, _("Center canvas"), magicIconBuild( centerIcon ) ) );
            
            addAction( new ProxyAction(function():void{
            	_zoomSlider.value = 1;
            }, _("Real Size"), magicIconBuild( realSizeIcon ) ) );
            
            var zm : LabelComboBoxModel = new LabelComboBoxModel( [
            	-1,
            	0.1,
                0.25,
                0.5,
                0.75,
                1,
                1.5,
                2,
                3,
                4
            ], [
            	"---",
            	"10%",
                "25%",
                "50%",
                "75%",
                "100%",
                "150%",
                "200%",
                "300%",
                "400%"
            ]);
            _zoomCombo = new ComboBox( zm );
            _zoomCombo.itemFormatingFunction = zm.getLabel;
            _zoomCombo.icon = magicIconBuild(zoomIcon);
            _zoomCombo.dataChanged.add( comboDataChanged );
            addComponent(_zoomCombo );
            
            _zoomSlider = new HLogarithmicSlider(
            	new DefaultBoundedRangeModel(1, 0.1, 5, 0.1),
                1,
                0.5,
                true,
                false
            );
            _zoomSlider.dataChanged.add( sliderDataChanged );
            addComponent( _zoomSlider );
            _zoomSlider.allowDrag = false;
            
            
        }

        protected function registerTools () : void
        {
            var sam : SelectAndMove = new SelectAndMove( _canvas, _selection, true, Cursor.get( MouseCursor.ARROW ) )
			var sop : SelectAndPan = new SelectAndPan( _canvas, _selection, Cursor.get( MouseCursor.ARROW ), Cursor.get( MouseCursor.HAND ) );
			var pan : Pan = new Pan( _canvas.camera, Cursor.get( MouseCursor.HAND ) );
			var zi : ZoomIn = new ZoomIn( _canvas.camera );
			var zo : ZoomOut = new ZoomOut( _canvas.camera );
			var zd : ZoomDrag = new ZoomDrag( _canvas.camera );
            
            ActionManagerInstance.registerAction( 
				new SetToolAction(   _manager ,
					sam,
					_("Select And Move"),
					magicIconBuild( selectIcon ),
					null,
					KeyStroke.getKeyStroke( Keys.V ) ),
				SELECT_MOVE );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   _manager,
					sop,
					_("Select And Pan"),
					magicIconBuild( selectPanIcon ),
					null,
					KeyStroke.getKeyStroke( Keys.X ) ),
				SELECT_PAN );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   _manager ,
					pan,
					_("Pan"),
					magicIconBuild( panIcon ),
					null,
					KeyStroke.getKeyStroke( Keys.M ) ),
				PAN );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   _manager ,
					zd,
					_("Zoom"),
					magicIconBuild( zoomDragIcon ),
					null,
					KeyStroke.getKeyStroke( Keys.Z ) ),
				ZOOM );
			
			ActionManagerInstance.registerAction( new DeleteSelection(  _canvas, 
																		_selection, 
																		_("Delete Selection"), 
																		null, 
																		null,  
																		KeyStroke.getKeyStroke( Keys.DELETE ),
                                                                        _subObjectSelection ),
												  "delete_selection" );
			
			sam.addAlternateTool(KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
			
			sop.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			sop.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
			
			zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
        }
        
        override protected function registerToOnStageEvents () : void
        {
            super.registerToOnStageEvents ();
            _canvas.addEventListener( MouseEvent.MOUSE_WHEEL, canvasMouseWheel );
            _canvas.camera.cameraChanged.add(cameraChanged);
        }
        override protected function unregisterFromOnStageEvents () : void
        {
            super.unregisterFromOnStageEvents ();
            _canvas.removeEventListener( MouseEvent.MOUSE_WHEEL, canvasMouseWheel );
            _canvas.camera.cameraChanged.remove(cameraChanged);
        }
        
        private function comboDataChanged ( combo : ComboBox, value : Number ):void
        {
            _zoomValueSetProgramatically = true;
            _canvas.camera.zoom = value;
            _zoomSlider.value = _canvas.camera.zoom;
            _zoomValueSetProgramatically = false;
        }
        
        private function sliderDataChanged ( slider : HLogarithmicSlider, value : Number ) : void
        {
            _zoomValueSetProgramatically = true;
            _canvas.camera.zoom = value;
            if( _zoomCombo.model.contains( _canvas.camera.zoom ) )
	        	_zoomCombo.value = _canvas.camera.zoom;
	        else
	        	_zoomCombo.value = -1; 
            _zoomValueSetProgramatically = false;
        }
        private function cameraChanged ( c : Camera ) : void
        {
            if( !_zoomValueSetProgramatically )
            {
                _zoomSlider.value = c.zoom;
	            if( _zoomCombo.model.contains( c.zoom ) )
                	_zoomCombo.value = c.zoom;
                else
                	_zoomCombo.value = -1;
            }
        }

        public function get selection () : ObjectSelection {
            return _selection;
        }

        public function getTool ( key : String ) : Tool
        {
            return ( ActionManagerInstance.getAction ( key ) as SetToolAction).tool;
        }
    }
}
