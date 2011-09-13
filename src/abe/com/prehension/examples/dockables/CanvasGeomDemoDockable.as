package abe.com.prehension.examples.dockables
{
    import abe.com.edia.camera.CameraLayer;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Keys;
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.ActionManagerInstance;
    import abe.com.ponents.buttons.ButtonGroup;
    import abe.com.ponents.buttons.ToolButton;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.ToolBar;
    import abe.com.ponents.factory.ComponentFactory;
    import abe.com.ponents.factory.contextArgs;
    import abe.com.ponents.layouts.components.BorderLayout;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelectionInstance;
    import abe.com.ponents.tools.canvas.ToolManager;
    import abe.com.ponents.tools.canvas.actions.DeleteSelection;
    import abe.com.ponents.tools.canvas.actions.SetToolAction;
    import abe.com.ponents.tools.canvas.geom.CreateRectangleTool;
    import abe.com.ponents.tools.canvas.navigations.Pan;
    import abe.com.ponents.tools.canvas.navigations.ZoomDrag;
    import abe.com.ponents.tools.canvas.navigations.ZoomIn;
    import abe.com.ponents.tools.canvas.navigations.ZoomOut;
    import abe.com.ponents.tools.canvas.selections.SelectAndMove;
    import abe.com.ponents.tools.canvas.selections.SelectAndPan;

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.ui.MouseCursor;
	
	public class CanvasGeomDemoDockable extends DemoDockable
	{
		protected var _canvas : CameraCanvas;
		
		public function CanvasGeomDemoDockable(id:String, label : * =null, icon:Icon=null)
		{
			super(id, null, label, icon);
		}
		override public function build(factory:ComponentFactory):void
		{
			factory.group("movables")
				.build( CameraCanvas, 
					"cameraCanvasGeomDemo_Canvas",
					null,
					{
						'allowMask':true
					})
				.build( ToolManager, 
					"cameraCanvasGeomDemo_ToolManager",
					contextArgs( "cameraCanvasGeomDemo_Canvas" ) )
				
				.group("containers")
				.build( ButtonGroup, 
					"cameraCanvasGeomDemo_ToolButtonGroup" )
				.build( ToolBar, 
					"cameraCanvasGeomDemo_ToolBar" )
				.build( Panel, 
					"cameraCanvasGeomDemo_Panel", 
					null,
					{ 'childrenLayout': new BorderLayout() },
					onBuildComplete );
			
		}
		protected function onBuildComplete ( p : Panel, ctx : Object ) : void 
		{
			var l : BorderLayout = p.childrenLayout as BorderLayout;
			var canvas : CameraCanvas = ctx["cameraCanvasGeomDemo_Canvas"];
			var toolbar : ToolBar = ctx["cameraCanvasGeomDemo_ToolBar"];
			
			l.north = toolbar;
			p.addComponent( toolbar );
			
			l.center = canvas;
			p.addComponent( canvas );
			
			canvas.createLayer();
			
			_canvas = canvas;
			_content = p;
			
			setupTools( canvas, toolbar, ctx["cameraCanvasGeomDemo_ToolManager"], ctx["cameraCanvasGeomDemo_ToolButtonGroup"] );
			
			ObjectSelectionInstance.addEventListener( "selectionChange", selectionChanged );
		}
		protected function setupTools ( canvas : CameraCanvas, 
										toolbar : ToolBar, 
										manager : ToolManager, 
										toolGroup : ButtonGroup ):void
		{
			canvas.addEventListener( MouseEvent.MOUSE_WHEEL, function ( e : MouseEvent) : void
			{
				if( e.delta > 0 )
					canvas.camera.zoomInAroundPoint( new Point( canvas.topLayer.mouseX, canvas.topLayer.mouseY ) );
				else
					canvas.camera.zoomOutAroundPoint( new Point( canvas.topLayer.mouseX, canvas.topLayer.mouseY ) );
			} );
			
			var sam : SelectAndMove = new SelectAndMove( canvas, ObjectSelectionInstance, Cursor.get( MouseCursor.ARROW ) )
			var sop : SelectAndPan = new SelectAndPan( canvas, ObjectSelectionInstance, Cursor.get( MouseCursor.ARROW ), Cursor.get( MouseCursor.HAND ) );
			var pan : Pan = new Pan( canvas.camera, Cursor.get( MouseCursor.HAND ) );
			var zi : ZoomIn = new ZoomIn( canvas.camera );
			var zo : ZoomOut = new ZoomOut( canvas.camera );
			var zd : ZoomDrag = new ZoomDrag( canvas.camera );
			
			var cr : CreateRectangleTool = new CreateRectangleTool( canvas );

			ActionManagerInstance.registerAction( 
				new SetToolAction(   manager ,
					sam,
					_("Select And Move"),
					magicIconBuild( "../res/icons/tools/select.png" ),
					null,
					KeyStroke.getKeyStroke( Keys.V, KeyStroke.getModifiers(false, true) ) ),
				"select" );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   manager,
					sop,
					_("Select And Pan"),
					magicIconBuild( "../res/icons/tools/select-pan.png" ),
					null,
					KeyStroke.getKeyStroke( Keys.X, KeyStroke.getModifiers(false, true) ) ),
				"pan_select" );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   manager ,
					pan,
					_("Pan"),
					magicIconBuild( "../res/icons/tools/pan.png" ),
					null,
					KeyStroke.getKeyStroke( Keys.M, KeyStroke.getModifiers(false, true) ) ),
				"pan" );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   manager ,
					zd,
					_("Zoom"),
					magicIconBuild( "../res/icons/tools/zoom.png" ),
					null,
					KeyStroke.getKeyStroke( Keys.Z, KeyStroke.getModifiers(false, true) ) ),
				"zoom" );
			
			ActionManagerInstance.registerAction( 
				new SetToolAction(   manager ,
					cr,
					_("Create Rectangle"),
					magicIconBuild( "../res/icons/geom/rect.png" ),
					null,
					KeyStroke.getKeyStroke( Keys.R, KeyStroke.getModifiers(false, true) ) ),
				"create_rectangle" );
			
			ActionManagerInstance.registerAction( new DeleteSelection( canvas, 
																		ObjectSelectionInstance, 
																		_("Delete Selection"), 
																		null, 
																		null,  
																		KeyStroke.getKeyStroke( Keys.DELETE, KeyStroke.getModifiers(false,true) ) ),
												  "delete_selection" );
			
			sam.addAlternateTool(KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
			
			sop.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			sop.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
			
			zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
			
			var bt : ToolButton = new ToolButton( ActionManagerInstance.getAction( "pan_select" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
			
			bt = new ToolButton( ActionManagerInstance.getAction( "select" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
			
			bt = new ToolButton( ActionManagerInstance.getAction( "zoom" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
			
			bt = new ToolButton( ActionManagerInstance.getAction( "pan" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
			
			toolbar.addSeparator();
			
			bt = new ToolButton( ActionManagerInstance.getAction( "create_rectangle" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
		}
		
		protected function selectionChanged(event:Event):void
		{
			var a : Array = ObjectSelectionInstance.objects;
			
			var l : CameraLayer = _canvas.getLayerAt(0);
			var cl : uint = l.numChildren;
			var o : DisplayObject;
			while( cl-- )
			{
				o = l.getChildAt(cl);
				if( a.indexOf( o ) != -1 )
				{
					
					o.filters = [new GlowFilter(SelectAndMove.SELECTION_COLOR.hexa,1,2,2,5,2)];
					o.parent.setChildIndex(o, o.parent.numChildren-1 );
				}
				else
					o.filters = [];
			}
		}
	}
}