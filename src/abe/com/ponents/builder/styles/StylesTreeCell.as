package abe.com.ponents.builder.styles
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.builder.codecs.SkinSourceCodec;
	import abe.com.ponents.builder.codecs.StyleMetaCodec;
	import abe.com.ponents.builder.codecs.StyleSourceCodec;
	import abe.com.ponents.builder.dialogs.PreventRenameDefault;
	import abe.com.ponents.builder.dialogs.PreventRenameSkin;
	import abe.com.ponents.builder.dialogs.PreventRenameStyle;
	import abe.com.ponents.builder.dialogs.PrintDialog;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.core.edit.EditorFactoryInstance;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.events.EditEvent;
	import abe.com.ponents.models.TreeNode;
	import abe.com.ponents.skinning.ComponentStyle;
	import abe.com.ponents.skinning.SkinManager;
	import abe.com.ponents.skinning.SkinManagerInstance;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.trees.DefaultTreeCell;

	import flash.display.DisplayObject;
	import flash.events.Event;

	[Skinable(skin="StylesTreeCell")]
	[Skin(define="StylesTreeCell",
			  inherit="TreeCell",

			  custom_leafIcon="icon(abe.com.ponents.builder.styles::StylesTreeCell.STYLE_ICON)",
			  custom_nodeIcon="icon(abe.com.ponents.builder.styles::StylesTreeCell.SKIN_ICON)"
	)]
	public class StylesTreeCell extends DefaultTreeCell
	{
		[Embed(source="../../skinning/icons/style.png")]
		static public var STYLE_ICON : Class;

		[Embed(source="../../skinning/icons/package.png")]
		static public var SKIN_ICON : Class;

		protected var _search : String;
		protected var _tmpInput : TextInput;

		public function StylesTreeCell ()
		{
			super();

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			addNewContextMenuItemForGroup( _("Remove this skin"), "removeSkin", deleteSkinSelected, "skin" );
			addNewContextMenuItemForGroup( _("Remove this style"), "removeStyle", deleteStyleSelected, "skin" );
			addNewContextMenuItemForGroup( _("Add New Root Style"), "newRootStyle", addNewRootStyleSelected, "skin" );
			addNewContextMenuItemForGroup( _("Add New Child Style"), "newChildStyle", addNewStyleSelected, "skin" );

			addNewContextMenuItemForGroup( _("Print Skin as ActionScript Source"), "printSkinSource", printSkinAsSource, "export" );
			addNewContextMenuItemForGroup( _("Print Style as Skin Metatag"), "printStyleMeta", printStyleAsMeta, "export" );
			addNewContextMenuItemForGroup( _("Print Style as ActionScript Source"), "printStyleSource", printStyleAsSource, "export" );
			clearMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		override public function set value (val : *) : void
		{
			var oldNode : TreeNode = _value as TreeNode;

			super.value = val;

			var node : TreeNode = _value as TreeNode;

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
			if( node && ( !oldNode || oldNode.userObject != node.userObject ) )
			{
				if( !( node.userObject is ComponentStyle ) )					_keyboardContext[KeyStroke.getKeyStroke( Keys.DELETE)] = new ProxyCommand(deleteSkinSelected);
				else
					_keyboardContext[KeyStroke.getKeyStroke( Keys.DELETE)] = new ProxyCommand(deleteStyleSelected);
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			if( node && ( !oldNode || oldNode.userObject != node.userObject ) )
			{
				clearMenu ();
				if( !( node.userObject is ComponentStyle ) )				{
					if( node.userObject != SkinManager.DEFAULT_SKIN_NAME )
						putContextMenuItemInGroup("removeSkin", "skin" );

					putContextMenuItemInGroup("newRootStyle", "skin" );
					putContextMenuItemInGroup("printSkinSource", "export" );
				}
				else
				{
					if( ( node.userObject as ComponentStyle ).skinName != SkinManager.DEFAULT_SKIN_NAME )
						putContextMenuItemInGroup("removeStyle", "skin" );

					putContextMenuItemInGroup("newChildStyle", "skin" );

					putContextMenuItemInGroup("printStyleMeta", "export" );
					putContextMenuItemInGroup("printStyleSource", "export" );
				}
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		}

		public function get stylesTree () : StylesTree { return _owner as StylesTree; }

		public function clearSearch () : void
		{
			_search = null;
		}
		override public function startEdit () : void
		{
			if( allowEdit )
			{
				var n : TreeNode = _value as TreeNode;
				var d : Dialog;
				
				if( n.userObject == SkinManager.DEFAULT_SKIN_NAME ||
					( n.userObject is ComponentStyle && (n.userObject as ComponentStyle).skinName == SkinManager.DEFAULT_SKIN_NAME ) )
				{
					d = new PreventRenameDefault();
					/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
					if( SettingsManagerInstance.get( d, "ignoreWarning" ) )
						return;
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/

					d.open( Dialog.CLOSE_ON_RESULT );
					return;
				}

				if( n.userObject is String )
				{
					d = new PreventRenameSkin();
					/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
					if( SettingsManagerInstance.get( d, "ignoreWarning" ) )
					{
						warnRename();
						return;
					}
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
				else
				{
					d = new PreventRenameStyle();
					/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
					if( SettingsManagerInstance.get( d, "ignoreWarning" ) )
					{
						warnRename();
						return;
					}
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}

				d.addWeakEventListener(DialogEvent.DIALOG_RESULT, warnRename );
				d.open( Dialog.CLOSE_ON_RESULT );
			}
		}

		protected function warnRename ( e : DialogEvent = null ) : void
		{
			var n : TreeNode = _value as TreeNode;

			if( e && e.result != Dialog.RESULTS_YES )
				return;

			_owner.ensureIndexIsVisible( _index );

			_isEditing = true;

			if( _owner.model.contentType != null )
				_editor = EditorFactoryInstance.getForType( _owner.model.contentType );
			else
				_editor = EditorFactoryInstance.get();

			_editor.initEditState( this , super.formatLabel( n.userObject ), _labelTextField as DisplayObject );

			fireComponentEvent( EditEvent.EDIT_START );

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				hideToolTip();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		override protected function valueChanged (old : *, n : *, id : Number) : void
		{
			//super.valueChanged( old, n, id );

			var node : TreeNode = _value as TreeNode;

			if( node.userObject is String )
			{
				SkinManagerInstance.renameSkin( old, n );
				node.userObject = n;
			}
			else if( old is ComponentStyle )
			{

			}
			//UndoManagerInstance.add( new DefaultTreeCellUndoadleEdit( oldUO, n, node ) );
		}

		public function displaySearch (s : String) : void
		{
			_search = s;
		}

		override protected function formatLabel (value : *) : String
		{
			if( _search )
				return super.formatLabel( value ).replace(_search,"<u><b>"+_search+"</b></u>");
			else
				return super.formatLabel( value );
		}

		override protected function checkTreeCellIcon (node : TreeNode) : void
		{
			if( node.userObject is ComponentStyle )
				icon = _leafIcon;
			else
				icon = _nodeIcon;
		}

		protected function deleteSkinSelected ( event : Event = null ) : void
		{
			var node : TreeNode = _value as TreeNode ;
			if( !( node.userObject is String && node.userObject == SkinManager.DEFAULT_SKIN_NAME )   )
			stylesTree.removeSkin( _value as TreeNode );
		}
		protected function deleteStyleSelected ( event : Event = null ) : void
		{			var node : TreeNode = _value as TreeNode ;
			if( !( node.userObject is ComponentStyle && node.userObject.skinName == SkinManager.DEFAULT_SKIN_NAME )  )
				stylesTree.removeStyle( node );
		}
		protected function addNewRootStyleSelected ( event : Event = null ) : void
		{
			stylesTree.createNewStyle( _value as TreeNode );
		}
		protected function addNewStyleSelected ( event : Event = null ) : void
		{
			stylesTree.createNewStyle( _value as TreeNode );
		}
		protected function printSkinAsSource (event : Event = null) : void
		{
			var node : TreeNode = _value as TreeNode;
			if( node.userObject is String )
			{
				var cs : Object = SkinManagerInstance.getSkin( node.userObject );
				var codec : SkinSourceCodec = new SkinSourceCodec();

				var d : PrintDialog = new PrintDialog( codec.encode(cs), _("Skin Source") );
				d.open();
			}
		}
		protected function printStyleAsSource (event : Event = null) : void
		{
			var node : TreeNode = _value as TreeNode;
			if( node.userObject is ComponentStyle )
			{
				var cs : ComponentStyle = node.userObject as ComponentStyle;
				var codec : StyleSourceCodec = new StyleSourceCodec();

				var d : PrintDialog = new PrintDialog( codec.encode(cs), _("Style Source") );
				d.open();
			}
		}
		protected function printStyleAsMeta (event : Event = null) : void
		{
			var node : TreeNode = _value as TreeNode;
			if( node.userObject is ComponentStyle )
			{
				var cs : ComponentStyle = node.userObject as ComponentStyle;
				var codec : StyleMetaCodec = new StyleMetaCodec();

				var d : PrintDialog = new PrintDialog( codec.encode(cs), _("Style Meta Source") );
				d.open();
			}
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected function clearMenu () : void
		{
			removeContextMenuItemFromGroup( "removeSkin", "skin" );
			removeContextMenuItemFromGroup( "removeStyle", "skin" );
			removeContextMenuItemFromGroup( "newRootStyle", "skin" );
			removeContextMenuItemFromGroup( "newChildStyle", "skin" );

			removeContextMenuItemFromGroup( "printSkinSource", "export" );
			removeContextMenuItemFromGroup( "printStyleMeta", "export" );
			removeContextMenuItemFromGroup( "printStyleSource", "export" );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

	}
}
