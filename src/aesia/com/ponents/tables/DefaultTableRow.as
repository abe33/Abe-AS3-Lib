/**
 * @license
 */
package aesia.com.ponents.tables 
{
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.ponents.actions.Action;
	import aesia.com.ponents.containers.DraggablePanel;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.edit.Editor;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListCell;
	import aesia.com.ponents.transfer.Transferable;

	import flash.events.Event;
	import flash.geom.Rectangle;

	[Skinable(skin="ListCell")]
	public class DefaultTableRow extends DraggablePanel implements ListCell, 
																   TableRow, 
																   Component, 
																   IDisplayObject, 
																   IInteractiveObject,
																   IDisplayObjectContainer
	{
		protected var _owner : List;
		protected var _columns : Array;
		protected var _data : *;
		protected var _action : Action;
		protected var _index : uint;
		protected var _allowEdit : Boolean;
		protected var _table : Table;

		public function DefaultTableRow () 
		{
			_columns = [];
			_action = new TableRowSelectAction( this );
			super();
			_childrenLayout = new HBoxLayout(this,0);
			_allowFocus = false;
			_allowChildrenFocus = false;			_allowOver = true;			_allowPressed = true;
			_allowSelected = true;
		}
		public function buildChildren () : void
		{	
			if( _data != null && _columns )
			{
				var l1 : Number = _columns.length;				var l2 : Number = _children.length;				var l : Number = Math.max( l1, l2 );
				var i : Number;
				
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { var a : Array = []; }
				TARGET::FLASH_10 { var a : Vector.<Component> = new Vector.<Component>(); }
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				var a : Vector.<Component> = new Vector.<Component>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				var item : TableCell;
				var column : TableColumn;
				
				for( i = 0; i < l; i++ )
				{
					item = i < l2 ? _children[ i ] as TableCell : null;
					column = i < l1 ? _columns[ i ] as TableColumn : null;
					
					if( item && ( column && !(item is column.cellClass) ) )
					{
						if( containsComponent( item ) )
							removeComponent( item );
							
						item = null;
					}
					
					if( i < _columns.length )
					{
						if( item == null)
						{
							item = getCell( column );
							addComponent( item );
						}
						a.push( item );
					}
					else if( i < numChildren && item )
					{
						removeComponent( item );
					}				
				}
				_children = a;
			}
			
		}	
		protected function updateCells () : void
		{
			var l : Number = _children.length;
			var i : Number;
			var column : TableColumn;
			var item : TableCell;
			var cl : HBoxLayout = _childrenLayout as HBoxLayout;				
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { cl.boxes = []; }			TARGET::FLASH_10 { cl.boxes = new Vector.<BoxSettings>(); }			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			cl.boxes = new Vector.<BoxSettings>();	/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			for( i=0;i<l;i++ )
			{
				column = _columns[i] as TableColumn;
				item = _children[i] as TableCell;
				
				item.table = table;
				item.owner = owner;
				item.column = column;
				item.field = column.field;
				item.width = column.finalSize;
				var v : * = ( _data as Object ).hasOwnProperty( column.field ) ? _data[ column.field ] : "No Data";
				item.value = column.formatFunction != null ? column.formatFunction( v ) : v ;
				item.index = index;
				item.allowEdit = _allowEdit;
				cl.boxes.push( new BoxSettings( column.finalSize, "left", "center", item, true, true ) );
			}
		}
		public function getCell ( column : TableColumn ) : TableCell
		{
			var c : Class = column.cellClass;
			var item : TableCell = new c() as TableCell;
			item.owner = _owner;
			item.table = _table;	
			item.row = this;
			item.enabled = _enabled;
			item.column = column;
			item.focusParent = this;
			
			return item;
		}
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get cells () : Array { return _children; }
		
		TARGET::FLASH_10
		public function get cells () : Vector.<Component> { return _children; }
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function get cells () : Vector.<Component> { return _children; }
		
		public function set columns ( a : Array ) : void
		{
			var l : Number = _columns ? _columns.length : -1;
			
			_columns = a;
			
			if( !_columns || l != _columns.length )
				buildChildren();
			
			updateCells ();
			invalidatePreferredSizeCache();
		}
		public function updateColumSize () : void
		{
			updateCells ();
			invalidatePreferredSizeCache();
		}
		public function updateColumns () : void
		{
			updateCells ();
			invalidatePreferredSizeCache();
		}
		public function get columns () : Array
		{
			return _columns;
		}
		public function get value () : * { return _data; }
		public function set value (val : *) : void
		{
			_data = val;
			updateCells ();
			invalidatePreferredSizeCache();
		}
		public function get owner () : List { return _owner; }
		public function set owner (l : List) : void
		{
			_owner = l;
		}
		public function get index () : uint { return _index; }	
		public function set index (index : uint) : void
		{
			_index = index;
		}

		override public function ensureRectIsVisible (r : Rectangle) : Component
		{
			r.y += y;
			_owner.ensureRectIsVisible(r);
			
			return this;
		}
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get transferData () : Transferable
		{
			return new TableTransferable( _data, _owner, "move", _owner.children.indexOf(this) );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function get firstEditableComponent() : Editable
		{
			var l : uint = _children.length;
			for(var i : uint = 0;i<l;i++)
			{
				var c : Component = _children[i];
				if( c is Editable && ( c as Editable ).allowEdit )
					return c as Editable;
			}
			return null;
		}
		
		public function get lastEditableComponent() : Editable
		{
			var l : uint = _children.length;
			while(l--)
			{
				var c : Component = _children[l];
				if( c is Editable && ( c as Editable ).allowEdit )
					return c as Editable;
			}
			return null;
		}
		override public function focusNextChild (child : Focusable) : void
		{
			
			var index : int = _children.indexOf( child );
			if( index == _children.length-1 )
			{
				var b : Boolean = false;
				var c : DefaultTableRow;
				if( child is Editable && (child as Editable).isEditing )
				{
					(child as Editable).confirmEdit();
					b = true;
				}
				var rindex : int = this.index+1;
				
				if( b )
				{
					if( rindex < _owner.model.size )
					{
						_owner.ensureIndexIsVisible(rindex);
						c = _owner.getListCellWithIndex(rindex) as DefaultTableRow;
					}
					else
					{
						_owner.ensureIndexIsVisible(0);
						c = _owner.getListCellWithIndex(0) as DefaultTableRow;
					}
				
					_owner.ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );
					
					if( c.firstEditableComponent )				
						c.firstEditableComponent.startEdit();
				}
				else super.focusNextChild( child );
			}
			else
				super.focusNextChild( child );
		}

		override public function focusPreviousChild (child : Focusable) : void
		{
			/*
			var index : int = _children.indexOf( child );
			if( index == 0 )
			{
				var b : Boolean = false;
				var c : DefaultTableRow;
				if( child is Editable && (child as Editable).isEditing )
				{
					(child as Editable).confirmEdit();
					b = true;
				}
				var rindex : int = this.index-1;
				
				if( rindex >= 0 )
				{
					_owner.ensureIndexIsVisible(rindex);
					c = _owner.getListCellWithIndex(rindex) as DefaultTableRow;
				}
				else
				{
					_owner.ensureIndexIsVisible( _owner.model.size-1 );
					c = _owner.getListCellWithIndex( _owner.model.size-1 ) as DefaultTableRow;
				}
				
				_owner.ensureRectIsVisible( new Rectangle( c.lastChild.x, c.y, c.lastChild.width, c.height ) );
				
				if( c.lastChild is Editable && b )				
					(c.lastChild as Editable).startEdit();
			}
			else*/
				super.focusPreviousChild( child );
		}

		public function init () : void
		{
		}
		public function dispose () : void
		{
		}
		
		public function get selected () : Boolean { return _selected; }		
		public function set selected (b : Boolean) : void
		{
			if( b != _selected )
			{
				_selected = b;
				invalidate();
				fireChangeEvent();
				fireComponentEvent( ComponentEvent.SELECTED_CHANGE );
				
				for each( var c : ListCell in _children)
					c.selected = b;
			}
		}

		override public function click (e : Event = null) : void
		{
			super.click();
			if( _action )
				_action.execute(e);
		}

		public function startEdit () : void {}		
		public function cancelEdit () : void {}		
		public function confirmEdit () : void {}		
		public function get allowEdit () : Boolean { return _allowEdit; }		
		public function get editor () : Editor { return null; }		
		public function get isEditing () : Boolean { return false; }		
		public function get supportEdit () : Boolean { return true; }		
		public function set allowEdit (b : Boolean) : void 		
		{
			_allowEdit = b;
			for each( var c : ListCell in _children)
					c.allowEdit = b;
		}
		
		public function get table () : Table { return _table; }		
		public function set table (table : Table) : void
		{
			_table = table;
		}
	}
}

