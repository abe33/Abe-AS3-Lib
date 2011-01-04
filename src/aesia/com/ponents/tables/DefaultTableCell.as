package aesia.com.ponents.tables 
{
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.lists.DefaultListCell;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TableCell")]	[Skin(define="TableCell",
		  inherit="ListCell",
		  
		  state__0_1_2_3_8_9_10_11__background="skin.emptyDecoration",		  state__all__foreground="new deco::SimpleBorders(skin.listSelectedBackgroundColor)",
		  state__all__borders="new cutils::Borders(0,0,1,0)",		  state__all__insets="new cutils::Insets(0,0,1,0)"
	)]
	public class DefaultTableCell extends DefaultListCell implements TableCell 
	{
		protected var _table : Table;
		protected var _row : TableRow;
		protected var _field : String;
		protected var _column : TableColumn;

		public function DefaultTableCell ()
		{
			super();
			action = null;
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			allowDrag = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			_allowFocus = true;
			_allowOverEventBubbling = true;
		}
		
		public function get table () : Table { return _table; }		
		public function set table (table : Table) : void
		{
			_table = table;
		}		
		public function get row () : TableRow { return _row; }		
		public function set row (row : TableRow) : void
		{
			_row = row;
		}
		
		public function get column (): TableColumn { return _column; }
		public function set column ( t : TableColumn ) : void
		{
			_column = t;
		}
				
		public function get field () : String { return _field; }		
		public function set field (field : String) : void
		{
			_field = field;
			if( _table )
			{
				var b : Boolean = _table.currentSortingField == _field && 
								  _table.currentSortingMethod == _column.sortingMethod;
				_focus = b;
				checkState();
				_table.view.invalidate(true);
			}
			invalidate(true);
		}

		override protected function valueChanged (old : *, nevv : *, id : Number) : void
		{
			var o : Object = _owner.model.getElementAt(index) as Object;
			var oldV : * = o[_field];
			o[_field] = nevv;
			this.label = nevv;
			_owner.model.setElementAt(index, o );
			UndoManagerInstance.add( new DefaultTableCellUndoadleEdit( _owner, this, o, _field, oldV, nevv, index ) );
		}
	}
}

import aesia.com.patibility.lang._;
import aesia.com.ponents.history.AbstractUndoable;
import aesia.com.ponents.history.Undoable;
import aesia.com.ponents.lists.List;
import aesia.com.ponents.tables.TableCell;

internal class DefaultTableCellUndoadleEdit extends AbstractUndoable implements Undoable
{	
	protected var _list : List;
	protected var _oldValue : *;
	protected var _newValue : *;
	protected var _index : Number;	protected var _object : Object;
	protected var _field : String;
	protected var _cell : TableCell;
	
	public function DefaultTableCellUndoadleEdit ( list : List, cell : TableCell, o : Object, f : String, oldValue : *, newValue : *, index : Number )
	{
		_label = _("Edit Table Cell");
		_list = list;
		_object = o;
		_newValue = newValue;
		_oldValue = oldValue;
		_index = index;
		_field = f;
		_cell = cell;
	}
	override public function undo() : void
	{
		_object[_field] = _oldValue;		_cell.value = _oldValue;
		_list.model.setElementAt( _index, _object );
		super.undo();
	}	
	override public function redo() : void
	{
		_object[_field] = _newValue;
		_cell.value = _newValue;
		_list.model.setElementAt( _index, _object );
		super.redo();
	} 
}

