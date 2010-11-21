package aesia.com.ponents.demos 
{
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.tabs.ClosableTab;
	import aesia.com.ponents.tabs.SimpleTab;
	import aesia.com.ponents.tabs.Tab;
	import aesia.com.ponents.tabs.TabbedPane;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	[SWF( width="640", height="430")]
	public class TabDemo extends Sprite 
	{
		[Embed(source="add.png")]
		private var add : Class;
		
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		public function TabDemo ()
		{
			var lv : LogView;
			var a : Array =[];
			var f : Function = function ( e : LogEvent):void
			{
				a.push( e.msg );	
			};
			Log.getInstance().addEventListener( LogEvent.LOG_ADD, f );
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			lv = new LogView();
			ToolKit.popupLevel.addChild(lv);
			
			StageUtils.lockToStage( lv, 257 );
			
			try
			{
				KeyboardControllerInstance.eventProvider = stage;
	
				createTabView( "north", 10, 10, true );				createTabView( "west", 220, 10, true, false );				createTabView( "south", 10, 220, true, false, true );				createTabView( "east", 220, 220, true, true, true );
				
				createTabView( "north", 430, 10, false );
				createTabView( "west", 430, 220, false, false, true );
											
				dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
				dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			}
			catch ( e : Error )
			{
				Log.error( e.message + ", " + e.getStackTrace() );
			}
		}
		
		protected function createTabView( pos : String, 
										  x : Number, 
										  y : Number, 
										  enabled : Boolean, 
										  dragEnabled : Boolean = true,
										  closable : Boolean = false ) : void
		{
			var tabbedPane : TabbedPane = new TabbedPane ( pos );
			tabbedPane.x = x;
			tabbedPane.y = y;
			tabbedPane.enabled = enabled;
			tabbedPane.dragEnabled = dragEnabled;
			tabbedPane.size = new Dimension ( 200, 200 );
			
			var tabClass : Class = closable ? ClosableTab : SimpleTab;
			
			var txt : TextArea = new TextArea();
			var tab1 : Tab = new tabClass( "Tab 1", txt );	
			
			var bt : Button = new Button();
			var tab2 : Tab = new tabClass( "Tab 2", bt, magicIconBuild( add ) );	
			
			var bt2 : Button = new Button();
			var scp : ScrollPane = new ScrollPane();
			scp.viewport.view = bt2;
			bt2.preferredSize = new Dimension(250,250);
			var tab3 : Tab = new tabClass( "Tab 3", scp );	
			
			var tab4 : Tab = new tabClass( "Tab 4" );	
			
			tabbedPane.addTab( tab1 );		
			tabbedPane.addTab( tab2 );		
			tabbedPane.addTab( tab3 );					tabbedPane.addTab( tab4 );		
			
			if( closable )
				tabbedPane.addEventListener( ComponentEvent.CLOSE, function ( e : Event ) : void {
					Log.debug( e.target + " was closed" );
			} );
			
			ToolKit.mainLevel.addChild( tabbedPane );
		}
	}
}
