package aesia.com.ponents.builder.styles
{
	import aesia.com.ponents.scrollbars.ScrollBar;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Cookie;
	import aesia.com.mon.utils.Delegate;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.buttons.CheckBox;
	import aesia.com.ponents.completion.InputMemory;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.containers.MultiSplitPane;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.SplitPane;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.DialogEvent;
	import aesia.com.ponents.events.FormEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.forms.FormField;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.MultiTargetFormManager;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.layouts.components.VBoxLayout;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.layouts.components.splits.Split;
	import aesia.com.ponents.menus.ComboBox;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.models.TreeModel;
	import aesia.com.ponents.models.TreeNode;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.progress.ProgressBar;
	import aesia.com.ponents.skinning.ComponentStateStyle;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManager;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.skinning.decorations.SimpleBorders;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.sliders.VSlider;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.trees.TreeHeader;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.SettingsMemoryChannels;

	/**
	 * @author cedric
	 */
	[Skinable(skin="NoDecorationComponent")]
	public class StyleEditorPane extends Panel
	{
		[Embed(source="../../skinning/icons/error.png")]
		static private var sharedTipClass : Class;
		[Embed(source="../../skinning/icons/add.png")]
		static private var add : Class;
		[Embed(source="../../skinning/icons/delete.png")]
		static private var remove : Class;

		protected var _tree : StylesTree;
		protected var _pane : MultiSplitPane;
		protected var _preview : Panel;		protected var _previewPanel : Panel;
		protected var _previewToolBar : ToolBar;
		protected var _grid : StyleStateGrid;
		protected var _formObject : FormObject;
		protected var _formPane : Component;
		protected var _scrollPane : ScrollPane;
		protected var _formManager : MultiTargetFormManager;
		protected var _previewEnabled : CheckBox;
		protected var _previewSelected : CheckBox;
		protected var _styleInfosPanel : Panel;
		protected var _styleName : Label;
		protected var _styleExtends : Label;
		protected var _styleOwner : Label;
		protected var _searchInput : TextInput;
		protected var _customStylePropertyManager : SimpleFormManager;
		protected var _styleCustomProperties : ScrollPane;
		protected var _styleCustomPropertiesToolbar : ToolBar;
		protected var _styleNewCustomPropertyName : TextInput;
		protected var _styleNewCustomPropertyType : ComboBox;
		protected var _styleNewCustomProperty : Button;

		public function StyleEditorPane ()
		{
			var l : BorderLayout = new BorderLayout(this,true);
			_childrenLayout = l;
			super();

			initComponents();
			buildChildren();
			buildStylesTreeModel();

			var toolbar : ToolBar = new ToolBar(ButtonDisplayModes.ICON_ONLY, false );
			var splitPane : SplitPane = new SplitPane( SplitPane.HORIZONTAL_SPLIT );
			splitPane.oneTouchExpandFirstComponent = false;
			splitPane.dividerLocation = 200;

			toolbar.addComponent( new Button( _tree.getCreateNewSkinAction() ) );
			toolbar.addComponent( new Button( _tree.getRemoveSkinAction() ) );
			toolbar.addComponent( new Button( _tree.getCreateNewStyleAction() ) );			toolbar.addComponent( new Button( _tree.getRemoveStyleAction() ) );

			l.north = toolbar;
			l.center = splitPane;
			addComponent( toolbar );
			addComponent( splitPane );

			splitPane.firstComponent = _scrollPane;
			splitPane.secondComponent = _pane;
		}

		protected function initComponents () : void
		{
			var sc : ScrollBar = new ScrollBar();
			var p : ProgressBar = new ProgressBar(new DefaultBoundedRangeModel());
			var t : TextInput = new TextInput();			var w : Dialog = new Dialog("foo",0,new Panel());
			var v : VSlider = new VSlider(new DefaultBoundedRangeModel());
		}

		protected function buildStylesTreeModel () : void
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
			_tree.model = m;
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
				Log.error( "Impossible de construire un noeud pour le style "+ style + "\n" + e.getStackTrace() );
			}
			return n;
		}

		protected function buildChildren () : void
		{

// STYLE TREE

			_scrollPane = new ScrollPane();

			_tree = new StylesTree();
			_tree.itemFormatingFunction = function( v : * ) : String
			{
				return v is ComponentStyle ? ( v as ComponentStyle ).styleName : String(v);
			};
			//_tree.editEnabled = false;
			_tree.dndEnabled = false;
			_tree.allowMultiSelection = false;
			_tree.loseSelectionOnFocusOut = false;
			_tree.addEventListener(ComponentEvent.SELECTION_CHANGE, treeSelectionChange );

			var header : TreeHeader = new TreeHeader(_tree, ButtonDisplayModes.ICON_ONLY );
			header.dndEnabled = false;
			_searchInput = new TextInput(0,false,"styleSearch", false);
			_searchInput.tooltip = _("Search in the tree structure.");
			header.addSeparator();
			header.addComponent( _searchInput );
			_searchInput.addEventListener(ComponentEvent.DATA_CHANGE, searchDataChange );

			_scrollPane.view = _tree;
			_scrollPane.colHead = header;

// FORM PANEL

			_formObject = FormUtils.createFormFromMetas( new ComponentStateStyle() );
			_formPane = FieldSetFormRenderer.instance.render( _formObject );
			_formPane.preferredWidth = 400;
			_formPane.style.setForAllStates("foreground", new SimpleBorders( Color.DimGray ) )
						   .setForAllStates("insets", new Insets(5));
			_formManager = new MultiTargetFormManager( [], _formObject );
			_formManager.addEventListener(PropertyEvent.PROPERTY_CHANGE, formPropertyChange );
			_formManager.addEventListener(FormEvent.SHARED_FIELD, sharedFieldsFound );
			_formManager.preventModificationOfSharedValues = isValueSharedByOtherStates;

			setupForm( _formObject );

// STYLE STATE GRID

			_grid = new StyleStateGrid( );
			_grid.addEventListener(ComponentEvent.SELECTION_CHANGE, gridSelectionChange );
			_grid.enabled = false;

// PREVIEW PANEL

			_previewPanel = new Panel();
			_previewPanel.styleKey = "DefaultComponent";

			var l : BorderLayout = new BorderLayout( _previewPanel, true );
			_previewPanel.childrenLayout = l;

			_preview = new Panel();
			_preview.childrenLayout = new InlineLayout( _preview );
			_preview.preferredSize = new Dimension(100, 75);
			_preview.allowFocus = false;

			_previewToolBar = new ToolBar();

			_previewEnabled = new CheckBox( _("Enabled") );
			_previewEnabled.value = true;
			_previewEnabled.addEventListener( ComponentEvent.DATA_CHANGE, previewEnabledChange );			_previewSelected = new CheckBox( _("Selected") );
			_previewSelected.addEventListener( ComponentEvent.DATA_CHANGE, previewSelectedChange );
			_previewSelected.enabled = false;

			_previewToolBar.addComponent(_previewEnabled);			_previewToolBar.addComponent(_previewSelected);

			_previewPanel.addComponent(_previewToolBar);
			l.north = _previewToolBar;

			_previewPanel.addComponent(_preview);
			l.center = _preview;

// STYLE INFO PANEL

			_styleInfosPanel = new Panel();
			_styleInfosPanel.styleKey = "DefaultComponent";			_styleInfosPanel.preferredSize = new Dimension(100, 250);
			_styleInfosPanel.style.setForAllStates("insets", new Insets(5));
			//_styleInfosPanel.childrenLayout = new InlineLayout( _styleInfosPanel, 3, "left", "top", "topToBottom" );
			_styleName = new Label(_$(_("Style Name : <b>$0</b>"),_("No Style")));			_styleExtends = new Label(_$(_("Style Extends : <b>$0</b>"), _("No Style ")));
			_styleOwner = new Label(_$(_("Style owned by : <b>$0</b>"),_("No Skin")));

			_styleCustomProperties = new ScrollPane();
			_styleCustomProperties.preferredSize = dm(200,200);

			_styleCustomPropertiesToolbar = new ToolBar(ButtonDisplayModes.ICON_ONLY, false, 3);

			_styleNewCustomPropertyName = new TextInput(0,false,"styleNewCustomPropertyName",false);			_styleNewCustomProperty = new Button(new ProxyAction(createNewCustomProperty, _("Add new property"), magicIconBuild(add)));
			_styleNewCustomPropertyType = new ComboBox(
														String,
														int,
														uint,
														Boolean,
														Array,
														Number,
														Color,
														//Gradient,
														//Palette,
														Icon );
			_styleNewCustomPropertyType.itemFormatingFunction = Reflection.extractClassName;
			_styleCustomPropertiesToolbar.addComponent( _styleNewCustomPropertyName );
			_styleCustomPropertiesToolbar.addComponent( _styleNewCustomPropertyType );
			_styleCustomPropertiesToolbar.addComponent( _styleNewCustomProperty );

			_styleCustomProperties.colHead = _styleCustomPropertiesToolbar;
			_styleCustomPropertiesToolbar.enabled = false;

			_styleInfosPanel.childrenLayout = new VBoxLayout( _styleInfosPanel, 3,					new BoxSettings(20, "left", "top", _styleName, true, false, false ),					new BoxSettings(20, "left", "top", _styleExtends, true, false, false ),					new BoxSettings(20, "left", "top", _styleOwner, true, false, false ),
					new BoxSettings(100, "left", "top", _styleCustomProperties, true, true, true )
			);

			_styleInfosPanel.addComponent( _styleName );
			_styleInfosPanel.addComponent( _styleExtends );			_styleInfosPanel.addComponent( _styleOwner );			_styleInfosPanel.addComponent( _styleCustomProperties );

			// MULTIPANE CONSTRUCT
			var model : Split = new Split(false);
			var row : Split = new Split(true);
			var col : Split = new Split(false);

			_pane = new MultiSplitPane();
			_pane.multiSplitLayout.modelRoot = model;
			_pane.multiSplitLayout.addSplitChild(col, new Leaf(_grid) );			_pane.multiSplitLayout.addSplitChild(col, new Leaf(_styleInfosPanel) );
			_pane.multiSplitLayout.addSplitChild(col, new Leaf(_previewPanel) );
			_pane.multiSplitLayout.addSplitChild(row, col);
			_pane.multiSplitLayout.addSplitChild(row, new Leaf( _formPane, 5 ) );
			_pane.multiSplitLayout.addSplitChild(model, row );

			_pane.addComponent( _grid );			_pane.addComponent( _styleInfosPanel );
			_pane.addComponent( _previewPanel );
			_pane.addComponent( _formPane );

			_grid.alwaysValidateRoot = true;
			_styleInfosPanel.alwaysValidateRoot = true;
			_previewPanel.alwaysValidateRoot = true;
			(_formPane as AbstractContainer).alwaysValidateRoot = true;
			_scrollPane.alwaysValidateRoot = true;

			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				var lv : LogView = new LogView();
				lv.logsLimit = 500;
				_pane.addComponent(lv);
				_pane.multiSplitLayout.addSplitChild( model, new Leaf(lv) );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		protected function createNewCustomProperty () : void
		{
			var n : String = _styleNewCustomPropertyName.value;
			var t : Class = _styleNewCustomPropertyType.value;

			if( n && n != "" )
			{
				_grid.targetStyle.setCustomProperty( n, FormUtils.getNewValue(t) );
				treeSelectionChange(null);

				( _styleNewCustomPropertyName.autoComplete as InputMemory ).registerCurrent();
				_styleNewCustomPropertyName.value = "";
			}
		}

		protected function deleteCustomProperty ( f : FormField, fo : FormObject ) : void
		{
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
				var cookie : Cookie = new Cookie( SettingsMemoryChannels.DIALOGS );
				if( cookie.warningDeleteCustomStyleProperty )
				{
					resultDeleteCustomProperty( null, f, fo );
					return;
				}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			var dial : WarningDialog = new WarningDialog( new Label(_("You're attempting to delete a custom property on this style.\nDeleting a custom property on a style may result\nin runtime error if the deleted property was mandatory\nfor the component which receive the style.\nAre you sure you want to continue ?")) ,
														  "warningDeleteCustomStyleProperty",
														  SettingsMemoryChannels.DIALOGS,
														  Dialog.YES_BUTTON + Dialog.NO_BUTTON,
														  Dialog.YES_BUTTON );

			dial.addEventListener( DialogEvent.DIALOG_RESULT , Delegate.create( resultDeleteCustomProperty , f, fo ), false, 0, true );
			dial.open( Dialog.CLOSE_ON_RESULT );
		}

		protected function resultDeleteCustomProperty ( e : DialogEvent = null,  f : FormField = null, fo : FormObject = null ) : void
		{
			if( e && e.result != Dialog.RESULTS_YES )
				return;

			fo.fields.splice( fo.fields.indexOf(f), 1 );
			f.component.parentContainer.parentContainer.removeComponent( f.component.parentContainer);
			delete fo.target[ f.memberName ];
		}

		protected function setupForm (formObject : FormObject) : void
		{
			for each( var f : FormField in formObject.fields )
			{
				var c : Component = f.component;
				var p : Panel = c.parentContainer as Panel;
				var l : HBoxLayout = p.childrenLayout as HBoxLayout;
				var sharedTip : Icon = magicIconBuild(sharedTipClass );

				l.boxes.push(new BoxSettings(20, "center", "center", sharedTip, false, false, false ));
				sharedTip.visible = false;
				p.addComponent( sharedTip );
			}
		}

		protected function setupRemovePropertyForm (formObject : FormObject) : void
		{
			for each( var f : FormField in formObject.fields )
			{
				if( f && f.component )
				{
					var c : Component = f.component;
					var p : Panel = c.parentContainer as Panel;
					var l : HBoxLayout = p.childrenLayout as HBoxLayout;
					var deleteButton : Button = new Button( new ProxyAction( deleteCustomProperty,
																			 _("Remove this property"),
																			 magicIconBuild( remove ),
																			 null,
																			 null,
																			 f,
																			 formObject ) );
					deleteButton.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
					deleteButton.styleKey = "ToolBar_Button";

					l.boxes.push(new BoxSettings(20, "center", "center", deleteButton, false, false, false ));
					p.addComponent( deleteButton );
				}
			}
		}

		protected function hideAllSharedTips () : void
		{
			for each( var f : FormField in _formObject.fields )
			{
				var c : Component = f.component;
				var p : Panel = c.parentContainer as Panel;
				var sharedTip : Icon = p.lastChild as Icon;
				sharedTip.visible = false;
			}
		}

		protected function sharedFieldsFound (event : FormEvent) : void
		{
			var c : Component = event.formField.component;
			var p : Panel = c.parentContainer as Panel;
			var sharedTip : Icon = p.lastChild as Icon;
			sharedTip.visible = true;

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
			sharedTip.tooltip = _("The value in this field is shared by other states of this style.\nA copy of this value will be used if you try to modify it.");
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		protected function searchDataChange (event : ComponentEvent) : void
		{
			_tree.search( _searchInput.value );
		}

		protected function previewSelectedChange (event : ComponentEvent) : void
		{
			if( _preview.hasChildren )
				if( ( _preview.firstChild as Object ).hasOwnProperty( "selected" ) ) _preview.firstChild["selected"] = event.target.value;
		}

		protected function previewEnabledChange (event : ComponentEvent) : void
		{
			if( _preview.hasChildren )
				_preview.firstChild.enabled = event.target.value;
		}

		protected function formPropertyChange (event : PropertyEvent) : void
		{
			_grid.invalidate(true );
			_preview.invalidate(true);
		}

		protected function gridSelectionChange (event : ComponentEvent) : void
		{
			var a : Array = [];
			var v : Vector.<uint> = _grid.selection;

			var s : ComponentStyle = _grid.targetStyle;

			for( var i:int=0;i<v.length;i++)
				a.push(s.states[v[i]]);

			hideAllSharedTips ();
			_formManager.targets = a;
		}

		protected function isValueSharedByOtherStates( value : *, member : String, num : Number ) : Boolean
		{
			var style : ComponentStyle = _grid.targetStyle;
			var states : Vector.<ComponentStateStyle> = style.states;

			var l : uint = states.length;
			var n : uint = 0;
			for(var i:int=0;i<l;i++)
				if( states[i][member] == value )
					n++;

			return n > num;
		}

		protected function getParentSkinNode ( node : TreeNode ) : String
		{
			var pn : TreeNode = node.parent;

			while(pn)
			{
				if( !(pn.userObject is ComponentStyle ) )
					return pn.userObject as String;

				pn = pn.parent;
			}
			return null;
		}

		protected function treeSelectionChange (event : ComponentEvent) : void
		{
			_grid.clearSelection();
			_preview.removeAllComponents();

			// Style selectionné
			if( _tree.selectedValue && (_tree.selectedValue as TreeNode).userObject is ComponentStyle )
			{
				var style : ComponentStyle = ( _tree.selectedValue as TreeNode ).userObject as ComponentStyle;
				Log.debug( style );

				// update styles infos
				_styleName.value = _$(_("Style Name : <b>$0</b>"), style.styleName );
				_styleExtends.value = _$(_("Style Extends : <b>$0</b>"), style.defaultStyleKey != "" ? style.defaultStyleKey : _("Is Root") );
				_styleOwner.value = _$(_("Style owned by : <b>$0</b>"), style.skinName ? style.skinName : _( "No Owner") );
				
				_grid.targetStyle = style;
				_grid.enabled = true;
				_styleCustomPropertiesToolbar.enabled = true;
				
				
				// generate the preview component for this style
				var comp : Component = style.previewProvider() as Component;				Log.debug( comp );

				// prevent style affectation to the preview
				if( style.previewAcceptStyleSetup )
					comp.styleKey = style.fullStyleName;

				// reflect preview settings on the preview component
				comp.enabled = _previewEnabled.value;
				if( ( comp as Object ).hasOwnProperty("selected") )
				{
					comp["selected"] = _previewSelected.value;
					_previewSelected.enabled = true;				}
				else
				{
					_previewSelected.enabled = false;
				}

				_preview.addComponent( comp );

				// remove a previous form for custom properties
				if( _styleCustomProperties.view )
					_styleCustomProperties.view = null;

				// generate the form for the custom style properties
				if( style.hasCustomProperties() )
				{
					var a : Array = style.getCustomPropertiesTable();
					var l : uint = a.length;
					var fields : Array = [];

					for(var i:int=0;i<l;i++)
					{
						fields.push( new FormField( a[i] ,
													a[i],
													FormUtils.getComponentForType(style[a[i]]),
													i,
													Reflection.getClass(style[a[i]])));

					}

					var f : FormObject = new FormObject(style, fields);
					var p : Component = FieldSetFormRenderer.instance.render( f );
					setupRemovePropertyForm(f);
					_customStylePropertyManager = new SimpleFormManager( f );

					p.style.insets = new Insets(5);

					_styleCustomProperties.view = p;
				}
				else if( _customStylePropertyManager )
				{
					_customStylePropertyManager = null;
				}
			}
			// Skin sélectionné ou rien
			else
			{
				// remove a previous form for custom properties
				if( _styleCustomProperties.view )
					_styleCustomProperties.view = null;
				_styleName.value = _$(_("Style Name : <b>$0</b>"),_("No Style") );
				_styleExtends.value = _$(_("Style Extends : <b>$0</b>"),_("No Style") );				_styleOwner.value = _$(_("Style owned by : <b>$0</b>"),_("No Skin"));
				_grid.targetStyle = null;
				_grid.enabled = false;
				_styleCustomPropertiesToolbar.enabled = false;
			}
		}
	}
}

