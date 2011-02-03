package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.buttons.ButtonGroup;
	import aesia.com.ponents.buttons.ToggleButton;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.tools.CameraCanvas;
	import aesia.com.ponents.tools.ObjectSelectionInstance;
	import aesia.com.ponents.tools.canvas.navigations.Pan;
	import aesia.com.ponents.tools.canvas.selections.SelectAdd;
	import aesia.com.ponents.tools.canvas.selections.SelectAndMove;
	import aesia.com.ponents.tools.canvas.selections.SelectRemove;
	import aesia.com.ponents.tools.canvas.actions.SetToolAction;
	import aesia.com.ponents.tools.canvas.ToolManager;
	import aesia.com.ponents.tools.canvas.navigations.ZoomIn;
	import aesia.com.ponents.tools.canvas.navigations.ZoomOut;
	import aesia.com.ponents.utils.Directions;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.MouseCursor;

	/**
	 * @author Cédric Néhémie
	 */
	[SWF(width="600", height="600", backgroundColor="#D3D3D3")]
	public class ToolsetsDemo extends Sprite 
	{
		private var canvas : CameraCanvas;
		private var manager : ToolManager;
		private var bg : ButtonGroup;
		private var toolbar : ToolBar;
		
		[Embed(source="cursor.png")]
		private var cursor : Class;
		
		[Embed(source="drag.png")]
		private var drag : Class;
		
		public function ToolsetsDemo ()
		{
			StageUtils.setup( this );
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			Cursor.init( ToolKit.cursorLevel );
			
			KeyboardControllerInstance.eventProvider = stage;
			
			canvas = new CameraCanvas( );
			canvas.createLayer();
			canvas.addEventListener( MouseEvent.MOUSE_WHEEL, function ( e : MouseEvent) : void
			{
				if( e.delta > 0 )
					canvas.camera.zoomInAroundPoint( new Point( canvas.topLayer.mouseX, canvas.topLayer.mouseY ) );
				else
					canvas.camera.zoomOutAroundPoint( new Point( canvas.topLayer.mouseX, canvas.topLayer.mouseY ) );
			} );
			
			var panel : Panel = new Panel();
			var l : BorderLayout = new BorderLayout();
			
			toolbar = new ToolBar();
			toolbar.direction = Directions.TOP_TO_BOTTOM;
			toolbar.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			bg = new ButtonGroup();
			
			l.center = canvas;
			l.west = toolbar;
			
			panel.childrenLayout = l;
			panel.addComponent( canvas );
			panel.addComponent( toolbar );
			
			var lv : LogView = new LogView();
			lv.x = 30;
			lv.size = new Dimension(300,100);
			
			StageUtils.lockToStage( panel );
			ToolKit.mainLevel.addChild( panel );			ToolKit.mainLevel.addChild( lv );
			
			manager = new ToolManager( canvas );
			manager.addEventListener(ToolEvent.TOOL_SELECT, toolSelected );	
					
			var pan : Pan = new Pan( canvas.camera, Cursor.get( MouseCursor.HAND ) );
			var zi : ZoomIn = new ZoomIn( canvas.camera );
			var zo : ZoomOut = new ZoomOut( canvas.camera );
			var sam : SelectAndMove = new SelectAndMove( ObjectSelectionInstance, Cursor.get( MouseCursor.ARROW ) );						var sa : SelectAdd 		= new SelectAdd( ObjectSelectionInstance );
			var sr : SelectRemove 	= new SelectRemove( ObjectSelectionInstance );
			//var ln : LinkObjects = new LinkObjects( NodeLink, linkNode, c4 );
			
			sam.addAlternateTool( KeyStroke.getKeyStroke( Keys.SPACE ), pan );
			sam.addAlternateTool( KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), sa );
			sam.addAlternateTool( KeyStroke.getKeyStroke( Keys.SHIFT, KeyStroke.SHIFT_MASK ), sr );
			
			//ln.addAlternateTool( KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), sam );
			
			var staSAM : SetToolAction = new SetToolAction( manager , sam, "Select & Move", magicIconBuild(cursor), null, KeyStroke.getKeyStroke( Keys.V ) );			var staPan : SetToolAction = new SetToolAction( manager , pan, "Pan", magicIconBuild(drag), null, KeyStroke.getKeyStroke( Keys.M ) );
			
			pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.CONTROL, KeyStroke.CTRL_MASK ), zi );
			pan.addAlternateTool(KeyStroke.getKeyStroke( Keys.SHIFT, KeyStroke.SHIFT_MASK ), zo );
					
			toolbar.addComponent( new ToggleButton( staPan ) );			toolbar.addComponent( new ToggleButton( staSAM ) );			
			for each( var bt : ToggleButton in toolbar.children)
				bg.add(bt);

			manager.tool = sam;
			
			var bbt : Button = new Button();
			//bbt.enabled = false;
			canvas.addComponentToLayer( bbt, 0 );
			
			var renderer : CanvasSelectionRenderer = new CanvasSelectionRenderer( ObjectSelectionInstance, canvas.createLayer() );
			manager.addEventListener( ToolEvent.TOOL_USE, renderer.repaintSelection );
			
			canvas.camera.centerDisplayObject(bbt);
		}
		
		protected function toolSelected (event : ToolEvent) : void
		{
			for each ( var bt : ToggleButton in toolbar.children )
				if( ( bt.action as SetToolAction).tool == event.manager.tool )
					bt.selected = true;
		}
	}
}

import aesia.com.ponents.events.ComponentEvent;
import aesia.com.ponents.tools.ObjectSelection;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;

internal class CanvasSelectionRenderer 
{
	protected var _layer : Sprite;
	protected var _selection : ObjectSelection;
	
	public function CanvasSelectionRenderer( selection : ObjectSelection, layer : Sprite ) 
	{
		_layer = layer;
		_selection = selection;
		
		_selection.addEventListener( ComponentEvent.SELECTION_CHANGE, repaintSelection );
	}
	
	public function repaintSelection(... args ) : void
	{
		_layer.graphics.clear();
		var r : Rectangle;
		for each ( var o : DisplayObject in _selection.objects )
		{
			if(!r)
				r = o.getBounds( o.parent );
			else
				r = r.union(o.getBounds( o.parent ));
		}
		
		if( r )
		{
			_layer.graphics.lineStyle(0, 0xff0000);
			_layer.graphics.drawRect( r.x, r.y, r.width, r.height );	
		}	
	}
}