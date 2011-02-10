package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.patibility.accessors.Accessor;
	import aesia.com.patibility.accessors.SettingsAccessor;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.containers.WindowTitleBar;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.tables.Table;
	import aesia.com.ponents.tables.TableColumn;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class ShowSettingsBackendAction extends AbstractAction 
	{
		[Embed(source="../../skinning/icons/database_table.png")]
		static private var showSettingsIcon : Class;
		
		public function ShowSettingsBackendAction (name : String = "", icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null)
		{
			super( name, icon ? icon : magicIconBuild( showSettingsIcon ), longDescription, accelerator );
		}
		override public function execute (e : Event = null) : void 
		{
			var a : Array =  SettingsManagerInstance.settingsList;
			var b : Array = [];
			var l : uint = a.length;
			for( var i : uint = 0; i<l;i++)
			{
				var p : String = a[i];
				var v : * = SettingsManagerInstance.backend.getWithQuery( p );
				
				var acc : Accessor = new SettingsAccessor( SettingsManagerInstance, p );
				b.push(acc);
			}
			var table : Table = new Table();
			table.model = new DefaultListModel( b );
			table.rowHead = new ListLineRuler( table.view as List );
			table.header.addColumns( 					new TableColumn(_("Property"), "setting", 200, null, null, true, null, formatProperty, false ),					new TableColumn(_("Type"), "type", 50, null, null, true, null, null, false ),
					new TableColumn(_("Value"), "value", 50, null, null, true, null, null, true )
			);
			
			
			var d : Window = new Window();
			d.windowTitle = new WindowTitleBar(_("Settings"), magicIconBuild( showSettingsIcon ), WindowTitleBar.CLOSE_BUTTON + WindowTitleBar.MAXIMIZE_BUTTON );
			d.windowContent = table;
			d.preferredSize = dm(330,280);
			d.resizable = true;
			d.open();
			
			StageUtils.centerX( d, d.width );			StageUtils.centerY( d, d.height );
			
			super.execute(e );
		}
		protected function formatProperty ( s : String ) : String 
		{
			return s.split("#")[1].replace("_",".");
		}
	}
}