import aesia.com.ponents.actions.AbstractAction;
import aesia.com.ponents.lists.List;
import aesia.com.ponents.tables.DefaultTableRow;

import flash.events.Event;
import flash.events.MouseEvent;

internal class TableRowSelectAction extends AbstractAction 
{
	protected var _row : DefaultTableRow;

	public function TableRowSelectAction ( row : DefaultTableRow )
	{
		_row = row;
	}
	
	override public function execute (e : Event = null) : void
	{
		var list : List = _row.owner;
		var evt : MouseEvent = e as MouseEvent;
		
		if( evt.shiftKey && list.allowMultiSelection )
		{
			/*
			if( cell.selected )
				list.removeFromSelection( cell );
			else*/
				list.expandSelectionTo( _row );
		}
		else if( evt.ctrlKey && list.allowMultiSelection )
		{
			if( _row.selected )
				list.removeFromSelection( _row );
			else
				list.addToSelection( _row );
		}
		else if( list.allowMultiSelection )
		{
			if( _row.selected )
				list.selectedIndices = [];
			else 
			{
				list.selectedIndices = [ _row.index ];
				list.ensureCellIsVisible( _row );
			}
		}
		else
		{
			if( list.selectedIndex == _row.index )
				list.selectedIndex = -1;
			else
				list.selectedIndex = _row.index;
		}
		
	}
}
