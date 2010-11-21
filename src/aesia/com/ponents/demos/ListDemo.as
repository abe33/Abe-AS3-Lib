package aesia.com.ponents.demos 
{
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
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.ponents.tools.DebugPanel;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	[SWF(backgroundColor="#cccccc")]
	public class ListDemo extends Sprite 
	{
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		public function ListDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var p : DebugPanel = new DebugPanel();
			ToolKit.popupLevel.addChild(p);
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				
				KeyboardControllerInstance.eventProvider = stage;
				KeyboardControllerInstance.addGlobalKeyStroke( KeyStroke.getKeyStroke( Keys.Z, KeyStroke.getModifiers( true ) ), 
												  new ProxyCommand( UndoManagerInstance.undo ) );
				KeyboardControllerInstance.addGlobalKeyStroke( KeyStroke.getKeyStroke( Keys.Y, KeyStroke.getModifiers( true ) ), 
												  new ProxyCommand( UndoManagerInstance.redo ) );
				
				var a : Array = new Array();
				for(var i:uint=0;i<10000;i++)
					a.push( "Item "+ i );
	
				var l : List = new List( a );
				l.allowMultiSelection = true;
				
				var scp : ScrollPane = new ScrollPane();
				scp.view = l;
				scp.rowHead = new ListLineRuler( l );
				scp.preferredSize = new Dimension ( 150, 400 );
				
				var l2 : List = new List( [ "Item 1", 
											"Item 2", 
											"Item 3 with a longer text.", 
											"Item 4", 
											"Item 5", 
											"Item 6" ] );
				( l2.model as DefaultListModel ).immutable = true;
				
				l2.x = 200;

				ToolKit.mainLevel.addChild( scp );
				ToolKit.mainLevel.addChild( l2 );
								
				dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
				dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
