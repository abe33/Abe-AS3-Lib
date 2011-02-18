package aesia.com.ponents.factory 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.ponents.actions.ActionManagerInstance;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.containers.DockableMultiSplitPane;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.SlidePane;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.ComponentFactoryEvent;
	import aesia.com.ponents.events.ContainerEvent;
	import aesia.com.ponents.events.SplitPaneEvent;
	import aesia.com.ponents.layouts.components.ApplicationWindowLayout;
	import aesia.com.ponents.layouts.components.splits.Node;
	import aesia.com.ponents.menus.MenuBar;
	import aesia.com.ponents.skinning.DefaultSkin;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.skinning.decorations.SimpleFill;
	import aesia.com.ponents.tabs.ClosableTab;
	import aesia.com.ponents.utils.ApplicationUtils;
	import aesia.com.ponents.utils.Corners;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.ui.ContextMenuItem;
	/**
	 * @author cedric
	 */
	public class ApplicationMain extends Sprite implements EntryPoint
	{
		static public var instance : ApplicationMain;
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _buildUnits : Array;
		TARGET::FLASH_10
		protected var _buildUnits : Vector.<ComponentBuildUnit>;
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _buildUnits : Vector.<ComponentBuildUnit>;		

		protected var _dockables : Object = {};
		
		protected var _appName : String;		protected var _appVersion : String;
		
		protected var _mainMenuBar : MenuBar;
		protected var _mainToolBar : ToolBar;
		protected var _mainSplitPane : DockableMultiSplitPane;
		
		protected var _defaultToolBarSettings : String = "undo,redo";		protected var _defaultMenuBarSettings : String = "*Edit(*undo,*redo),?(*about)";		protected var _defaultDMSPSettings : String = "V()";
		protected var _defaultToolBarPosition : String = "north";

		public function ApplicationMain ( appName : String = "Unnamed Application", appVersion : String = "0.1.0" )
		{
			instance = this;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _buildUnits = []; }
			TARGET::FLASH_10 { _buildUnits = new Vector.<ComponentBuildUnit>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_buildUnits = new Vector.<ComponentBuildUnit>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_appName = appName;
			_appVersion = appVersion;
			
			ActionManagerInstance.createBuiltInActions();
			
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			StageUtils.noMenu();
			//StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.UNDO ) as UndoAction ).contextMenuItem );
			//StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.REDO ) as RedoAction ).contextMenuItem );			StageUtils.versionMenuContext = new ContextMenuItem( _$(_("$0 $1"), _appName, _appVersion ) );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			ComponentFactoryInstance.addEventListener( ComponentFactoryEvent.BUILD_COMPLETE, buildComplete );
		}
		public function get appName () : String { return _appName; }
		public function set appName (appName : String) : void { _appName = appName; }
		public function get dockables () : Object { return _dockables; }
		
		protected function build () : void
		{
			if( _buildUnits.length > 0 )
				for each( var unit : ComponentBuildUnit in _buildUnits )
					unit.build( ComponentFactoryInstance );
		}
		protected function buildComplete ( e : ComponentFactoryEvent ) : void 
		{
			ComponentFactoryInstance.removeEventListener( ComponentFactoryEvent.BUILD_COMPLETE, buildComplete );
		}
		public function init ( preload : ComponentFactoryPreload ) : void 
		{
			ComponentFactoryInstance.group( "movables" );
			ComponentFactoryInstance.group( "containers" );
			
			build();
			
			ComponentFactoryInstance.group( "containers" 
								   ).build( MenuBar, 
								   			"mainMenu",
								   			null,
								   			null,
								   			onMenuBarComplete
								   ).build( SlidePane, 
								   			"mainMenuPane"
								   ).build( ToolBar, 
								   			"mainToolBar",
								   			null,
								   			{ allowDrag:true, buttonDisplayMode:ButtonDisplayModes.ICON_ONLY }, 
								   			onToolBarComplete
								   ).build( SlidePane, 
								   			"mainToolBarPane"
								   ).build( DockableMultiSplitPane, 
								   			"mainSplit"
								   ).build( Panel, 
								   			"mainPanel", 
								   			null,
								   			{ childrenLayout:new ApplicationWindowLayout( null ) },
								   			onMultiSplitPaneComplete );
		}
		protected function onMenuBarComplete ( t : MenuBar, ctx : Object ) : void
		{			
			var menuSettings : String = SettingsManagerInstance.get( this, "mainMenu", _defaultMenuBarSettings );
			
			if( menuSettings )
			{
				var args : Array = StringUtils.splitBlock( menuSettings);
				var l : uint = args.length;
				for(var i:uint = 0;i<l;i++)
					ApplicationUtils.buildMenuBar( args[i], t, ctx );
			}
		}
		protected function onToolBarComplete ( t : ToolBar, ctx : Object ) : void
		{
			var toolSettings : String = SettingsManagerInstance.get( this, "mainTools", _defaultToolBarSettings );
			
			if( toolSettings )
				ApplicationUtils.buildToolBar(toolSettings, t);

		} 
		protected function onMultiSplitPaneComplete ( p : Panel, ctx : Object ) : void 
		{
			var dmsp : DockableMultiSplitPane = ctx["mainSplit"] as DockableMultiSplitPane;
			var menu : MenuBar = ctx["mainMenu"] as MenuBar;
			var mpane : SlidePane = ctx["mainMenuPane"] as SlidePane;
			var toolbar : ToolBar = ctx["mainToolBar"] as ToolBar;
			var tpane : SlidePane = ctx["mainToolBarPane"] as SlidePane;
			
			_mainSplitPane = dmsp;
			_mainToolBar = toolbar;
			_mainMenuBar = menu;
			
			var l : ApplicationWindowLayout = p.childrenLayout as ApplicationWindowLayout;
			var toolBarPosition : String = SettingsManagerInstance.get( this, "mainToolBarPosition", _defaultToolBarPosition );
			
			if( dmsp )
			{
				var dmspSettings : String = SettingsManagerInstance.get( this, "mainLayout", _defaultDMSPSettings );
				
				if( dmspSettings )
					ApplicationUtils.buildDMSP( dmspSettings, dmsp, ctx, _dockables );
				
				dmsp.style.setForAllStates("insets", new Insets(5));
				dmsp.addEventListener(ComponentEvent.CLOSE, contentClose );
				dmsp.multiSplitLayout.addEventListener(SplitPaneEvent.OPTIMIZE, multiSplitOptimize );				dmsp.addEventListener(SplitPaneEvent.WEIGHT_CHANGE, multiSplitWeightChange );
				
				p.childrenLayout.addEventListener( ApplicationWindowLayout.TOOLBAR_DROP, toolBarDrop );
				
				SkinManagerInstance.getStyle("DefaultSkin#TabbedPane"
								  ).setForAllStates( "corners", new Corners(3) 
								  ).setForAllStates( "insets", new Insets(0,3,0,3));
				
				mpane.view = menu;
				
				tpane.view = toolbar;
				
				tpane.style.setForAllStates("background", new SimpleFill(DefaultSkin.PastelYellow));
				
				p.addComponent( mpane );
				l.menuComponent = mpane;
				
				toolbar.direction = ( toolBarPosition == "north" || toolBarPosition == "south" ) ? "leftToRight" : "topToBottom";
				p.addComponent( tpane );
				l.addComponent( tpane, toolBarPosition );
				
				p.addComponent( dmsp );
				l.center = dmsp;
				
				ToolKit.mainLevel.addChild(p);
				StageUtils.lockToStage( p );
			}
		}
		protected function toolBarDrop ( event : ContainerEvent ) : void 
		{
			if( event.child == _mainToolBar )
				SettingsManagerInstance.set(this, "mainToolBarPosition", ( event.target as ApplicationWindowLayout ).getPosition( event.child ) );
		}
		protected function multiSplitWeightChange (event : SplitPaneEvent) : void 
		{
			var dmsp : DockableMultiSplitPane = event.target as DockableMultiSplitPane;
			var s : String = ApplicationUtils.serializeDMSP( dmsp.multiSplitLayout.modelRoot );
			SettingsManagerInstance.set( this, "mainLayout", s );
		}
		protected function multiSplitOptimize ( event : SplitPaneEvent ) : void 
		{
			var dmsp : DockableMultiSplitPane = event.target.container as DockableMultiSplitPane;
			dmsp.addEventListener( ComponentEvent.REPAINT, multiSplitRepaint );
		}
		protected function multiSplitRepaint (event : ComponentEvent) : void 
		{
			var dmsp : DockableMultiSplitPane = event.target as DockableMultiSplitPane;
			dmsp.removeEventListener( ComponentEvent.REPAINT, multiSplitRepaint );
			var n : Node = dmsp.multiSplitLayout.modelRoot;
			var s : String = ApplicationUtils.serializeDMSP(n);
			SettingsManagerInstance.set( this, "mainLayout", s );
		}
		protected function contentClose (event : ComponentEvent) : void 
		{
			if( event.target is ClosableTab )
				( event.target as ClosableTab ).removeFromParent( );
		}
		public function fireProceedBuild () : void
		{
			dispatchEvent( new ComponentFactoryEvent(ComponentFactoryEvent.PROCEED_BUILD ) );
		}
	}
}
