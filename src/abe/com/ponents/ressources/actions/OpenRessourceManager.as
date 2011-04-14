package abe.com.ponents.ressources.actions 
{
	import abe.com.mands.load.URLLoaderEntry;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.StageUtils;
	import abe.com.mon.utils.url;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.containers.Window;
	import abe.com.ponents.containers.WindowTitleBar;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.ressources.ClassCollection;
	import abe.com.ponents.ressources.ClassCollectionViewer;
	import abe.com.ponents.ressources.CollectionsLoader;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.utils.Insets;

	import com.kode80.swf.SWF;

	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * @author cedric
	 */
	public class OpenRessourceManager extends AbstractAction 
	{
		[Embed(source="../../skinning/icons/package_add.png")]
		static private const packageIcon : Class;
		
		static protected var _viewer : ClassCollectionViewer;
		static protected var _window : Window;
		
		protected var _collectionsLoader : CollectionsLoader;

		public function OpenRessourceManager ( collectionsLoader : CollectionsLoader,
											   name : String = "", 
											   icon : Icon = null, 
											   longDescription : String = null, 
											   accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			_collectionsLoader = collectionsLoader;
		}
		override public function execute( ... args ) : void 
		{
			if( !_window )
				buildComponents();
			
			_viewer.collectionsLoader = _collectionsLoader;
			
			StageUtils.centerX( _window, _window.width );			StageUtils.centerY( _window, _window.height );
			_window.open();
			
			fireCommandEnd();
		}
		protected function loadMe() : void
		{
			var request : URLRequest = url(StageUtils.stage.loaderInfo.url);
			var entry : URLLoaderEntry = new URLLoaderEntry( request, function( entry : URLLoaderEntry ):void {
					
				var bytes : ByteArray  = entry.loader.data;
				bytes.position = 0;
				var swf : SWF = new SWF();
				swf.readFrom(bytes);
				
				var col : ClassCollection = CollectionsLoader.getCollectionFromSWF( swf, request.url, StageUtils.root.loaderInfo.loader );
				_collectionsLoader.collections.push( col );
				_collectionsLoader.fireCommandEnd();
			});
			entry.loader.dataFormat = URLLoaderDataFormat.BINARY;
			entry.execute();
		}
		protected function buildComponents () : void 
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout( p, 3, "right", "center", "leftToRight" );
			p.style.insets = new Insets(5, 0, 5, 5 );
			
			var p2 : Panel = new Panel();
			var bl : BorderLayout = new BorderLayout(p2);
			p2.childrenLayout = bl;
			
			var tb : ToolBar = new ToolBar();
			tb.addComponent( new Button( new LoadExternalRessource( _collectionsLoader, _("Add collection"), magicIconBuild(packageIcon) ) ) );			tb.addComponent( new Button( new ProxyAction( loadMe, "Dump root" ) ) );
						
			_viewer = new ClassCollectionViewer();
			_window = new Window();
			_window.resizable = true;
			
			bl.north = tb;
			bl.center = _viewer;
			
			p.addComponent( new Button(new ProxyAction( _window.close, _("Close"))) );
			p2.addComponents( _viewer, tb );
			
			_window.windowStatus = p;
			_window.windowContent = p2;
			_window.windowTitle = new WindowTitleBar(_("Ressources Manager"), null, WindowTitleBar.CLOSE_BUTTON + WindowTitleBar.MAXIMIZE_BUTTON );
		}
	}
}
