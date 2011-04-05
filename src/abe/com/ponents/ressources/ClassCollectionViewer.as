package abe.com.ponents.ressources 
{
	import abe.com.mands.events.CommandEvent;
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
		static private var ASSET_DETAILS : String = _( "${name}\n<font size='9'><font color='#666666'><i>${path}</i></font>\n\n<font color='#666666'>Extends :</font> ${extends}\n<font color='#666666'>Implements :</font> ${implements}\n${handlerDescription}</font>" );
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
			var map : Function = function( o : *, ... args ) : String
			{
				var s : String = String(o);
				if( s.indexOf("::") != -1 )
					s = s.split("::")[1];
				return _$("<font color='#333333'>$0</font>", s );
			};
			var asset : LibraryAsset = _classesList.selectedValue as LibraryAsset;
			_assetPreview.removeAllComponents();
			if( asset )
			{
				var handler : TypeHandler = getTypeHandler( asset );
				
				var description : String = _$( ASSET_DETAILS,
									  {
										  'name':asset.name, 
										  'path':asset.packagePath,
										  'extends': _$( "$0 &gt; $1", 
										  				 asset.name, asset.extendsClasses.map(map).join(" &gt; ") ),
										  'implements': asset.implementsInterfaces.map(map).join(", "),
										  'handlerDescription':handler.getDescription( asset.type )
									  } );
				_assetPreview.addComponent( handler.getPreview( asset.type ) );
				_assetDetails.value = description;
			}
			else
			{
				_assetDetails.value = _("No Selection");
			}
		}
		static public function getTypeHandler (asset : LibraryAsset) : TypeHandler 
		{
			var cls : String;
			var handlerFound : Boolean = false;
			var handler : TypeHandler;
			
			for each ( cls in asset.extendsClasses )
				if( TYPE_HANDLERS.hasOwnProperty( cls ) )
				{
					handler = ( TYPE_HANDLERS[ cls ] as TypeHandler );
					handlerFound = true;
					break;
				}
			if( !handlerFound )
				for each ( cls in asset.implementsInterfaces )
					if( TYPE_HANDLERS.hasOwnProperty( cls ) )
					{
						handler = ( TYPE_HANDLERS[ cls ] as TypeHandler );
						handlerFound = true;
						break;
					}
			
			if( !handlerFound )			
				handler =  DEFAULT_HANDLER;
			
			return handler;
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
