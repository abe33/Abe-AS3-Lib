package aesia.com.ponents.trees
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.dnd.DropEvent;
	import aesia.com.ponents.dnd.DropTargetDragEvent;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListCell;
	import aesia.com.ponents.models.TreeModel;
	import aesia.com.ponents.models.TreeNode;
	import aesia.com.ponents.models.TreePath;
	import aesia.com.ponents.transfer.ComponentsFlavors;

	import flash.events.ContextMenuEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenuItem;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	[Skinable(skin="Tree")]
	[Skin(define="Tree",
		  inherit="List",
		  preview="aesia.com.ponents.trees::Tree.defaultTreePreview"
	)]
	public class Tree extends List
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultTreePreview () : Tree
		{
			var root : TreeNode = new TreeNode(_("Sample Root Node"), true);
			var node : TreeNode = new TreeNode(_("Sample Node"), true );

			node.add( new TreeNode(_("Sample Leaf 1")) );
			node.add( new TreeNode(_("Sample Leaf 2")) );
			root.add( node );

			var m : TreeModel = new TreeModel( root );
			var t : Tree = new Tree( m );
			t.editEnabled = false;
			t.dndEnabled = false;
			t.expandAll();
			t.selectedIndex = 1;
			t.interactive = false;

			return t;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		static public var BORDER_SIZE : Number = 5;

		protected var _selectChildAlongWithNode : Boolean;

		public function Tree ( model : TreeModel = null )
		{
			_listCellClass = _listCellClass? _listCellClass : DefaultTreeCell;

			super( model ? model : new TreeModel() );

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.LEFT ) ] = new ProxyCommand( left );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.RIGHT ) ] = new ProxyCommand( right );				_keyboardContext[ KeyStroke.getKeyStroke( Keys.NUMPAD_DIVIDE ) ] = new ProxyCommand( collapseAll );				_keyboardContext[ KeyStroke.getKeyStroke( Keys.SLASH ) ] = new ProxyCommand( collapseAll );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.NUMPAD_MULTIPLY ) ] = new ProxyCommand( expandAll );			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				addNewContextMenuItemForGroup(_("Expand All"), "expandAll", expandAllSelected, "tree" );				addNewContextMenuItemForGroup(_("Collapse All"), "collapseAll", collapseAllSelected, "tree" );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected function expandAllSelected ( e : ContextMenuEvent ) : void { expandAll(); }		protected function collapseAllSelected ( e : ContextMenuEvent ) : void { collapseAll(); }
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		public function get treeModel () : TreeModel { return _model as TreeModel; }

		public function get selectChildAlongWithNode () : Boolean { return _selectChildAlongWithNode; }
		public function set selectChildAlongWithNode (selectChildAlongWithNode : Boolean) : void
		{
			_selectChildAlongWithNode = selectChildAlongWithNode;
		}
		public function get showRoot () : Boolean { return treeModel.showRoot; }
		public function set showRoot (showRoot : Boolean) : void
		{
			treeModel.showRoot = showRoot;
			invalidatePreferredSizeCache();
		}

		public function get expandableRoot () : Boolean { return treeModel.expandableRoot; }
		public function set expandableRoot (expandableRoot : Boolean) : void
		{
			treeModel.expandableRoot = expandableRoot;
			invalidatePreferredSizeCache();
		}
		public function expandPath ( path : TreePath ) : void
		{
			var l : Number = path.length;
			for(var i : Number = 0; i < l-1; i++ )
			{
				expandNode( path.getPathNode( i ) );
			}
		}
		public function expandAll () : void
		{
			var r : TreeNode = ( _model as TreeModel ).root;
			r.expandAll();
		}
		public function expandNode ( node : TreeNode ) : void
		{
			if( !node.expanded )
			{
			 	node.expanded = true;
			}
		}

		public function collapseAll() : void
		{
			var r : TreeNode = ( _model as TreeModel ).root;
			if( treeModel.expandableRoot )
				r.collapseAll();
			else for each (var n : TreeNode in r.children )
				n.collapseAll();
			//collapseNode(r);
		}
		public function collapseNode ( node : TreeNode ) : void
		{
			if( node.expanded )
			{
			 	node.expanded = false;
			}
		}

		protected function left () : void
		{
			var node : TreeNode;
			if( _allowMultiSelection )
			{
				if( selectedIndices.length == 1 )
				{
					node = selectedValues[0] as TreeNode;
					if( node && node.expandable && node.expanded )
					{
						collapseNode( node );
					}
				}
			}
			else
			{
				if( selectedIndex >= 0 )
				{
					node = selectedValue as TreeNode;
					if( node && node.expandable && node.expanded )
					{
						collapseNode( node );
					}
				}
			}
		}
		protected function right() : void
		{

			var node : TreeNode;
			if( _allowMultiSelection )
			{
				if( selectedIndices.length == 1 )
				{
					node = selectedValues[0] as TreeNode;
					if( node && node.expandable && !node.expanded )
					{
						expandNode( node );
					}
				}
			}
			else
			{
				if( selectedIndex >= 0 )
				{

					node = selectedValue as TreeNode;
					if( node && node.expandable && !node.expanded )
					{
						expandNode( node );
					}
				}
			}
		}

