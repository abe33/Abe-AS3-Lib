package abe.com.ponents.demos.editors
{
	import abe.com.ponents.ressources.actions.OpenRessourceManager;
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.patibility.settings.backends.CookieBackend;
	import abe.com.ponents.actions.ActionManagerInstance;
	import abe.com.ponents.actions.builtin.AboutAction;
	import abe.com.ponents.builder.events.StyleSelectionEvent;
	import abe.com.ponents.builder.models.BuilderCollections;
	import abe.com.ponents.builder.models.StyleSelectionModel;
	import abe.com.ponents.builder.styles.StyleFormPanel;
	import abe.com.ponents.builder.styles.StyleInfosPanel;
	import abe.com.ponents.builder.styles.StylePreviewPanel;
	import abe.com.ponents.builder.styles.StyleStateGrid;
	import abe.com.ponents.builder.styles.StylesTree;
	import abe.com.ponents.builder.styles.StylesTreeHeader;
	import abe.com.ponents.builder.styles.initializePrototypeSerializableSupport;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Dockable;
	import abe.com.ponents.core.SimpleDockable;
	import abe.com.ponents.dnd.DnDDragObjectRenderer;
	import abe.com.ponents.dnd.DnDDropRenderer;
	import abe.com.ponents.dnd.DnDManagerInstance;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.ComponentFactoryEvent;
	import abe.com.ponents.factory.ApplicationMain;
	import abe.com.ponents.factory.ComponentFactoryInstance;
	import abe.com.ponents.factory.ComponentFactoryPreload;
	import abe.com.ponents.forms.FormUtils;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.models.TreeModel;
	import abe.com.ponents.models.TreeNode;
	import abe.com.ponents.ressources.actions.LoadExternalRessource;
	import abe.com.ponents.skinning.ComponentStyle;
	import abe.com.ponents.skinning.SkinManager;
	import abe.com.ponents.skinning.SkinManagerInstance;
	import abe.com.ponents.skinning.decorations.ComponentDecoration;
	import abe.com.ponents.skinning.decorations.NoDecoration;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.sliders.VSlider;

	import flash.events.ContextMenuEvent;
	import flash.events.ProgressEvent;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;

	[SWF(width="1024",height="768", backgroundColor="#3a545c")]
	[Frame(factoryClass="abe.com.ponents.factory.ComponentFactoryPreload")]
	[SettingsBackend(backend="abe.com.patibility.settings.backends.CookieBackend", appName="MissionEditor")]
	public class StyleEditor extends ApplicationMain 
	{
		static public const DEFAULT_DECORATIONS_COLLECTIONS : Array = ["CoreDecorations.swf"];
		
		static private const DEPENDENCIES : Array = [ CookieBackend ];
		
		[Embed(source="../../skinning/icons/components/tree.png")]
		static private var treeIcon : Class;
		[Embed(source="../../skinning/icons/application_form_edit.png")]
		static private var styleFormIcon : Class;
		[Embed(source="../../skinning/icons/brick.png")]
		static private var stylePreviewIcon : Class;
		[Embed(source="../../skinning/icons/table.png")]
		static private var styleInfosIcon : Class;
		
		protected var _selectionModel : StyleSelectionModel;
		protected var _preload : ComponentFactoryPreload;
		
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		static public var instance : StyleEditor;
		
		public function StyleEditor ()
		{
			super( _("Style Editor"), "0.3.0" );
			
			instance = this;
			
			StageUtils.noMenu();
			FormUtils.addNewValueFunction( ComponentDecoration, function( t : Class) : * { return new NoDecoration(); } );
			
			Reflection.WARN_UNWRAPPED_STRING = false;
			
			initializePrototypeSerializableSupport();
			ActionManagerInstance.registerAction( new AboutAction( _appName, 
																   _appVersion, 
																   _("Edit and create styles for components."), 
																   _("AbeLib © 2010 - All rights reserved."), 
																   _("About Style Editor") ), 
												  "about" );
			ActionManagerInstance.registerAction( new LoadExternalRessource( BuilderCollections, _( "Load External Ressources")), "loadExternals");			ActionManagerInstance.registerAction( new OpenRessourceManager( BuilderCollections, _( "Open Ressources Manager")), "manageRessources");
			
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				StageUtils.versionMenuContext.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, ActionManagerInstance.getAction("about").execute );	
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_defaultToolBarSettings = ["newSkin","removeSkin","newStyle","removeStyle"].join("," );
			_defaultDMSPSettings = "H(V(H([200,200]styleTree,V([200,200]statesGrid,[200,200]stylePreview)),styleInfos),styleForm)";
			_defaultMenuBarSettings = "*File(*newSkin,*removeSkin,new*Style,re*moveStyle,|,*loadExternals,m*anageRessources),*Tools(*Logs(clearLogs,saveLogs),*Settings(clearSettings,showSettings)),?(*about)";
			
			_selectionModel = new StyleSelectionModel();
		}
		override public function init (preload : ComponentFactoryPreload) : void 
		{
			_preload = preload;
			_preload.setProgressLabel(_("Loading collections"));
			
			BuilderCollections.addEventListener(CommandEvent.COMMAND_END, collectionsLoaded );			BuilderCollections.addEventListener(ProgressEvent.PROGRESS, collectionProgress );

			var collections : Array = SettingsManagerInstance.get( this, "collections", DEFAULT_DECORATIONS_COLLECTIONS );
			var l : uint = collections.length;
			
			for( var i : uint = 0; i<l; i++ )
				BuilderCollections.loadCollection( collections[ i ] );
			
			BuilderCollections.execute();
		}
		protected function collectionProgress (event : ProgressEvent) : void 
		{
			_preload.setProgressValue( Math.floor( event.bytesLoaded / event.bytesTotal * 100 ) );
		}
		protected function collectionsLoaded (event : CommandEvent) : void 
		{	
			BuilderCollections.removeEventListener(CommandEvent.COMMAND_END, collectionsLoaded );
			BuilderCollections.removeEventListener(ProgressEvent.PROGRESS, collectionProgress );
			
			/*FDT_IGNORE*/ CONFIG::RELEASE { _init(); } 
			CONFIG::DEBUG { /*FDT_IGNORE*/
			setTimeout( _init, 1000 ); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		protected function _init() : void
		{
			initComponents();
			ComponentFactoryInstance.group("movables"
								   ).build( StyleStateGrid, 
								   			"styleStateGrid", 
								   			null, 
								   			{ 
								   				'enabled':false,
								   				'model':_selectionModel
								   			}, 
								   			function( c : StyleStateGrid, ctx : Object ) : void 
								   			{
								   				var d : Dockable = c.dockable;
								   				_dockables[d.id] = d;
								   			}
								   ).build( StylesTree, 
								   			"styleTree"
								   ).build( StylesTreeHeader, 
								   			"styleTreeHeader", 
								   			function( ctx : Object ) : Array
								   			{
								   				return [ctx["styleTree"]];
								   			}
								   ).build( StylePreviewPanel, 
								   			"stylePreview"
								   ).build( StyleFormPanel, 
								   			"styleForm" 
								   ).build( StyleInfosPanel, 
								   			"styleInfos"
								   			
								   ).group("containers"
								   ).build( ScrollPane, 
								   			"styleTreePane", 
								   			null, 
											null, 
											function( c : ScrollPane, ctx : Object ) : void
											{
												var stylesTree : StylesTree = ctx["styleTree"] as StylesTree;
												stylesTree.itemFormatingFunction = function( v : * ) : String
												{
													return v is ComponentStyle ? ( v as ComponentStyle ).styleName : String(v);
												};
												stylesTree.model = buildStylesTreeModel();
												c.view = stylesTree;
												c.colHead = ctx["styleTreeHeader"];
												_dockables["styleTree"] = new SimpleDockable(c, 
																							 "styleTree", 
																							 _("Styles"), 
																							 magicIconBuild( treeIcon ) );
												
												_dockables["stylePreview"] = new SimpleDockable(ctx["stylePreview"], 
																								"stylePreview", 
																								_("Preview"), 
																								magicIconBuild( stylePreviewIcon ) );
												_dockables["styleForm"] = new SimpleDockable(ctx["styleForm"], 
																								"styleForm", 
																								_("Edit States"), 
																								magicIconBuild( styleFormIcon ) );
												_dockables["styleInfos"] = new SimpleDockable(ctx["styleInfos"], 
																								"styleInfos", 
																								_("Details"), 
																								magicIconBuild( styleInfosIcon ) );	
												
												_selectionModel.addEventListener( StyleSelectionEvent.SKIN_SELECT, ctx["styleInfos"].skinSelectionChange );
												_selectionModel.addEventListener( StyleSelectionEvent.STYLE_SELECT, ctx["styleInfos"].styleSelectionChange );
												_selectionModel.addEventListener( StyleSelectionEvent.STYLE_SELECT, ctx["stylePreview"].styleSelectionChange );
												_selectionModel.addEventListener( StyleSelectionEvent.STATES_SELECT, ctx["styleForm"].statesSelectionChange );
												
												stylesTree.addEventListener(ComponentEvent.SELECTION_CHANGE, treeSelectionChange );
											}, 
											null);
			
			super.init( _preload );
			fireProceedBuild();
		}
		
		protected function treeSelectionChange (event : ComponentEvent) : void 
		{
			var stylesTree : StylesTree = event.target as StylesTree;
			var node : TreeNode = stylesTree.selectedValue;
			if( node )
			{
				var v : * = stylesTree.selectedValue.userObject;
				
				if( v is ComponentStyle )
					_selectionModel.selectedStyle = v as ComponentStyle;
				else
				{
					var skin : Object = SkinManagerInstance.getSkin( v );
					_selectionModel.selectedSkin = skin;
				}
			}
			else
			{
				_selectionModel.selectedSkin = null;
				_selectionModel.selectedStyle = null;
			}
			
		}
		override protected function buildComplete (e : ComponentFactoryEvent) : void 
		{			
			super.buildComplete( e );
		}
		protected function initComponents () : void
		{
			var c : Component;
			/*
			c = new ScrollBar();
			c = new ProgressBar(new DefaultBoundedRangeModel());
			c = new TextInput();			c = new TextArea();			c = new Button();			c = new RadioButton();
			c = new Dialog("foo",0,new Panel());*/
			c = new VSlider(new DefaultBoundedRangeModel());			//c = new HSlider(new DefaultBoundedRangeModel());
		}
		protected function buildStylesTreeModel () : TreeModel
		{
			var root : TreeNode = new TreeNode( "Root", true );

			var m : TreeModel = new TreeModel(root);
			root.expanded = true;
			m.expandableRoot = false;
			m.showRoot = false;

			var defaultSkin : TreeNode = new TreeNode( SkinManager.DEFAULT_SKIN_NAME, true );

			var a : Object = SkinManagerInstance.defaultSkin;
			var o : Object = {};
			
			for( var i : String in a )
			{
				if( i != "name" )
					buildNodeForStyle( SkinManagerInstance.getStyle( i ), o );
			}
			defaultSkin.add( o["DefaultComponent"] );
			root.add(defaultSkin);
			root.sort( TreeNode.sortNodeAlphabetically );
			
			return m;
		}

		protected function buildNodeForStyle ( style : ComponentStyle, map : Object ) : TreeNode
		{
			var n : TreeNode;
			try
			{
				var n2 : TreeNode;
				if( !map.hasOwnProperty( style.styleName ) )
				{
					if( style.defaultStyleKey != "" && !map.hasOwnProperty( style.defaultStyleKey ) )
					{
						n = buildNodeForStyle( SkinManagerInstance.getStyle( style.defaultStyleKey ), map );
						n2 = new TreeNode(style, true);
						n.add( n2 );
						map[ style.styleName ] = n2;
						n = n2;
					}
					else if( style.defaultStyleKey != "" &&
							 map.hasOwnProperty( style.defaultStyleKey )  )
					{
						n = map[ style.defaultStyleKey ];
						n2 = new TreeNode(style, true);
						n.add( n2 );
						map[ style.styleName ] = n2;
						n = n2;
					}
					else
					{
						n = new TreeNode(style, true);
						map[ style.styleName ] = n;
					}
				}
			}
			catch( e : Error )
			{
				Log.error( _$(_("Can't build the tree node for style '$0' : $1" ), style, Capabilities.isDebugger ? e.getStackTrace() : e.message ) );
			}
			return n;
		}
	}
}
