package  
{
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.backends.CookieBackend;
	import abe.com.ponents.actions.ActionManagerInstance;
	import abe.com.ponents.actions.builtin.AboutAction;
	import abe.com.ponents.dnd.DnDDragObjectRenderer;
	import abe.com.ponents.dnd.DnDDropRenderer;
	import abe.com.ponents.dnd.DnDManagerInstance;
	import abe.com.ponents.events.ComponentFactoryEvent;
	import abe.com.ponents.factory.ApplicationMain;
	import abe.com.ponents.factory.ComponentFactoryInstance;
	import abe.com.ponents.factory.ComponentFactoryPreload;
	import abe.com.ponents.flexunit.AbeFlexUnitUI;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	
	import org.flexunit.runner.FlexUnitCore;

	import flash.events.ContextMenuEvent;

	[SWF(width="800",height="600", backgroundColor="#3a545c")]
	[Frame(factoryClass="abe.com.ponents.factory.ComponentFactoryPreload")]
	[SettingsBackend(backend="abe.com.patibility.settings.backends.CookieBackend", appName="AbeLibTestRunner")]
	public class AbeLibTestRunner extends ApplicationMain 
	{
		static private const DEPENDENCIES : Array = [ CookieBackend ];
		
		[Embed(source="../src/abe/com/ponents/skinning/icons/package.png")]
		static private var testsIcon : Class;
		
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		protected var _uiListener : AbeFlexUnitUI;

		public function AbeLibTestRunner ()
		{
			super( "AbeLib TestRunner", "0.1.1" );
			
			Reflection.WARN_UNWRAPPED_STRING = false;
			
			ActionManagerInstance.registerAction( new AboutAction( _appName, 
																   _appVersion, 
																   _("Run the unit test for the AbeLib toolkit."), 
																   _("AbeLib © 2010 - All rights reserved."), 
																   _("About the AbeLib TestRunner") ), 
												  "about" );
			
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				StageUtils.versionMenuContext.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, ActionManagerInstance.getAction("about").execute );	
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
												  
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_defaultDMSPSettings = "V(uiListener)";
		}
		override public function init (preload : ComponentFactoryPreload) : void 
		{
			super.init( preload );
			ComponentFactoryInstance.group("movables").build( AbeFlexUnitUI, 
															  "uiListener", 
															  [ "Tests", magicIconBuild(testsIcon) ],
															  null,
															  function( ul : AbeFlexUnitUI, ctx : Object ) : void
															  {
															  	_uiListener = ul;
																_dockables["uiListener"] = _uiListener;
															  });
			fireProceedBuild();
		}
		override protected function buildComplete (e : ComponentFactoryEvent) : void 
		{
			super.buildComplete( e );
			
			var core : FlexUnitCore = new FlexUnitCore();
			core.addListener( _uiListener );
			core.run( AbeLibTestSuite );
		}
	}
}