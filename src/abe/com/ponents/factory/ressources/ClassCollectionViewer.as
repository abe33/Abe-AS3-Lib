package abe.com.ponents.factory.ressources 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.logs.Log;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.models.DefaultListModel;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author cedric
	 */
	public class ClassCollectionViewer extends Panel 
	{
		protected var _collectionsLoader : CollectionsLoader;
		
		protected var _collectionsList : List;		protected var _classesList : List;
		
		protected var _collectionsModel : DefaultListModel;		protected var _classesModel : DefaultListModel;
		
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
						
			_classesModel = new DefaultListModel();
			_classesList = new List( _classesModel );
			_classesList.listCellClass = AssetListCell;
			//_classesList.listLayout.fixedHeight = false;
			_classesList.loseSelectionOnFocusOut = false;
			
			var sp1 : ScrollPane = new ScrollPane();
			sp1.view = _collectionsList;
			
			var sp2 : ScrollPane = new ScrollPane();
			sp2.view = _classesList;
			
			childrenLayout = new GridLayout(this, 1, 3, 3, 0);
			addComponents( sp1, sp2 );
			
			_collectionsList.addEventListener(ComponentEvent.SELECTION_CHANGE, collectionsSelectionChange );
		}
		protected function buildModels () : void 
		{
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
		
		protected function collectionsSelectionChange (event : ComponentEvent) : void 
		{
			var collection : ClassCollection = _collectionsList.selectedValue as ClassCollection;
			
			_classesModel.removeAllElements();
			//_classesList.listLayout.clearEstimatedSize();
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
