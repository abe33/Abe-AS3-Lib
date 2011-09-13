package abe.com.ponents.ressources 
{
    import abe.com.mon.geom.dm;
    import abe.com.mon.logs.Log;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
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
    import abe.com.ponents.ressources.handlers.DefaultHandler;
    import abe.com.ponents.ressources.handlers.DisplayObjectHandler;
    import abe.com.ponents.ressources.handlers.FontHandler;
    import abe.com.ponents.ressources.handlers.HandlerUtils;
    import abe.com.ponents.ressources.handlers.MovieClipHandler;
    import abe.com.ponents.ressources.handlers.TypeHandler;
    import abe.com.ponents.text.Label;
    import abe.com.ponents.utils.ComponentResizer;
    import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ClassCollectionViewer extends MultiSplitPane 
	{
		static public const DEFAULT_HANDLER : DefaultHandler = new DefaultHandler();
		static public const TYPE_HANDLERS : Object = {
			'flash.display::DisplayObject':new DisplayObjectHandler(),
			'flash.display::MovieClip':new MovieClipHandler(),
			'flash.text::Font':new FontHandler()
		};
		
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
				buildModels();
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
			_assetPreview.preferredSize = dm(150,200);
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
			var map : Function = function( o : *, ... args ) : String
			{
				var s : String = String(o);
				if( s.indexOf("::") != -1 )
					s = s.split("::")[1];
				return s;
			};
			var asset : LibraryAsset = _classesList.selectedValue as LibraryAsset;
			_assetPreview.removeAllComponents();
			if( asset )
			{
				var handlers : Array = getTypeHandlers( asset );				var handler : TypeHandler = handlers[0];
				
				var description : String = _$( "<font size='16'>$0</font>\n<font size='9' color='#666666'>$1</font>\n\n$2\n\n$3", 
												asset.name,
												asset.packagePath,
												HandlerUtils.getFields( {
													  'Extends': _$( "$0 &gt; $1", 
													  				 asset.name, asset.extendsClasses.map(map).join(" &gt; ") ),
													  'Implements': asset.implementsInterfaces.map(map).join(", ")
												}),
												getAssetDescription( asset, handlers ) );
				_assetPreview.addComponent( handler.getPreview( asset.type ) );
				_assetDetails.value = description;
			}
			else
			{
				_assetDetails.value = _("No Selection");
			}
		}
		protected function getAssetDescription ( asset : LibraryAsset, handlers : Array ) : String 
		{
			var s : String = "";
			
			if( handlers.length == 1 && handlers[0] == DEFAULT_HANDLER )
				return s;
			
			for each( var handler : TypeHandler in handlers )
				s += getHandlerDescription( asset, handler );
			
			return s;
		}
		protected function getHandlerDescription (asset : LibraryAsset, handler : TypeHandler) : String 
		{
			return _$( "<font size='12'>$0</font>\n$1\n\n", handler.title, handler.getDescription(asset.type) );
		}
		static public function getTypeHandlers (asset : LibraryAsset) : Array 
		{
			var cls : String;
			var handlerFound : Boolean = false;
			var a: Array = [];
			for each ( cls in asset.extendsClasses )
				if( TYPE_HANDLERS.hasOwnProperty( cls ) )
				{
					a.push( TYPE_HANDLERS[ cls ] );
				}
			if( !handlerFound )
				for each ( cls in asset.implementsInterfaces )
					if( TYPE_HANDLERS.hasOwnProperty( cls ) )
					{
						a.push( TYPE_HANDLERS[ cls ] );
					}
			
			if( a.length == 0 )			
				a = [DEFAULT_HANDLER];
			
			return a;
		}
		protected function collectionsSelectionChange (event : ComponentEvent) : void 
		{
			var collection : ClassCollection = _collectionsList.selectedValue as ClassCollection;
			
			_classesModel.removeAllElements();
			_classesList.clearSelection();
			if( collection )
				_classesModel.addMany( 0, collection.classes );
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
