package abe.com.prehension.examples
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.backends.CookieBackend;
	import abe.com.ponents.actions.ActionManagerInstance;
	import abe.com.ponents.actions.builtin.AboutAction;
	import abe.com.ponents.actions.builtin.ColorPickerAction;
	import abe.com.ponents.actions.builtin.GradientPickerAction;
	import abe.com.ponents.dnd.DnDDragObjectRenderer;
	import abe.com.ponents.dnd.DnDDropRenderer;
	import abe.com.ponents.dnd.DnDManagerInstance;
	import abe.com.ponents.factory.ApplicationMain;
	import abe.com.ponents.factory.ComponentFactoryPreload;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.tabs.SimpleTab;
	import abe.com.ponents.tools.DebugPanel;
	import abe.com.ponents.tools.ServiceTesterPanel;
	import abe.com.ponents.utils.ToolKit;
	import abe.com.prehension.examples.dockables.*;

	import flash.events.ContextMenuEvent;

	[SWF(width="800",height="600", backgroundColor="#3a545c")]
	[Frame(factoryClass="abe.com.ponents.factory.ComponentFactoryPreload")]
	[SettingsBackend(backend="abe.com.patibility.settings.backends.CookieBackend", appName="FactoryPlayground")]
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
																   _("The Playground is a way to demonstrate\nthe features of the AbeLib Components Kit."), 
																   _("AbeLib © 2010 - All rights reserved."), 
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
							  				 magicIconBuild("../res/icons/tools/server_go.png")));
			
			_buildUnits.push( new ButtonDemoDockable( 	"buttons", 	_("Buttons"), 	 magicIconBuild("../res/icons/components/button.png") ) );
			_buildUnits.push( new TextDemoDockable( 	"text", 	_("Text"), 		 magicIconBuild("../res/icons/components/textfield.png") ) );
			_buildUnits.push( new SpinnerDemoDockable( 	"spinners", _("Spinners"), 	 magicIconBuild("../res/icons/components/spinner.png") ) );
			_buildUnits.push( new SliderDemoDockable( 	"sliders", 	_("Sliders"), 	 magicIconBuild("../res/icons/components/slider.png") ) );
			_buildUnits.push( new ComboBoxDemoDockable( "combobox", _("ComboBoxes"), magicIconBuild("../res/icons/components/combobox.png") ) );
			_buildUnits.push( new ProgressDemoDockable( "progress", _("Progress"), 	 magicIconBuild("../res/icons/components/progress.png") ) );
			_buildUnits.push( new ListDemoDockable( 	"lists", 	_("Lists"), 	 magicIconBuild("../res/icons/components/list.png") ) );
			_buildUnits.push( new TreeDemoDockable( 	"trees", 	_("Trees"), 	 magicIconBuild("../res/icons/components/tree.png") ) );
			_buildUnits.push( new TableDemoDockable( 	"tables", 	_("Tables"), 	 magicIconBuild("../res/icons/components/table.png") ) );
			
			for each ( var d : DemoDockable in _buildUnits )
				_dockables[d.id] = d;
				
			super.init(preload);
			fireProceedBuild();
		}
		
	}
}
