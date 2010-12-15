package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.actions.ActionManagerInstance;
	import aesia.com.ponents.actions.builtin.BuiltInActionsList;
	import aesia.com.ponents.actions.builtin.RedoAction;
	import aesia.com.ponents.actions.builtin.UndoAction;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.factory.ComponentFactoryInstance;
	import aesia.com.ponents.menus.Menu;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.skinning.icons.magicIconBuild;

	import flash.display.Sprite;

	[Frame(factoryClass="aesia.com.ponents.factory.ComponentFactoryPreload")]
	[SWF(width="550",height="550")]
	/**
	 * @author cedric
	 */
	public class PreloadPlayground extends Sprite 
	{
		[Embed(source="../skinning/icons/calendar.png")]
		public var CALENDAR : Class;

		[Embed(source="add.png")]
		private var add : Class;

		[Embed(source="exclamation.png")]
		private var exclamation : Class;

		[Embed(source="error.png")]
		private var error : Class;

		[Embed(source="information.png")]
		private var information : Class;

		[Embed(source="lightbulb.png")]
		private var lightbulb : Class;

		[Embed(source="bgstretch.png")]
		private var bgStretchClass : Class;

		[Embed(source="bgtile.png")]
		private var bgTileClass : Class;

		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		static public const MOVABLES : String = "movables";		static public const CONTAINERS : String = "containers";
		
		public function PreloadPlayground ()
		{
			try
			{
				StageUtils.noMenu();
				Reflection.WARN_UNWRAPPED_STRING = false;
				
				ActionManagerInstance.createBuiltInActions();
				
				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.UNDO ) as UndoAction ).contextMenuItem );
				StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.REDO ) as RedoAction ).contextMenuItem );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	
				/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
				dropRenderer = new DnDDropRenderer( DnDManagerInstance );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				createBuild();
			}
			catch( e : Error )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.error( e.getStackTrace() );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
		}
		protected function createBuild () : void 
		{
			ComponentFactoryInstance.group( MOVABLES );			ComponentFactoryInstance.group( CONTAINERS );
			
			createMenuBar();
		}
		protected function createMenuBar () : void 
		{
			/*
			buildLoop( Menu, 
					   8, 
					   MOVABLES, 
					   "menu", 
					   [["File",magicIconBuild(add)],["Edit"],["Submenu"]], 
					   {mnemonic:[KeyStroke.getKeyStroke( Keys.F ),KeyStroke.getKeyStroke( Keys.E ),KeyStroke.getKeyStroke( Keys.S )]} );
			*/	   
			ComponentFactoryInstance.group( MOVABLES )
									.build( Menu, "fileMenu", ["File",magicIconBuild(add)], { mnemonic : KeyStroke.getKeyStroke( Keys.F ) } )
									.build( Menu, "editMenu", ["Edit"], { mnemonic : KeyStroke.getKeyStroke( Keys.E ) } )
									.build( Menu, "subMenu", ["Submenu"], { mnemonic : KeyStroke.getKeyStroke( Keys.S ) } )
									.build( MenuItem, "dragmeMenu", [ new AbstractAction( "Drag Me", magicIconBuild( add ) ) ] )									.build( MenuItem, "disabledMenu", [ new AbstractAction( "Disabled Menu", magicIconBuild( add ) ) ] );
									
		}
		protected function buildLoop ( c : Class, 
									   num : uint = 1, 
									   group : String = null, 
									   id : String = "component", 
									   args : Array = null, 
									   kwargs : Object = null, 
									   callback : * = null, 
									   kwargsOrder : Array = null ) : void
		{
			var a : Array;
			var kwa : Object;
			var cb : Function;
			
			for ( var i : uint = 0; i<num; i++ )
			{			
				if( args && args[i] )
					a = args[i];
				else
					a = null;
				
				if ( kwargs )
				{
					kwa = {};
					for ( var k : String in kwargs )
					{
						kwa[k] = kwargs[k][i];
					}
				}
				else
					kwa = null;
				
				if( callback != null )
				{
					if( callback is Array )
					{
						if( callback[i] != null )
							cb = callback[i];
						else
							cb = null;
					}	
					else if ( callback is Function )
					{
						cb = callback;					
					}
				}

				ComponentFactoryInstance.group( group ).build( c, id + i, a, kwa, cb, kwargsOrder );
			}
		}
	}
}
