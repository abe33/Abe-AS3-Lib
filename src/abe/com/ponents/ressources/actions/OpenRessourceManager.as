package abe.com.ponents.ressources.actions 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.utils.Insets;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.Window;
	import abe.com.ponents.containers.WindowTitleBar;
	import abe.com.ponents.ressources.ClassCollectionViewer;
	import abe.com.ponents.ressources.CollectionsLoader;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class OpenRessourceManager extends AbstractAction 
	{
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
		override public function execute (e : Event = null) : void 
		{
			if( !_window )
				buildComponents();
			
			_viewer.collectionsLoader = _collectionsLoader;
			
			StageUtils.centerX( _window, _window.width );			StageUtils.centerY( _window, _window.height );
			_window.open();
			
			
			fireCommandEnd();
		}
		protected function buildComponents () : void 
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout( p, 3, "right", "center", "leftToRight" );
			p.style.insets = new Insets(5, 0, 5, 5 );
			
			_viewer = new ClassCollectionViewer();
			_window = new Window();
			p.addComponent( new Button(new ProxyAction( _window.close, _("Close"))) );
			_window.resizable = true;
			
			_window.windowTitle = new WindowTitleBar(_("Ressources Manager"), null, WindowTitleBar.CLOSE_BUTTON + WindowTitleBar.MAXIMIZE_BUTTON );
			_window.windowStatus = p;
			_window.windowContent = _viewer;
		}
	}
}
