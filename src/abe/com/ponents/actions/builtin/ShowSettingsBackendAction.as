package abe.com.ponents.actions.builtin 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.dm;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.StageUtils;
    import abe.com.patibility.accessors.Accessor;
    import abe.com.patibility.accessors.SettingsAccessor;
    import abe.com.patibility.lang._;
    import abe.com.patibility.settings.SettingsManagerInstance;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.actions.ProxyAction;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.Window;
    import abe.com.ponents.containers.WindowTitleBar;
    import abe.com.ponents.core.AbstractComponent;
    import abe.com.ponents.layouts.components.BoxSettings;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.layouts.components.VBoxLayout;
    import abe.com.ponents.lists.List;
    import abe.com.ponents.lists.ListLineRuler;
    import abe.com.ponents.models.DefaultListModel;
    import abe.com.ponents.skinning.decorations.SimpleBorders;
    import abe.com.ponents.skinning.decorations.StripFill;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.tables.Table;
    import abe.com.ponents.tables.TableColumn;
    import abe.com.ponents.text.Label;
    import abe.com.ponents.utils.Corners;
    import abe.com.ponents.utils.Insets;

    import flash.text.TextFormat;
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
		override public function execute( ... args ) : void 
		{
			var a : Array =  SettingsManagerInstance.settingsList;
			var b : Array = [];
			var l : uint = a.length;
			for( var i : uint = 0; i < l;i++)
			{
				var p : String = a[i];
				var acc : Accessor = new SettingsAccessor( SettingsManagerInstance, p );
				b.push(acc);
			}
			
			var warning : Label = new Label(_("<b>Warning !</b>\n<p>Changing the value in the settings can broke the application, be really cautious when you modify a setting.</p>"));
			//warning.autoSize = "left";
			warning.wordWrap = true;
			warning.style.background = new StripFill([Color.Gold,Color.Khaki], [5,5], 45);
			warning.style.foreground = new SimpleBorders( Color.Orange );
			warning.style.corners = new Corners(4);
			warning.style.insets = new Insets(4);
			warning.style.format = new TextFormat( "Verdana", 10, 0, false, false, false, null, null, "center");
			
			var table : Table = new Table();
			table.upperLeft = new AbstractComponent();
			table.upperLeft.styleKey = "TableHeader";
			table.upperRight = new AbstractComponent();
			table.upperRight.styleKey = "TableHeader";
			
			table.model = new DefaultListModel( b );
			table.rowHead = new ListLineRuler( table.view as List );
			table.header.addColumns( 
					new TableColumn(_("Property"), "setting", 200, null, null, true, null, formatProperty, false ),
					new TableColumn(_("Type"), "type", 50, null, null, true, null, null, false ),
					new TableColumn(_("Value"), "value", 50, null, null, true, null, formatValue, true )
			);
			
			var panel : Panel = new Panel();
			panel.childrenLayout = new VBoxLayout( panel, 3, 
												   new BoxSettings(70, "left", "top", warning, true, true, false ),
												   new BoxSettings(0, "left", "top", table, true, true, true )
												  );
			
			panel.addComponents( table, warning );
			
			
			var d : Window = new Window();

			var closePanel : Panel = new Panel( );
			closePanel.childrenLayout = new InlineLayout(closePanel, 3, "right" );
			closePanel.addComponent( new Button( new ProxyAction(d.close, _("Close")) ) );
			closePanel.style.insets = new Insets(4,0,4,4);
			
			d.windowTitle = new WindowTitleBar(_("Settings"), magicIconBuild( showSettingsIcon ), WindowTitleBar.CLOSE_BUTTON + WindowTitleBar.MAXIMIZE_BUTTON );
			d.windowContent = panel;
			d.windowStatus = closePanel;
			d.preferredSize = dm(330,280);
			d.resizable = true;
			d.open();
			
			StageUtils.centerX( d, d.width );
			StageUtils.centerY( d, d.height );
			
			super.execute.apply( this, args );
		}
		protected function formatProperty ( s : String ) : String 
		{
			if( s.indexOf("#") != -1 )
				return s.split("#")[1].replace("_",".");
			else 
				return s;
		}
		protected function formatValue ( v : * ) : String
		{
			return String( v ).replace( new RegExp("\n","g"), ", ");
		}
	}
}
