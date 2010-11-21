package aesia.com.ponents.demos 
{
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.trees.TreeHeader;
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.models.TreeModel;
	import aesia.com.ponents.models.TreeNode;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.trees.Tree;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	[SWF(backgroundColor="#cccccc")]
	public class TreeDemo extends Sprite 
	{
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		public function TreeDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var lv : LogView;			
			lv = new LogView();
			ToolKit.mainLevel.addChild(lv);
			StageUtils.lockToStage(lv,257);
			
			KeyboardControllerInstance.eventProvider = stage;
			KeyboardControllerInstance.addGlobalKeyStroke( KeyStroke.getKeyStroke( Keys.Z, KeyStroke.getModifiers( true ) ), 
											  new ProxyCommand( UndoManagerInstance.undo ) );
			KeyboardControllerInstance.addGlobalKeyStroke( KeyStroke.getKeyStroke( Keys.Y, KeyStroke.getModifiers( true ) ), 
											  new ProxyCommand( UndoManagerInstance.redo ) );
			
			try
			{
				var t : Tree = new Tree();
				var n1 : TreeNode = new TreeNode( "Node 1" );				var n2 : TreeNode = new TreeNode( "Node 2" );				var n3 : TreeNode = new TreeNode( "Node 3" );
				t.allowMultiSelection = true;
				var i:uint;
				
				for(i=0;i<3000;i++)
					n1.add( new TreeNode( "Leaf "+ i ) );
				
				for(i=0;i<3000;i++)
					n2.add( new TreeNode( "Leaf "+ i ) );
					
				for(i=0;i<3000;i++)
					n3.add( new TreeNode( "Leaf "+ i ) );
				
				(t.model as TreeModel).root.add( n1 );				(t.model as TreeModel).root.add( n2 );				(t.model as TreeModel).root.add( n3 );
				
				var scp : ScrollPane = new ScrollPane();
				scp.view = t;
				scp.colHead = new TreeHeader( t, ButtonDisplayModes.ICON_ONLY );
				scp.rowHead = new ListLineRuler( t );
				scp.preferredSize = new Dimension ( 150, 300 );
				scp.x = 10;
				scp.y = 10;
				
				ToolKit.mainLevel.addChild( scp ); 
				
				var t2 : Tree = new Tree();
				t2.x = 180;
				t2.y = 10;
				//t2.editEnabled = false;				//t2.dragEnabled = false;
				var t2n1 : TreeNode = new TreeNode( "Child 1" );				var t2n2 : TreeNode = new TreeNode( "Child 2" );				var t2n3 : TreeNode = new TreeNode( "Child 3" );				var t2n4 : TreeNode = new TreeNode( "Child 4" );				var t2n5 : TreeNode = new TreeNode( "Child 5" );
				(t2.model as TreeModel).root.add( t2n1 );
				t2n1.add( t2n2 );				t2n2.add( t2n3 );				t2n3.add( t2n4 );				t2n4.add( t2n5 );
				
				t2.preferredSize = new Dimension(200,200);
				
				ToolKit.mainLevel.addChild( t2 ); 	
	
				var t3 : Tree = new Tree();
				t3.x = 360;
				t3.y = 10;
				var t3n1 : TreeNode = new TreeNode( "Child 1" );
				var t3n2 : TreeNode = new TreeNode( "Child 2" );
				var t3n3 : TreeNode = new TreeNode( "Child 3" );
				var t3n4 : TreeNode = new TreeNode( "Child 4" );
				var t3n5 : TreeNode = new TreeNode( "Child 5" );
				(t3.model as TreeModel).root.add( t3n1 );
				t3n1.add( t3n2 );
				t3n2.add( t3n3 );
				t3n3.add( t3n4 );
				t3n4.add( t3n5 );
				t3.expandNode((t3.model as TreeModel).root);				t3.expandNode(t3n1);				t3.expandNode(t3n2);				t3.expandNode(t3n3);				t3.expandNode(t3n4);
				t3.enabled = false;
				
				ToolKit.mainLevel.addChild( t3 ); 		
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
					
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
		}
		public function scroll ( e : ComponentEvent ) : void
		{
			Log.debug( "scroll occured in " + e.target );
		}
	}
}
