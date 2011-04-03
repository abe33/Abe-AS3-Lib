package abe.com.ponents.factory.ressources 
{
	import abe.com.ponents.utils.ComponentResizer;
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.geom.dm;
	import abe.com.mon.logs.Log;
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.MultiSplitPane;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.layouts.components.splits.Leaf;
	import abe.com.ponents.layouts.components.splits.Split;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ClassCollectionViewer extends MultiSplitPane 
	{
		protected var _collectionsLoader : CollectionsLoader;
		
		protected var _collectionsList : List;		protected var _classesList : List;
		
		protected var _collectionsModel : DefaultListModel;		protected var _classesModel : DefaultListModel;
		protected var _assetPreview : Panel;		protected var _assetPreviewResizer : ComponentResizer;
		protected var _assetDetails : Label;

		public function ClassCollectionViewer ()
		{
			buildChildren( );
		}
		public function get collectionsLoader () : CollectionsLoader { return _collectionsLoader; }
		public function set collectionsLoader (collectionsLoader : CollectionsLoader) : void
		{
			if( _collectionsLoader )
			{
				unregisterFromLoaderEvent( _collectionsLoader );
			}
			_collectionsLoader = collectionsLoader;
			if( _collectionsLoader )
			{
				registerToLoaderEvent( _collectionsLoader );
			}
		}
		
/*-------------------------------------------------------------*
 * 	CONTENT HANDLING
 *-------------------------------------------------------------*/		
		protected function buildChildren () : void 
		{			
			_collectionsModel = new DefaultListModel();
			_collectionsList = new List( _collectionsModel );
			_collectionsList.listCellClass = CollectionListCell;
			_collectionsList.loseSelectionOnFocusOut = false;
			_collectionsList.editEnabled = false;			_collectionsList.dndEnabled = false;
						
			_classesModel = new DefaultListModel();
			_classesList = new List( _classesModel );
			_classesList.listCellClass = AssetListCell;
			//_classesList.listLayout.fixedHeight = false;
			_classesList.loseSelectionOnFocusOut = false;			_classesList.editEnabled = false;			_classesList.dndEnabled = false;
			
			_assetPreview = new Panel();
			_assetPreview.styleKey = "DefaultComponent";			_assetPreview.style.insets = new Insets(0, 0, 0, 5);
			_assetPreview.childrenLayout = new GridLayout( _assetPreview, 1, 1);
			_assetPreviewResizer = new ComponentResizer( _assetPreview, ComponentResizer.BOTTOM_RESIZE_POLICY );
			_assetDetails = new Label(_("No Selection"));
			//_assetDetails.preferredSize = dm(150,300);
			_assetPreview.preferredSize = dm(150,150);
			_assetDetails.wordWrap = true;
			
			var detailsPanel : ScrollablePanel = new ScrollablePanel();
			detailsPanel.childrenLayout = new InlineLayout( detailsPanel, 10, "left", "top", "topToBottom", true );
			detailsPanel.addComponents( _assetPreview, _assetDetails );
			detailsPanel.styleKey = "List";
			detailsPanel.style.insets = new Insets(5);
			
			var sp1 : ScrollPane = new ScrollPane();
			sp1.view = _collectionsList;
			
			var sp2 : ScrollPane = new ScrollPane();
			sp2.view = _classesList;
			
			var sp3 : ScrollPane = new ScrollPane();
			sp3.view = detailsPanel;
			
			sp1.preferredSize = sp2.preferredSize = dm(180,400);
			
			var root : Split = new Split(true);
			var leaf1 : Leaf = new Leaf( sp1, 1 );			var leaf2 : Leaf = new Leaf( sp2, 1 );			var leaf3 : Leaf = new Leaf( sp3, 1 );
			multiSplitLayout.modelRoot = root;	
			multiSplitLayout.addSplitChild( root, leaf1 );					multiSplitLayout.addSplitChild( root, leaf2 );					multiSplitLayout.addSplitChild( root, leaf3 );		
			addComponents( sp1, sp2, sp3 );
			
			_collectionsList.addEventListener(ComponentEvent.SELECTION_CHANGE, collectionsSelectionChange );			_classesList.addEventListener(ComponentEvent.SELECTION_CHANGE, classesSelectionChange );
		}
		protected function buildModels () : void 
		{
			_collectionsList.clearSelection();
			_collectionsModel.removeAllElements();
			
			_classesModel.removeAllElements();
			
			var a : Array = [];
			for each( var c : ClassCollection in _collectionsLoader.collections )
				a.push( c );
			
			_collectionsModel.addMany( 0, a );
		}
/*-------------------------------------------------------------*
 * 	EVENTS HANDLING
 *-------------------------------------------------------------*/	
		protected function registerToLoaderEvent (collectionsLoader : CollectionsLoader) : void 
		{
			collectionsLoader.addEventListener( CommandEvent.COMMAND_END, loadEnd );
			collectionsLoader.addEventListener( CommandEvent.COMMAND_FAIL, loadFail );
		}
		protected function unregisterFromLoaderEvent ( collectionsLoader : CollectionsLoader ) : void 
		{
			collectionsLoader.removeEventListener( CommandEvent.COMMAND_END, loadEnd );			collectionsLoader.removeEventListener( CommandEvent.COMMAND_FAIL, loadFail );
		}
		
		protected function classesSelectionChange (event : ComponentEvent) : void 
		{
			var asset : LibraryAsset = _classesList.selectedValue as LibraryAsset;
			_assetPreview.removeAllComponents();
			if( asset )
			{
				_assetPreview.addComponent( asset.preview );
				_assetDetails.value = asset.description;
			}
			else
			{
				_assetDetails.value = _("No Selection");
			}
		}
		protected function collectionsSelectionChange (event : ComponentEvent) : void 
		{
			var collection : ClassCollection = _collectionsList.selectedValue as ClassCollection;
			
			_classesModel.removeAllElements();
			_classesList.clearSelection();
			if( collection )
				_classesModel.addMany( 0, collection.classes.map(function(o:Class,... args):LibraryAsset
				{ 
					return new LibraryAsset( o, collection.collectionURL );
				}));
		}
		protected function loadEnd (event : CommandEvent) : void 
		{
			buildModels();		}
		protected function loadFail (event : CommandEvent) : void 
		{
			Log.error( "load failed" );
		}
	}
}
