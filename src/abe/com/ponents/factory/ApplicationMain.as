package abe.com.ponents.factory 
{
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.StringUtils;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.patibility.settings.SettingsManagerInstance;
    import abe.com.ponents.actions.ActionManagerInstance;
    import abe.com.ponents.buttons.ButtonDisplayModes;
    import abe.com.ponents.containers.*;
    import abe.com.ponents.core.*;
    import abe.com.ponents.events.*;
    import abe.com.ponents.layouts.components.*;
    import abe.com.ponents.layouts.components.splits.Node;
    import abe.com.ponents.menus.MenuBar;
    import abe.com.ponents.skinning.*;
    import abe.com.ponents.skinning.decorations.*;
    import abe.com.ponents.tabs.ClosableTab;
    import abe.com.ponents.utils.*;

    import org.osflash.signals.*;
    import org.osflash.signals.events.*;

    import flash.display.Sprite;
    import flash.ui.ContextMenuItem;
    /**
     * @author cedric
     */
    public class ApplicationMain extends Sprite implements EntryPoint, IBubbleEventHandler 
    {
        static public var instance : ApplicationMain;
        
        
        TARGET::FLASH_9
        protected var _buildUnits : Array;
        TARGET::FLASH_10
        protected var _buildUnits : Vector.<ComponentBuildUnit>;
        TARGET::FLASH_10_1 
        protected var _buildUnits : Vector.<ComponentBuildUnit>;        

        protected var _dockables : Object = {};
        
        protected var _appName : String;
        protected var _appVersion : String;
        
        protected var _mainMenuBar : MenuBar;
        protected var _mainToolBar : ToolBar;
        protected var _mainSplitPane : DockableMultiSplitPane;
        
        protected var _defaultToolBarSettings : String = "undo,redo";
        protected var _defaultMenuBarSettings : String = "*Edit(*undo,*redo),?(*about)";
        protected var _defaultDMSPSettings : String = "V()";
        protected var _defaultToolBarPosition : String = "north";
        
        protected var _buildSetted : Signal;

        public function ApplicationMain ( appName : String = "Unnamed Application", appVersion : String = "0.1.0" )
        {
            _buildSetted = new Signal();
            
            ToolKit.initializeToolKit( StageUtils.root, false );
            
            instance = this;
            
            TARGET::FLASH_9 { _buildUnits = []; }
            TARGET::FLASH_10 { _buildUnits = new Vector.<ComponentBuildUnit>(); }
            TARGET::FLASH_10_1 { _buildUnits = new Vector.<ComponentBuildUnit>(); } 
            
            _appName = appName;
            _appVersion = appVersion;
            
            ActionManagerInstance.createBuiltInActions();
            
            FEATURES::MENU_CONTEXT { 
                StageUtils.noMenu();
                //StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.UNDO ) as UndoAction ).contextMenuItem );
                //StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.REDO ) as RedoAction ).contextMenuItem );
                StageUtils.versionMenuContext = new ContextMenuItem( _$(_("$0 $1"), _appName, _appVersion ) );
            } 
            
            ComponentFactoryInstance.buildCompleted.add( buildCompleted );
        }
        public function get buildSetted () : Signal { return _buildSetted; }
        public function get appName () : String { return _appName; }
        public function set appName (appName : String) : void { _appName = appName; }
        public function get dockables () : Object { return _dockables; }
        
        protected function build () : void
        {
            if( _buildUnits.length > 0 )
                for each( var unit : ComponentBuildUnit in _buildUnits )
                    unit.build( ComponentFactoryInstance );
        }
        protected function buildCompleted ( f : ComponentFactory, current : Number, total : Number ) : void 
        {
            ComponentFactoryInstance.buildCompleted.remove( buildCompleted );
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
                dmsp.multiSplitLayout.optimized.add( multiSplitOptimized );
                dmsp.weightChanged.add( multiSplitWeightChanged );
                
                ( p.childrenLayout as ApplicationWindowLayout ).toolBarDropped.add( toolBarDropped );

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
        protected function toolBarDropped ( l : ApplicationWindowLayout, t : Component ) : void 
        {
            if( t == _mainToolBar )
                SettingsManagerInstance.set(this, "mainToolBarPosition", l.getPosition( t ) );
        }
        protected function multiSplitWeightChanged ( dmsp : DockableMultiSplitPane ) : void 
        {
            var s : String = ApplicationUtils.serializeDMSP( dmsp.multiSplitLayout.modelRoot );
            SettingsManagerInstance.set( this, "mainLayout", s );
        }
        protected function multiSplitOptimized ( l : ComponentLayout ) : void 
        {
            var dmsp : DockableMultiSplitPane = l.container as DockableMultiSplitPane;
            dmsp.componentRepainted.addOnce( multiSplitRepainted );
        }
        protected function multiSplitRepainted ( dmsp : DockableMultiSplitPane ) : void 
        {
            var n : Node = dmsp.multiSplitLayout.modelRoot;
            var s : String = ApplicationUtils.serializeDMSP(n);
            SettingsManagerInstance.set( this, "mainLayout", s );
        }
        protected function contentClose (event : ComponentEvent) : void 
        {
            if( event.target is ClosableTab )
                ( event.target as ClosableTab ).removeFromParent();
        }
        public function fireProceedBuild () : void
        {
            _buildSetted.dispatch( this );
        }
        public function onEventBubbled( e : IEvent ):Boolean
        {
            var evt : ComponentSignalEvent = e as ComponentSignalEvent;
            if( evt.signalName == "tabClosed" && evt.target is ClosableTab )
                 ( evt.target as ClosableTab ).removeFromParent();
              
            return false;
        }
    }
}
