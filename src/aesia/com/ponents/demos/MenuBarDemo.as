package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.buttons.ButtonGroup;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.menus.CheckBoxMenuItem;
	import aesia.com.ponents.menus.Menu;
	import aesia.com.ponents.menus.MenuBar;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.menus.MenuSeparator;
	import aesia.com.ponents.menus.RadioMenuItem;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class MenuBarDemo extends Sprite 
	{
		[Embed(source="add.png")]
		private var add : Class;
		
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		private var bg : ButtonGroup;
		
		public function MenuBarDemo ()
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
			
			KeyboardControllerInstance.eventProvider = stage;
			
			lv = new LogView();
			lv.size = new Dimension(200,400);
			lv.x = 350;
			ToolKit.mainLevel.addChild(lv);
			
			try
			{
				var menubar : MenuBar = new MenuBar();
				var menu1 : Menu = new Menu( "File" );
				menu1.mnemonic = KeyStroke.getKeyStroke( Keys.F );
				var menu2 : Menu = new Menu( "SubMenu", magicIconBuild( add ) );
				menu2.mnemonic = KeyStroke.getKeyStroke( Keys.B );				var menu3 : Menu = new Menu( "Edit" );				menu3.mnemonic = KeyStroke.getKeyStroke( Keys.E );
				menu1.addMenuItem( new MenuItem( new AbstractAction( "A long menu label", magicIconBuild(add) ) ) );
				
				var cmenu : CheckBoxMenuItem = new CheckBoxMenuItem( "CheckBox Menu" );
				cmenu.mnemonic = KeyStroke.getKeyStroke( Keys.C );
				menu1.addMenuItem( new MenuSeparator() );
				menu1.addMenuItem( cmenu );				menu1.addMenuItem( new MenuSeparator() );
				
				bg = new ButtonGroup();
				var rmenu1 : RadioMenuItem = new RadioMenuItem( "Radio Menu 1" );				var rmenu2 : RadioMenuItem = new RadioMenuItem( "Radio Menu 2" );				var rmenu3 : RadioMenuItem = new RadioMenuItem( "Radio Menu 3" );
				
				bg.add( rmenu1 );				bg.add( rmenu2 );				bg.add( rmenu3 );
				rmenu1.selected = true;
		
				menu1.addMenuItem(rmenu1 );				menu1.addMenuItem(rmenu2 );				menu1.addMenuItem(rmenu3 );								menu1.addMenuItem( new MenuSeparator() );
				menu1.addMenuItem( menu2 );
				
				menu2.addMenuItem( new MenuItem( new AbstractAction( "A long menu label", magicIconBuild(add) ) ) );
				menu2.addMenuItem( new MenuItem( ) );
				menu2.addMenuItem( new MenuItem( ) );
				menu2.addMenuItem( new MenuItem( ) );
				
				menu3.addMenuItem( new MenuItem( new AbstractAction( "A long menu label", magicIconBuild(add) ) ) );
				menu3.addMenuItem( new MenuItem() );
				menu3.addMenuItem( new MenuItem() );
				menu3.addMenuItem( new MenuItem() );
					
				menubar.addMenu( menu1 );				menubar.addMenu( menu3 );
				menubar.preferredWidth = 550;
				
				var toolbar : ToolBar = new ToolBar();
				toolbar.x = 0;				toolbar.y = 180;
				toolbar.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
				toolbar.addComponent(new Button());
				toolbar.preferredWidth = 550;
				
				ToolKit.mainLevel.addChild( menubar );				ToolKit.mainLevel.addChild( toolbar );
				
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
