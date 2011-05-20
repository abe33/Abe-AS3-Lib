package abe.com.ponents.trees
{
	import abe.com.mon.colors.Color;
	import abe.com.patibility.lang._;
	import abe.com.ponents.core.*;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.history.UndoManagerInstance;
	import abe.com.ponents.layouts.display.DOBoxSettings;
	import abe.com.ponents.layouts.display.DOHBoxLayout;
	import abe.com.ponents.lists.DefaultListCell;
	import abe.com.ponents.models.TreeNode;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.transfer.ComponentsTransferModes;
	import abe.com.ponents.transfer.Transferable;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="leafIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="nodeIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="expandIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="collapseIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="indentLineColor", type="abe.com.mon.colors.Color")]
	[Skinable(skin="TreeCell")]

	[Skin(define="TreeCell",
		  inherit="ListCell",
		  preview="abe.com.ponents.trees::Tree.defaultTreePreview",
		  previewAcceptStyleSetup="false",

		  custom_indentLineColor="skin.treeIndentLineColor",
		  custom_leafIcon="icon(abe.com.ponents.trees::DefaultTreeCell.TREE_LEAF_ICON)",
		  custom_nodeIcon="icon(abe.com.ponents.trees::DefaultTreeCell.TREE_NODE_ICON)",
		  custom_expandIcon="icon(abe.com.ponents.trees::DefaultTreeCell.TREE_NODE_EXPAND_ICON)",
		  custom_collapseIcon="icon(abe.com.ponents.trees::DefaultTreeCell.TREE_NODE_COLLAPSE_ICON)"
	)]
	public class DefaultTreeCell extends DefaultListCell
	{
		static public const INDENT_SIZE : Number = 16;

		[Embed(source="../skinning/icons/folder.png")]
		static public var TREE_NODE_ICON : Class;

		[Embed(source="../skinning/icons/page_white.png")]
		static public var TREE_LEAF_ICON : Class;

		[Embed(source="../skinning/icons/minus_box.png")]
		static public var TREE_NODE_COLLAPSE_ICON : Class;

		[Embed(source="../skinning/icons/plus_box.png")]
		static public var TREE_NODE_EXPAND_ICON : Class;

		protected var _expandStateIcon : Icon;
		protected var _indent : Number;

		protected var _indentLineColor : Color;
		protected var _leafIcon : Icon;
		protected var _nodeIcon : Icon;
		protected var _expandIcon : Icon;
		protected var _collapseIcon : Icon;

		public function DefaultTreeCell ()
		{
			super();
			_indentLineColor = _style.indentLineColor;
			var layout : DOHBoxLayout = new DOHBoxLayout( _childrenContainer, 3,
						new DOBoxSettings( 0 ),
						new DOBoxSettings( 0, "center" ),
						new DOBoxSettings( 0, "center" ),
						new DOBoxSettings( 0, "left", "center", _labelTextField as DisplayObject, true ) );

			_childrenLayout = layout;
			_leafIcon = ( _style.leafIcon as Icon ).clone();
			_nodeIcon = ( _style.nodeIcon as Icon ).clone();
			_expandIcon = ( _style.expandIcon as Icon ).clone();
			_collapseIcon = ( _style.collapseIcon as Icon ).clone();

			FEATURES::MENU_CONTEXT { 
				addNewContextMenuItemForGroup(_("Expand All"), "expandAll", expandAllSelected, "tree" );
				addNewContextMenuItemForGroup(_("Collapse All"), "collapseAll", collapseAllSelected, "tree" );
				addNewContextMenuItemForGroup(_("Collapse"), "expandCollapse", expandCollapseThisSelected, "tree" );
			} 
		}
		FEATURES::MENU_CONTEXT { 
		protected function expandCollapseThisSelected ( e : ContextMenuEvent ) : void
		{
			var n : TreeNode =  _value as TreeNode;
			n.expanded = !n.expanded;

			setContextMenuItemCaption( "expandCollapse", n.expanded ? _("Collapse Node") : _("Expand Node") );
		}
		protected function expandAllSelected ( e : ContextMenuEvent ) : void
		{
			var n : TreeNode =  _value as TreeNode;
			( _owner as Tree ).expandAll();

			setContextMenuItemCaption( "expandCollapse", n.expanded ? _("Collapse Node") : _("Expand Node") );
		}
		protected function collapseAllSelected ( e : ContextMenuEvent ) : void
		{
			var n : TreeNode =  _value as TreeNode;
			( _owner as Tree ).collapseAll();

			setContextMenuItemCaption( "expandCollapse", n.expanded ? _("Collapse Node") : _("Expand Node") );
		}
		} 

		override public function set icon (icon : Icon ) : void
		{
			super.icon = icon;
			if( _icon )
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( _icon, 2 );
			else
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( null, 2 );
			invalidatePreferredSizeCache();
		}

		override public function set value (val : *) : void
		{
			_value = val;
			var node : TreeNode = _value as TreeNode;

			if( node )
			{
				FEATURES::MENU_CONTEXT { 
					setContextMenuItemCaption( "expandCollapse", node.expanded ? _("Collapse Node") : _("Expand Node") );
				} 
				super.label = formatLabel( node.userObject );
				if( node.isLeaf )
				{
					FEATURES::MENU_CONTEXT { 
					if( groupContainsContextMenuItem( "expandCollapse", "tree" ) )
						removeContextMenuItemFromGroup( "expandCollapse", "tree" );
					} 
				}

				checkTreeCellIcon( node );
				checkExpandNodeIcon( node );

				if( isExpandable ( node ) )
				{
					FEATURES::MENU_CONTEXT { 
					if( !groupContainsContextMenuItem( "expandCollapse", "tree" ) )
						putContextMenuItemInGroup( "expandCollapse", "tree" );
					} 
				}

				_indent = ( node.depth-1 ) * INDENT_SIZE;

				( _childrenLayout as DOHBoxLayout ).boxes[0].size = _indent;
			}
			invalidatePreferredSizeCache();
		}

		protected function checkExpandNodeIcon (node : TreeNode) : void
		{
			if( isExpandable ( node ) )
				expandIcon = node.expanded ? _collapseIcon : _expandIcon;
			else
				expandIcon = null;
		}

		protected function checkTreeCellIcon (node : TreeNode) : void
		{
			if( node.isLeaf )
				icon = _leafIcon;
			else
				icon = _nodeIcon;
		}

		override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "leafIcon" :
					_leafIcon = ( _style.leafIcon as Icon ).clone();
					checkTreeCellIcon(_value);
					break;
				case "nodeIcon" :
					_nodeIcon = ( _style.nodeIcon as Icon ).clone();
					checkTreeCellIcon(_value);
					break;
				case "expandIcon" :
					_expandIcon = ( _style.expandIcon as Icon ).clone();
					checkExpandNodeIcon(_value);
					break;
				case "collapseIcon" :
					_collapseIcon = ( _style.collapseIcon as Icon ).clone();
					checkExpandNodeIcon(_value);
					break;
				default :
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}

		public function get expandIcon () : Icon {	return _expandStateIcon;	}
		public function set expandIcon (expandIcon : Icon) : void
		{
			if( _expandStateIcon && contains( _expandStateIcon ) )
			{
				_childrenContainer.removeChild( _expandStateIcon );
				_expandStateIcon.dispose();
			}

			if( _expandStateIcon && _expandStateIcon is Bitmap )
				(_expandStateIcon as Bitmap).bitmapData.dispose();

			_expandStateIcon = expandIcon;

			if( _expandStateIcon )
			{
				_expandStateIcon.init();
				_childrenContainer.addChild( _expandStateIcon );
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( _expandStateIcon, 1 );
			}
			else
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( null, 1 );

			invalidatePreferredSizeCache();
		}
		override public function click (context : UserActionContext ) : void
		{
			if( !_interactive )
				return;

			var pt : Point = this.globalToLocal( new Point( this.stage.mouseX, this.stage.mouseY ) );
			var n : TreeNode = _value as TreeNode;

			if( _expandStateIcon && pt.x > _expandStateIcon.x && pt.x < _expandStateIcon.x + _expandStateIcon.width )
			{
				if( n.expanded )
				{
					( _owner as Tree ).collapseNode( n );
					expandIcon = _collapseIcon;
					FEATURES::MENU_CONTEXT { 
					setContextMenuItemCaption( "expandCollapse", _("Expand Node") );
					} 
				}
				else
				{
					( _owner as Tree ).expandNode( n );
					expandIcon = _expandIcon;
					FEATURES::MENU_CONTEXT { 
					setContextMenuItemCaption( "expandCollapse", _("Collapse Node") );
					} 
				}
			}
			else
			{
				super.click( context );
			}
		}

		FEATURES::DND { 
		override public function get allowDrag () : Boolean { return super.allowDrag && !(_value as TreeNode).isRoot; }
		} 

		override public function repaint () : void
		{
			super.repaint();
			drawBackground();
		}
		protected function drawBackground () : void
		{

			var node : TreeNode = _value as TreeNode;

			if( node )
			{
				var x : Number = _indent - INDENT_SIZE / 2;
				var y : Number = height/2;

				var g : Graphics = _childrenContainer.graphics;
				g.clear();
				g.lineStyle(0,_indentLineColor.hexa, _indentLineColor.alpha / 255);

				if( node.isRoot )
				{}
				else
				{
					if( node.isLastChild )
					{
						g.moveTo(x, 0);
						g.lineTo(x, y);
						g.lineTo(_indent, y );
					}
					else
					{
						g.moveTo(x, 0);
						g.lineTo(x, height);

						g.moveTo(x, y);
						g.lineTo(_indent, y);
					}
				}
				var p : TreeNode = node.parent;
				while ( p )
				{
					x -= INDENT_SIZE;
					if( !p.isLastChild && !p.isRoot )
					{
						g.moveTo(x, 0);
						g.lineTo(x, height);
					}

					p = p.parent;
				}
			}
		}

		override protected function valueChanged ( old : *, n : *, id : Number ) : void
		{
			var node : TreeNode = _value as TreeNode;
			var oldUO : * = node.userObject;
			node.userObject = n;

			UndoManagerInstance.add( new DefaultTreeCellUndoadleEdit( oldUO, n, node ) );
		}
		protected function isExpandable ( node : TreeNode ) : Boolean
		{
			return node.expandable && node.hasChildren;
		}
		/*
		private function getIcon ( value : * ) : DisplayObject
		{
			var node : TreeNode = value as TreeNode;
			if( node.isLeaf )
				return new ComponentsBitmaps.treeDefaultLeafIcon();
			else
				return new ComponentsBitmaps.treeDefaultFolderIcon();
		}*/
		FEATURES::DND { 
		override public function get transferData () : Transferable
		{
			return new TreeTransferable( _value, _owner, ComponentsTransferModes.MOVE );
		}
		} 
	}
}

import abe.com.patibility.lang._;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.history.Undoable;
import abe.com.ponents.models.TreeNode;

internal class DefaultTreeCellUndoadleEdit extends AbstractUndoable implements Undoable
{
	protected var _oldValue : *;
	protected var _newValue : *;
	protected var _node : TreeNode;

	public function DefaultTreeCellUndoadleEdit ( oldValue : *, newValue : *, node : TreeNode )
	{
		_label = _("Edit Tree Cell");
		_newValue = newValue;
		_oldValue = oldValue;
		_node = node;
	}

	override public function undo() : void
	{
		_node.userObject = _oldValue;
		super.undo();
	}

	override public function redo() : void
	{
		_node.userObject = _newValue;
		super.redo();
	}
}