/*----------------------------------------------------------------------
 * 	DND HANDLING
 *---------------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function dragEnter (e : DropTargetDragEvent ) : void
		{
			_scrollDuringDragTimeout = setInterval( scrollDuringDrag, 250 );
			if( _enabled &&
				( ComponentsFlavors.TREE_ITEM.isSupported ( e.flavors ) ||
				  ComponentsFlavors.LIST_ITEM.isSupported ( e.flavors ) ) )
				e.acceptDrag( this );
			else
				e.rejectDrag( this );
		}

		override public function dragOver ( e : DropTargetDragEvent ) : void
		{
			_dropStatusShape.graphics.clear();
			var treeItem : Boolean = ComponentsFlavors.TREE_ITEM.isSupported ( e.flavors );

			var lc : ListCell = getListCellUnderPoint ( new Point( 	this.stage.mouseX,
									   			 					this.stage.mouseY ) );
			if( lc )
				var n : TreeNode = lc.value as TreeNode;

			if( n )
			{
				if( treeItem )
				{
					var d : TreeNode = e.transferable.getData( ComponentsFlavors.TREE_ITEM ) as TreeNode;
					if( n == d || d.isNodeDescendant( n ) )
						return;
				}

				if( n.isLeaf && !n.allowChildren && !n.isRoot )
				{
					if( lc.mouseY > lc.height / 2 )
						drawDropBelow( lc );
					else
						drawDropAbove( lc );
				}
				else
				{
					if( lc.mouseY < BORDER_SIZE && !n.isRoot )
						drawDropAbove(lc);
					else if( lc.mouseY > lc.height - BORDER_SIZE && !n.isRoot )
						drawDropBelow(lc);
					else
						drawDropOnto(lc);
				}
			}
		}

		override public function drop (e : DropEvent) : void
		{
			_dropStatusShape.graphics.clear();
			clearInterval( _scrollDuringDragTimeout );
			var treeItem : Boolean = ComponentsFlavors.TREE_ITEM.isSupported( e.transferable.flavors );
			var listItem : Boolean = ComponentsFlavors.LIST_ITEM.isSupported ( e.transferable.flavors );
			var wasChildBeforeDrop : Boolean = false;
			var d : TreeNode;
			var oldP : TreeNode;
			var oldI : Number;

			var lc : ListCell = getListCellUnderPoint ( new Point( 	this.stage.mouseX,
										   			 				this.stage.mouseY ) );

			// cas où l'on drop le noeud sur une cellule de la liste
			if( lc )
			{
				var n : TreeNode = lc.value as TreeNode;

				// si le transferable supporte la saveur TREE_ITEM
				if( treeItem )
				{
					d = e.transferable.getData( ComponentsFlavors.TREE_ITEM ) as TreeNode;
					wasChildBeforeDrop = d.root == n.root;

					// si il s'agit du meme noeud
					// ou que l'on déplace le parent vers un de ces enfants
					// on arrête tout
					if( n == d || d.isNodeDescendant( n ) )
						return;
				}
				else if( listItem )
				{
					d = new TreeNode( e.transferable.getData( ComponentsFlavors.LIST_ITEM ) );
				}
				oldP = d.parent;
				oldI = d.index;
				var index : int = n.index;

				if( n.isLeaf && !n.allowChildren && !n.isRoot )
				{
					if( lc.mouseY > lc.height / 2)
						index++;

					n.parent.insert( d , index );
				}
				else
				{
					if( lc.mouseY < BORDER_SIZE && !n.isRoot )
						n.parent.insert( d , index );
					else if( lc.mouseY > lc.height - BORDER_SIZE && !n.isRoot )
						n.parent.insert( d , index + 1  );
					else
						n.add( d );
				}
				_undoManager.add( new TreeDnDInsertUndoadleEdit ( d, oldP, oldI, d.parent, d.index ) );
				if( !wasChildBeforeDrop )
					e.transferable.transferPerformed();

				if( d.parent == null )
				{
					n.insert( d, index );
				}
				invalidatePreferredSizeCache();
			}
			else
			{
				if( treeItem )
				{
					d = e.transferable.getData( ComponentsFlavors.TREE_ITEM ) as TreeNode;
					wasChildBeforeDrop = d.root == treeModel.root;
				}
				else if( listItem )
				{
					d = new TreeNode( e.transferable.getData( ComponentsFlavors.LIST_ITEM ) );
				}
				oldP = d.parent;
				oldI = d.index;
				treeModel.root.add( d );
				_undoManager.add( new TreeDnDInsertUndoadleEdit ( d, oldP, oldI, treeModel.root, d.index ) );
				if( !wasChildBeforeDrop )
					e.transferable.transferPerformed();

				invalidatePreferredSizeCache();

			}
		}
		override public function get supportedFlavors () : Array
		{
			return [ ComponentsFlavors.TREE_ITEM, ComponentsFlavors.LIST_ITEM ];
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

import aesia.com.ponents.history.AbstractUndoable;
import aesia.com.ponents.models.TreeNode;

internal class TreeDnDInsertUndoadleEdit extends AbstractUndoable
{
	private var node : TreeNode;
	private var oldParent : TreeNode;
	private var oldIndex : Number;
	private var newParent : TreeNode;
	private var newIndex : Number;

	public function TreeDnDInsertUndoadleEdit ( node : TreeNode,
											    oldParent : TreeNode, oldIndex : Number,
											    newParent : TreeNode, newIndex : Number )
	{
		this._label = "Insert Tree Item";
		this.node = node;
		this.oldParent = oldParent;
		this.oldIndex = oldIndex;

		this.newParent = newParent;
		this.newIndex = newIndex;
	}

	override public function undo () : void
	{
		if( newParent )
			newParent.remove( node );
		if( oldParent )
			oldParent.insert( node, oldIndex );
		super.undo();
	}

	override public function redo () : void
	{
		if( oldParent )
			oldParent.remove( node );
		if( newParent )
			newParent.insert( node, newIndex );
		super.redo();
	}
}