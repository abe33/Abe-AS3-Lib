package abe.com.ponents.builder.styles
{
	import abe.com.ponents.actions.ActionManagerInstance;
	import abe.com.mon.utils.Color;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.Action;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.lists.ListCell;
	import abe.com.ponents.models.TreeModel;
	import abe.com.ponents.models.TreeNode;
	import abe.com.ponents.models.TreePath;
	import abe.com.ponents.skinning.ComponentStateStyle;
	import abe.com.ponents.skinning.ComponentStyle;
	import abe.com.ponents.skinning.SkinManager;
	import abe.com.ponents.skinning.SkinManagerInstance;
	import abe.com.ponents.skinning.decorations.NoDecoration;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.trees.Tree;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;
	import abe.com.ponents.utils.Insets;

	import flash.events.ContextMenuEvent;
	import flash.text.TextFormat;
	/**
	 * @author cedric
	 */
	public class StylesTree extends Tree
	{
		[Embed(source="../../skinning/icons/package_add.png")]
		static public var SKIN_ADD : Class;

		[Embed(source="../../skinning/icons/package_delete.png")]
		static public var SKIN_REMOVE : Class;

		[Embed(source="../../skinning/icons/style_add.png")]
		static public var STYLE_ADD : Class;

		[Embed(source="../../skinning/icons/style_delete.png")]
		static public var STYLE_REMOVE : Class;

		protected var _createNewSkinAction : ProxyAction;
		protected var _createNewStyleAction : ProxyAction;
		protected var _removeSkinAction : ProxyAction;		protected var _removeStyleAction : ProxyAction;

		protected var _tmpNode : TreeNode;
		protected var _searchIndices : Object;
		protected var _lastSearch : String;
		protected var _tmpInput : TextInput;

		public function StylesTree ( model : TreeModel = null )
		{
			_listCellClass = _listCellClass ? _listCellClass : StylesTreeCell;
			super( model );
			loseSelectionOnFocusOut = false;	
			
			_createNewSkinAction = new ProxyAction(createNewSkin, _("Create New Skin"), magicIconBuild(SKIN_ADD) );			_removeSkinAction = new ProxyAction(removeSkin, _("Delete Skin"), magicIconBuild(SKIN_REMOVE) );			_createNewStyleAction = new ProxyAction(createNewStyle, _("Create New Style"), magicIconBuild(STYLE_ADD) );
			_removeStyleAction = new ProxyAction(removeStyle, _("Delete Style"), magicIconBuild(STYLE_REMOVE) );
			
			ActionManagerInstance.registerAction( _createNewSkinAction, "newSkin" );			ActionManagerInstance.registerAction( _removeSkinAction, "removeSkin" );			ActionManagerInstance.registerAction( _createNewStyleAction, "newStyle" );			ActionManagerInstance.registerAction( _removeStyleAction, "removeStyle" );

			_createNewStyleAction.actionEnabled = false;
			_removeSkinAction.actionEnabled = false;			_removeStyleAction.actionEnabled = false;

			addEventListener(ComponentEvent.SELECTION_CHANGE, selectionChange );

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			addNewContextMenuItemForGroup( _("Add New Skin"), "addSkin", addNewStyleSelected, "skin", 0 );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		protected function selectionChange (event : ComponentEvent) : void
		{
			var node : TreeNode = _selectedValue as TreeNode;
			_createNewStyleAction.actionEnabled = node != null;			_removeStyleAction.actionEnabled = node != null &&
											   node.userObject is ComponentStyle &&
											   (node.userObject as ComponentStyle).skinName != SkinManager.DEFAULT_SKIN_NAME;

			_removeSkinAction.actionEnabled = node != null &&
											  node.userObject is String &&
											  node.userObject != SkinManager.DEFAULT_SKIN_NAME;
		}

/*--------------------------------------------------------------
 * ACTION GETTERS
 *--------------------------------------------------------------*/
		public function getCreateNewSkinAction() : Action
		{
			return _createNewSkinAction;
		}
		public function getRemoveSkinAction() : Action
		{
			return _removeSkinAction;
		}
		public function getRemoveStyleAction() : Action
		{
			return _removeStyleAction;
		}
		public function getCreateNewStyleAction() : Action
		{
			return _createNewStyleAction;
		}
/*--------------------------------------------------------------
 * SEARCH METHODS
 *--------------------------------------------------------------*/

 		public function searchStyle( s : String ):void
 		{
 			var lc : StylesTreeCell;
 			var p : TreePath;
 			_searchIndices = [];
 			_lastSearch = s;
 			if( s != "" )
 			{
	 			var a : Array = treeModel.root.search(s);
	 			if( a.length > 0 )
	 			{
	 				for each( p in a)
	 				{
	 					expandPath( p );
	 					_searchIndices.push( model.indexOf( p.getLastPathNode() ) );
	 				}
	 			}
 			}
			invalidate();
		}
/*--------------------------------------------------------------
 * CREATION METHODS
 *--------------------------------------------------------------*/
		public function createNewStyle ( node : TreeNode = null ) : void
		{
			_tmpNode = node ? node : _selectedValue as TreeNode;
			var d : Dialog;

			_tmpInput = new TextInput(/*0, false, "inputNewStyleName"*/);

			d = new Dialog(_("Set new style name") , Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON, _tmpInput, Dialog.OK_BUTTON );

			if( _tmpNode.userObject is String )
			{
				_tmpInput.value = "MyRootStyle";
				d.addEventListener( DialogEvent.DIALOG_RESULT, newRootStyleNameResult );
			}
			else
			{
				_tmpInput.value = "MyStyle";
				d.addEventListener( DialogEvent.DIALOG_RESULT, newStyleNameResult );
			}

			d.open( Dialog.CLOSE_ON_RESULT );
		}

		public function removeStyle ( node : TreeNode = null ) : void
		{
			_tmpNode = node ? node : _selectedValue as TreeNode;

			if( _tmpNode && _tmpNode.userObject is ComponentStyle )
			{
				var d : Dialog = new Dialog(_("Warning") ,
											Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON,
											new Label(_("Are you sure you want to remove this style ?\nThis action cannot be undone.")),
											Dialog.OK_BUTTON );
				d.addEventListener( DialogEvent.DIALOG_RESULT, removeStyleResult );
				d.open( Dialog.CLOSE_ON_RESULT );
			}
		}

		public function removeSkin ( node : TreeNode = null ) : void
		{
			_tmpNode = node ? node : _selectedValue as TreeNode;

			if( _tmpNode && _tmpNode.userObject is String )
			{
				var d : Dialog = new Dialog(_("Warning") ,
											Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON,
											new Label(_("Are you sure you want to remove this skin ?\nThis action cannot be undone.")),
											Dialog.OK_BUTTON );
				d.addEventListener( DialogEvent.DIALOG_RESULT, removeSkinResult );
				d.open( Dialog.CLOSE_ON_RESULT );
			}
		}

		protected function createNewSkin () : void
		{
			_tmpNode = treeModel.root;
			_tmpInput = new TextInput( /*0, false, "inputNewSkinName"*/ );
			_tmpInput.value = "MySkin";

			var d : Dialog = new Dialog(_("Set new skin name") , Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON, _tmpInput, Dialog.OK_BUTTON );
			d.addEventListener( DialogEvent.DIALOG_RESULT, newSkinNameResult );
			d.open( Dialog.CLOSE_ON_RESULT );
		}

/*--------------------------------------------------------------
 * DIALOGS RESULTS
 *--------------------------------------------------------------*/
		protected function removeStyleResult (event : DialogEvent) : void
		{
			switch(event.result)
			{
				case Dialog.RESULTS_OK :
					if( _tmpNode == _selectedValue )
						clearSelection();

					_tmpNode.removeFromParent();
					SkinManagerInstance.removeStyle( _tmpNode.userObject );
					break;

				default :
					break;
			}
			_tmpNode = null;
		}
		protected function removeSkinResult (event : DialogEvent) : void
		{
			switch(event.result)
			{
				case Dialog.RESULTS_OK :
					if( _tmpNode == _selectedValue )
						clearSelection();

					treeModel.root.remove( _tmpNode );
					SkinManagerInstance.removeSkin( _tmpNode.userObject );
					break;

				default :
					break;
			}
			_tmpNode = null;
		}

		protected function newStyleNameResult (event : DialogEvent) : void
		{
			switch(event.result)
			{
				case Dialog.RESULTS_OK :
					var name : String = _tmpInput.value as String;
					_createNewStyleForNode( _tmpNode, name );
					break;

				default :
					break;
			}
			_tmpNode = null;
			_tmpInput = null;
		}
		protected function newRootStyleNameResult (event : DialogEvent) : void
		{
			switch(event.result)
			{
				case Dialog.RESULTS_OK :
					var name : String = _tmpInput.value as String;
					_createNewRootStyleForNode( _tmpNode, name );
					break;

				default :
					break;
			}
			_tmpNode = null;
			_tmpInput = null;
		}
		protected function newSkinNameResult (event : DialogEvent) : void
		{
			switch(event.result)
			{
				case Dialog.RESULTS_OK :

					var name : String = _tmpInput.value as String;

					_tmpNode.add( new TreeNode( name, true ) );
					SkinManagerInstance.addSkin( name, {name:name} );
					break;

				default :
					break;
			}
			_tmpInput = null;
			_tmpNode = null;
		}

		private function _createNewStyleForNode( node : TreeNode, name : String ) : ComponentStyle
		{
			var pcs : ComponentStyle = node.userObject as ComponentStyle;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var v : Array = new Array(16); }
			TARGET::FLASH_10 { var v : Vector.<ComponentStateStyle> = new Vector.<ComponentStateStyle>(16, true); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var v : Vector.<ComponentStateStyle> = new Vector.<ComponentStateStyle>(16, true); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			for(var i:int=0;i<16;i++)
			{
				v[i] = new ComponentStateStyle();
			}

			var cs : ComponentStyle = new ComponentStyle( pcs.fullStyleName, name, v );
			cs.skinName = pcs.skinName;

			node.add( new TreeNode( cs, true ) );

			var o : Object = getParentSkin( node );
			if( o )
				o[cs.styleName] = cs;

			return cs;
		}
		private function _createNewRootStyleForNode( node : TreeNode, name : String ) : ComponentStyle
		{
			var noDeco : NoDecoration = new NoDecoration();
			var format : TextFormat = new TextFormat("Verdana", 11, false, false, false );
			var insets : Insets = new Insets();
			var borders : Borders = new Borders();
			var corners : Corners = new Corners();
			var innerFilters : Array = [];
			var outerFilters : Array = [];

			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var v : Array = new Array(16); }
			TARGET::FLASH_10 { var v : Vector.<ComponentStateStyle> = new Vector.<ComponentStateStyle>(16, true); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var v : Vector.<ComponentStateStyle> = new Vector.<ComponentStateStyle>(16, true); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			for(var i:int=0;i<16;i++)
			{
				v[i] = new ComponentStateStyle( noDeco, noDeco, Color.Black, format, insets, borders, corners, outerFilters, innerFilters );
			}

			var cs : ComponentStyle = new ComponentStyle( "", name, v );

			node.add( new TreeNode( cs, true ) );
			var o : Object = SkinManagerInstance.getSkin( node.userObject as String );

			if( o )
			{
				o[ name ] = cs;
				cs.skinName = node.userObject as String;
			}
			return cs;
		}
		protected function getParentSkin ( node : TreeNode ) : Object
		{
			return SkinManagerInstance.getSkin( getParentSkinName( node ) );
		}
		protected function getParentSkinName ( node : TreeNode ) : String
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
/*--------------------------------------------------------------
 * MENU CONTEXT
 *--------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected function addNewStyleSelected (event : ContextMenuEvent) : void
		{
			createNewSkin();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
/*--------------------------------------------------------------
 * OVERRIDES
 *--------------------------------------------------------------*/
		override protected function setCell (cell : ListCell, data : *, index : uint) : void
		{
			if( _searchIndices && _searchIndices.indexOf( index ) != -1 )
				(cell as StylesTreeCell).displaySearch( _lastSearch );
			else
				(cell as StylesTreeCell).clearSearch();

			super.setCell( cell, data, index );
		}

	}
}