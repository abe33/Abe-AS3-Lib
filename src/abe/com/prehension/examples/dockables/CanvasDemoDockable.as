package abe.com.prehension.examples.dockables 
{
    import abe.com.edia.camera.CameraLayer;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.utils.*;
    import abe.com.mon.utils.objects.keys;
    import abe.com.patibility.lang.*;
    import abe.com.ponents.actions.*;
    import abe.com.ponents.buttons.*;
    import abe.com.ponents.containers.*;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.Container;
    import abe.com.ponents.factory.*;
    import abe.com.ponents.layouts.components.*;
    import abe.com.ponents.nodes.actions.*;
    import abe.com.ponents.nodes.core.*;
    import abe.com.ponents.nodes.tools.CreateNoteTool;
    import abe.com.ponents.nodes.tools.LinkNodesTool;
    import abe.com.ponents.nodes.tools.UnlinkNodesTool;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.skinning.icons.*;
    import abe.com.ponents.tools.*;
    import abe.com.ponents.tools.canvas.*;
    import abe.com.ponents.tools.canvas.actions.*;
    import abe.com.ponents.tools.canvas.navigations.*;
    import abe.com.ponents.tools.canvas.selections.*;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.ui.MouseCursor;
    
    /**
     * @author cedric
     */
    public class CanvasDemoDockable extends DemoDockable 
    {

    	protected var _allConnections: Array ;
		protected var _canvas:CameraCanvas;
		
        public function CanvasDemoDockable ( id : String, label : String = null, icon : Icon = null)
        {
            super( id, null, label, icon );
			_allConnections = [];
        }
        override public function build (factory : ComponentFactory) : void
        {
            ActionManagerInstance.registerAction( new AddNodeAction( null,0,null,
                                                        _("Add Node"), 
                                                        magicIconBuild( "../res/icons/tools/add.png" ) ), 
                                                  "canvasAddNode" );
			
			ActionManagerInstance.registerAction( new DeleteCurrentSelectionAction( ObjectSelectionInstance, null, 0, 
														_("Delete Selection"), 
														magicIconBuild( "../res/icons/tools/minus.png" ), 
														null, 
														KeyStroke.getKeyStroke( Keys.DELETE )), 
												  "canvasDeleteSelection" );
        
            factory.group("movables")
                   .build( Button, 
                           "cameraCanvasDemo_AddNodeButton",
                           [ ActionManagerInstance.getAction( "canvasAddNode" ) ] )
				   .build( Button, 
						   "cameraCanvasDemo_DeleteSelectionButton",
						   [ ActionManagerInstance.getAction( "canvasDeleteSelection" ) ] )
                   .build( CameraCanvas, 
                           "cameraCanvasDemo_Canvas",
                           null,
                           {
                              'allowMask':true
                           })
                   .build( ToolManager, 
                           "cameraCanvasDemo_ToolManager",
                           contextArgs( "cameraCanvasDemo_Canvas" ) )
                   
                   .group("containers")
                   .build( ButtonGroup, 
                           "cameraCanvasDemo_ToolButtonGroup" )
                   .build( ToolBar, 
                           "cameraCanvasDemo_ToolBar" )
                   .build( Panel, 
                           "cameraCanvasDemo_Panel", 
                           null,
                           { 'childrenLayout': new BorderLayout() },
                           onBuildComplete );
        }
        protected function onBuildComplete ( p : Panel, ctx : Object ) : void 
        {
            var l : BorderLayout = p.childrenLayout as BorderLayout;
            var canvas : CameraCanvas = ctx["cameraCanvasDemo_Canvas"];
            var toolbar : ToolBar = ctx["cameraCanvasDemo_ToolBar"];
            
            toolbar.addComponent( ctx["cameraCanvasDemo_AddNodeButton"] );
			toolbar.addComponent( ctx["cameraCanvasDemo_DeleteSelectionButton"] );
			toolbar.addSeparator();
			
            l.north = toolbar;
            p.addComponent( toolbar );
            
            l.center = canvas;
            p.addComponent( canvas );
            
            var addNode : AddNodeAction = ActionManagerInstance.getAction( "canvasAddNode" ) as AddNodeAction;
            addNode.canvas = canvas;
            addNode.userObjectProvider = function() : Object{ return { 'name':"Node", 'toString':function():String{ return this.name; } }; }
        
			var deleteSelection : DeleteCurrentSelectionAction = ActionManagerInstance.getAction( "canvasDeleteSelection" ) as DeleteCurrentSelectionAction;
			deleteSelection.canvas = canvas;
				
            canvas.createLayer();
            canvas.addContextMenuItemForGroup( addNode.contextMenuItem, "canvasAddNode", "canvas" );
			
			_canvas = canvas;
            _content = p;
            
            setupTools( canvas, toolbar, ctx["cameraCanvasDemo_ToolManager"], ctx["cameraCanvasDemo_ToolButtonGroup"] );
			
			canvas.childAdded.add( canvasNodeAdded );
			canvas.childRemoved.add( canvasNodeRemoved );
			
			ObjectSelectionInstance.addEventListener( "selectionChange", selectionChanged );
			
			var note : CanvasNote = new CanvasNote(_("A simple canvas setup, create <b>nodes</b>, link them, change <b>links</b> and <b>nodes</b> properties, add create <b>notes</b>.\nAlternate tools are available through <i>ctrl</i>, <i>shift</i> and <i>space</i> keys.\nContextual menus are available both on nodes and on the canvas.\nUse double clicks to edit properties of the elements."));
        	note.preferredSize = new Dimension( 260, 200 );
			note.x = StageUtils.stage.stageWidth - 280;
			note.y = 100;
			canvas.addComponentToLayer( note, 0 );
			
		}
		
		protected function canvasNodeAdded( c : Container, o : Component ):void
		{
			if( o is CanvasNode )
			{
				var node : CanvasNode = o as CanvasNode;
				node.connectionAdded.add( connectionAdded );
				node.connectionRemoved.add( connectionRemoved );
			}
		}
		protected function canvasNodeRemoved( c : Container, o : Component ):void
		{
			if( o is CanvasNode )
			{
				var node : CanvasNode = o as CanvasNode;
				node.connectionAdded.remove( connectionAdded );
				node.connectionRemoved.remove( connectionRemoved );
			}
		}
		
		protected function connectionAdded( a : CanvasNode, b : CanvasNode, l : NodeLink ):void
		{
			if( _allConnections.indexOf( l ) == -1 )
			{
				_allConnections.push( l );
				_canvas.getLayerAt(0).addChild( l );
			}
		}
		
		protected function connectionRemoved( a : CanvasNode, b : CanvasNode, l : NodeLink ):void
		{
			if( _allConnections.indexOf( l ) != -1 )
			{
				_allConnections.splice(_allConnections.indexOf( l ), 1 );
				_canvas.getLayerAt(0).removeChild( l);
			}
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
			var ln : LinkNodesTool = new LinkNodesTool();
			var uln : UnlinkNodesTool = new UnlinkNodesTool();
			var cn : CreateNoteTool = new CreateNoteTool( canvas );

            ActionManagerInstance.registerAction( 
                    new SetToolAction(   manager ,
                                         sam,
                                         _("Select And Move"),
                                         magicIconBuild( "../res/icons/tools/select.png" ),
                                         null,
                                         KeyStroke.getKeyStroke( Keys.V ) ),
                    "select" );
            
            ActionManagerInstance.registerAction( 
                    new SetToolAction(   manager ,
                                         sop,
                                         _("Select And Pan"),
                                         magicIconBuild( "../res/icons/tools/select-pan.png" ),
                                         null,
                                         KeyStroke.getKeyStroke( Keys.X ) ),
                    "pan_select" );
            
            ActionManagerInstance.registerAction( 
                    new SetToolAction(   manager ,
                                         pan,
                                         _("Pan"),
                                         magicIconBuild( "../res/icons/tools/pan.png" ),
                                         null,
                                         KeyStroke.getKeyStroke( Keys.M ) ),
                    "pan" );
            
            ActionManagerInstance.registerAction( 
                    new SetToolAction(   manager ,
                                         zd,
                                         _("Zoom"),
                                         magicIconBuild( "../res/icons/tools/zoom.png" ),
                                         null,
                                         KeyStroke.getKeyStroke( Keys.Z ) ),
                    "zoom" );
			
			ActionManagerInstance.registerAction( 
					new SetToolAction(  manager ,
										ln,
										_("Link Nodes"),
										magicIconBuild( "../res/icons/tools/link.png" ),
										null,
										KeyStroke.getKeyStroke( Keys.L ) ),
					"link" );
			ActionManagerInstance.registerAction( 
					new SetToolAction(  manager ,
										uln,
										_("Unlink Nodes"),
										magicIconBuild( "../res/icons/tools/link_break.png" ),
										null,
										KeyStroke.getKeyStroke( Keys.U ) ),
					"unlink" );
			
			ActionManagerInstance.registerAction( 
					new SetToolAction(  manager ,
										cn,
										_("Create a Note"),
										magicIconBuild( "../res/icons/tools/note_add.png" ),
										null,
										KeyStroke.getKeyStroke( Keys.N ) ),
					"note_create" );
			
            sam.addAlternateTool(KeyStroke.getKeyStroke( Keys.SPACE ), pan );
            pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
            pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );

            sop.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
            sop.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );

            zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.SPACE ), pan );
            zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
            zd.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT,   KeyStroke.SHIFT_MASK ), zo );
            
			ln.addAlternateTool( KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), uln );
			
			ln.addAlternateTool( KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			ln.addAlternateTool( KeyStroke.getKeyStroke( Keys.SHIFT ), zd );
			
			cn.addAlternateTool( KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			cn.addAlternateTool( KeyStroke.getKeyStroke( Keys.CONTROL ), zd );
			
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
			
			bt = new ToolButton( ActionManagerInstance.getAction( "link" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
			
			bt = new ToolButton( ActionManagerInstance.getAction( "unlink" ) );
			toolGroup.add( bt );
			toolbar.addComponent( bt );
			
			toolbar.addSeparator();
			
			bt = new ToolButton( ActionManagerInstance.getAction( "note_create" ) );
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
