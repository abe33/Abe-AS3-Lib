package aesia.com.ponents.utils 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.ponents.actions.Action;
	import aesia.com.ponents.actions.ActionManagerInstance;
	import aesia.com.ponents.containers.DockableMultiSplitPane;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.containers.ToolBarSpacer;
	import aesia.com.ponents.core.Dockable;
	import aesia.com.ponents.layouts.components.splits.Divider;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.layouts.components.splits.Node;
	import aesia.com.ponents.layouts.components.splits.Split;
	import aesia.com.ponents.menus.Menu;
	import aesia.com.ponents.menus.MenuBar;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.menus.MenuSeparator;
	import aesia.com.ponents.tabs.ClosableTab;
	import aesia.com.ponents.tabs.SimpleTab;
	import aesia.com.ponents.tabs.Tab;
	import aesia.com.ponents.tabs.TabbedPane;
	/**
	 * @author cedric
	 */
	public class ApplicationUtils 
	{
		static private var dmspRE : RegExp = /^(V|H)\(/i;
		static private var menuRE : RegExp = /^([\w\s*?-_]+)\(/i;
		
		static public function serializeDMSP( root : Node ): String
		{
			var s : String = "";
			var a : Array = [];
			var w : Number;
			if( root is Split )
			{
				var split : Split = root as Split;
				w = split.weight;
				s += split.rowLayout ? "H(" : "V(";
				
				for each( var n : Node in split.children )
					if( !( n is Divider )  )
						a.push( serializeDMSP(n) );
	
				s += a.join(",") + ")";
			}
			else
			{
				var pane : TabbedPane = ( root as Leaf ).component as TabbedPane;
				w = root.weight;
				
				if( pane )
					for( var i : uint; i < pane.tabBar.childrenCount; i++ )
						a.push( pane.tabBar.getComponentAt(i).id );
				
				s = a.join("|");
			}
			return s;
		}
		static public function buildDMSP ( s : String, 
										   dmsp : DockableMultiSplitPane, 
										   ctx : Object, 
										   dockables : Object, 
										   root : Split = null ) : void
		{
			var l : uint;
			var i : uint;
			
			// split
			if( dmspRE.test(s) )
			{
				var res : * = dmspRE.exec(s);
				var type : String = res[1];				var ind : int = s.indexOf("(");
				var args : Array = StringUtils.splitBlock( s.substring( ind + 1, StringUtils.findClosingIndex(s, ind + 1, "(", ")")) );
				
				l = args.length;
				
				var split : Split = new Split( type == "H" );
				
				for( i=0;i<l;i++)
					buildDMSP( args[i], dmsp, ctx, dockables, split );
				
				if( root )
					dmsp.multiSplitLayout.addSplitChild( root, split );
				else
					dmsp.multiSplitLayout.modelRoot = split;
			}
			else
			{
				var cs : Array = s.split("|");
				
				l = cs.length;
				var container : TabbedPane = new TabbedPane();
				var leaf : Leaf = new Leaf( container );
				var tab : Tab;
				for( i=0;i<l;i++)
				{
					s = cs[i];
					if( dockables.hasOwnProperty( s ) )
					{
						var dock : Dockable = dockables[s];
						
						if( dmsp.closeable )
							tab = new ClosableTab( dock.label, dock.content, dock.icon ? dock.icon.clone() : null );
						else
							tab = new SimpleTab( dock.label, dock.content, dock.icon ? dock.icon.clone() : null );
						
						tab.id = s;
						container.addTab(tab);
					}
				}	
				
				if( root )
					dmsp.multiSplitLayout.addSplitChild( root, leaf );
				else
					dmsp.multiSplitLayout.modelRoot = leaf;			

				dmsp.addComponent( container );
			}
		}
		static public function serializeToolBar( t : ToolBar ) : String
		{
			return null;
		}
		static public function buildToolBar ( toolSettings : String, t : ToolBar ) : void
		{
			var a : Array = toolSettings.split(",");
			var l : uint = a.length;
			for( var i : uint = 0; i <l; i++ )
			{
				var s : String = a[i];
				if( s == "|" )
					t.addSeparator();
				else if( s == "-" )
					t.addComponent( new ToolBarSpacer( t ));
				else
				{
					var act : Action = ActionManagerInstance.getAction( s );
					if( act )
						t.addComponent(act.component);
				}
			}
		}
		static public function serializeMenuBar ( mb : MenuBar ) : String
		{
			return null;
		}		
		static public function buildMenuBar( s : String, mb : MenuBar, ctx : Object, menu : Menu = null ) : void
		{
			if( s == "" )
				return;

			var res : Object;
			var acc : KeyStroke = null;
			var i : int;
			var dsb : Boolean = s.indexOf("-") == 0;
			if( dsb )
				s = s.substr(1);
				
			if( ( res = menuRE.exec(s) ) != null )
			{
				var type : String = res[1];
				var ind : uint = type.length + 1;
				var args : Array = StringUtils.splitBlock( s.substr( ind, StringUtils.findClosingIndex(s, ind, "(", ")")-ind) );
				
				if( type.indexOf("*") != -1 )
				{
					i = type.indexOf("*");
					acc = KeyStroke.getKeyStroke( Keys[ type.substr(i+1,1).toUpperCase() ]);
					type = type.replace("*", "");
				}
				
				var mn : Menu = new Menu( type );
				mn.mnemonic = acc;
				if( dsb ) mn.enabled = false;
				
				var l : uint = args.length;
				for ( i = 0; i<l ;i++)
					buildMenuBar( args[i], mb, ctx, mn );
				
				if( menu )
					menu.addMenuItem(mn);
				else
					mb.addMenu(mn);
			}
			else if( s == "|" )
			{
				if( menu )
					menu.addMenuItem(new MenuSeparator());
			}
			else
			{
				if( menu )
				{
					
					if( s.indexOf("*") != -1 )
					{
						i = s.indexOf("*");
						acc = KeyStroke.getKeyStroke( Keys[ s.substr(i+1,1).toUpperCase() ]);
						s = s.replace("*", "");
					}
					
					var m : MenuItem;
					var act : Action = ActionManagerInstance.getAction(s);
					if( act )
					{
						m = new MenuItem( act );
						m.mnemonic = acc;
						if( dsb ) m.enabled = false;
						menu.addMenuItem ( m );
					}
					else
					{
						if( ctx.hasOwnProperty(s) )
						{
							var o : Object = ctx[s];
							if( o is MenuItem )
							{
								m = o as MenuItem;
								m.mnemonic = acc;
								if( dsb ) m.enabled = false;
								menu.addMenuItem( m );
							}
						}
						else
						{
							m = new Menu( s );
							m.mnemonic = acc;
							if( dsb ) m.enabled = false;
							menu.addMenuItem( m );
						}
					}
				}
			}
		}
	}
}
