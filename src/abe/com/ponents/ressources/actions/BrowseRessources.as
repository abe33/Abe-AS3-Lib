package abe.com.ponents.ressources.actions 
{
	import abe.com.mon.geom.dm;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.ressources.AssetListCell;
	import abe.com.ponents.ressources.CollectionsLoader;
	import abe.com.ponents.ressources.LibraryAsset;
	import abe.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class BrowseRessources extends AbstractAction 
	{
		protected var _collectionsLoader : CollectionsLoader;
		protected var _ressourceType : String;
		
		static protected var _dialog : Dialog;
		static protected var _list : List;
		
		protected var _ressource : LibraryAsset;

		public function BrowseRessources (  collectionsLoader : CollectionsLoader,
											ressourceType : String = null,
											name : String = "", 
											icon : Icon = null, 
											longDescription : String = null, 
											accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			_collectionsLoader = collectionsLoader;
			_ressourceType = ressourceType;
		}
		override public function execute( ... args ) : void 
		{
			if( !_dialog )
				buildDialog();
			
			var cls : Array;
			if( _ressourceType )
				cls = _collectionsLoader.getAssetsByType( _ressourceType );
			else
				cls = _collectionsLoader.getAllAssets();
			
			_list.model = new DefaultListModel( cls );
			_dialog.dialogResponded.addOnce( onResults );
			_dialog.open( Dialog.CLOSE_ON_RESULT );
				
			super.execute( e );
		}
		protected function onResults ( d : Dialog, result : uint ) : void 
		{
			if( result == Dialog.RESULTS_OK )
			{
				_ressource = _list.selectedValue;
			}
			_commandEnded.dispatch( this );
		}
		protected function buildDialog () : void 
		{
			_list = new List();
			_list.listCellClass = AssetListCell;
			_list.dndEnabled = false;
			_list.loseSelectionOnFocusOut = false;
			_list.editEnabled = false;
			
			var tb : ToolBar = new ToolBar(ButtonDisplayModes.TEXT_AND_ICON , false );
			tb.addAction( new LoadExternalRessource( _collectionsLoader, _("Load")));
			tb.addAction( new OpenRessourceManager( _collectionsLoader, _("Open Manager")));
			
			var scp : ScrollPane = new ScrollPane();
			scp.view = _list;
			scp.colHead = tb;
			scp.preferredSize = dm(250,200);
			
			_dialog = new Dialog( _("Browse ressources"), Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON, scp, Dialog.OK_BUTTON );
		}
		public function get ressource () : LibraryAsset { return _ressource; }
		public function set ressource (ressource : LibraryAsset) : void { _ressource = ressource; }
	}
}
