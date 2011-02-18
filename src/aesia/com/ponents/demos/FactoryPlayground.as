package aesia.com.ponents.demos 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.settings.backends.CookieBackend;
	import aesia.com.ponents.actions.ActionManagerInstance;
	import aesia.com.ponents.actions.builtin.AboutAction;
	import aesia.com.ponents.actions.builtin.ColorPickerAction;
	import aesia.com.ponents.actions.builtin.GradientPickerAction;
	import aesia.com.ponents.demos.dockables.ButtonDemoDockable;
	import aesia.com.ponents.demos.dockables.ComboBoxDemoDockable;
	import aesia.com.ponents.demos.dockables.DemoDockable;
	import aesia.com.ponents.demos.dockables.ListDemoDockable;
	import aesia.com.ponents.demos.dockables.ProgressDemoDockable;
	import aesia.com.ponents.demos.dockables.SliderDemoDockable;
	import aesia.com.ponents.demos.dockables.SpinnerDemoDockable;
	import aesia.com.ponents.demos.dockables.TableDemoDockable;
	import aesia.com.ponents.demos.dockables.TextDemoDockable;
	import aesia.com.ponents.demos.dockables.TreeDemoDockable;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.factory.ApplicationMain;
	import aesia.com.ponents.factory.ComponentFactoryPreload;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.tabs.SimpleTab;
	import aesia.com.ponents.tools.DebugPanel;
	import aesia.com.ponents.tools.ServiceTesterPanel;
	import aesia.com.ponents.utils.ToolKit;

	import flash.events.ContextMenuEvent;

	[SWF(width="800",height="600", backgroundColor="#3a545c")]
	[Frame(factoryClass="aesia.com.ponents.factory.ComponentFactoryPreload")]
	[SettingsBackend(backend="aesia.com.patibility.settings.backends.CookieBackend", appName="FactoryPlayground")]
	/**
	 * @author cedric
	 */
	public class FactoryPlayground extends ApplicationMain 
	{
		
		static private const DEPENDENCIES : Array = [ CookieBackend ];
		
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;

		public function FactoryPlayground ()
		{
			super( "Playground", "2.2.5" );
			
			ActionManagerInstance.registerAction( new ColorPickerAction(), "colorPick" );
			ActionManagerInstance.registerAction( new GradientPickerAction(), "gradientPick" );
			ActionManagerInstance.registerAction( new AboutAction( _appName, 
																   _appVersion, 
																   _("The Playground is a way to demonstrate\nthe features of the Aesia Components Kit."), 																   _("Aesia © 2010 - All rights reserved."), 
																   _("About Playground") ), 
												  "about" );
			
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				StageUtils.versionMenuContext.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, ActionManagerInstance.getAction("about").execute );	
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
												  
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_defaultMenuBarSettings = "*File(*New,*Open,|,*Recent Files(*A,*B,*C)),*Edit(*undo,*redo),*Tools(*Logs(clearLogs,saveLogs),*Settings(clearSettings,showSettings)),*Custom(*colorPick,*gradientPick),?(*about)";
			_defaultDMSPSettings = "V(buttons|spinners|text|sliders|combobox|progress|lists|trees|tables)";
			_defaultToolBarSettings = "undo,redo";
		}
		override public function init( preload : ComponentFactoryPreload ) : void
		{
			var debugPanel : DebugPanel = ToolKit.popupLevel.getChildByName("debugPanel") as DebugPanel;
			debugPanel.addTab( new SimpleTab( _("Service"), 
							  				 new ServiceTesterPanel(), 
							  				 magicIconBuild("icons/tools/server_go.png")));
			
			_buildUnits.push( new ButtonDemoDockable( 	"buttons", 	_("Buttons"), 	 magicIconBuild("icons/components/button.png") ) );
			_buildUnits.push( new TextDemoDockable( 	"text", 	_("Text"), 		 magicIconBuild("icons/components/textfield.png") ) );
			_buildUnits.push( new SpinnerDemoDockable( 	"spinners", _("Spinners"), 	 magicIconBuild("icons/components/spinner.png") ) );
			_buildUnits.push( new SliderDemoDockable( 	"sliders", 	_("Sliders"), 	 magicIconBuild("icons/components/slider.png") ) );
			_buildUnits.push( new ComboBoxDemoDockable( "combobox", _("ComboBoxes"), magicIconBuild("icons/components/combobox.png") ) );
			_buildUnits.push( new ProgressDemoDockable( "progress", _("Progress"), 	 magicIconBuild("icons/components/progress.png") ) );
			_buildUnits.push( new ListDemoDockable( 	"lists", 	_("Lists"), 	 magicIconBuild("icons/components/list.png") ) );
			_buildUnits.push( new TreeDemoDockable( 	"trees", 	_("Trees"), 	 magicIconBuild("icons/components/tree.png") ) );
			_buildUnits.push( new TableDemoDockable( 	"tables", 	_("Tables"), 	 magicIconBuild("icons/components/table.png") ) );
			
			for each ( var d : DemoDockable in _buildUnits )
				_dockables[d.id] = d;
				
			super.init(preload);
		}
		
	}
}
