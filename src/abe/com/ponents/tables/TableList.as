package abe.com.ponents.tables 
{
	import abe.com.ponents.core.Component;
	import abe.com.ponents.dnd.DropTargetDragEvent;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.lists.ListCell;
	import abe.com.ponents.transfer.ComponentsFlavors;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class TableList extends List
	{
		protected var _columns : Array;
		protected var _owner : Table;
		
		public function TableList ( a : Array )
		{
			_listCellClass = DefaultTableRow;
			super( a );
			_allowChildrenFocus = true;
		}

		public function get columns () : Array { return _columns; }		
		public function set columns (columns : Array) : void
		{
			_columns = columns;
			for each( var row : TableRow in _children )
				row.columns = columns;
			
			listLayout.clearEstimatedSize();
			invalidatePreferredSizeCache();
			//fireComponentEvent( ComponentEvent.DATA_CHANGE );
		}		
		public function get owner () : Table { return _owner; }		
		public function set owner (owner : Table) : void
		{
			_owner = owner;
			invalidatePreferredSizeCache();
		}
		
		public function updateColumns () : void
		{
			for each( var row : TableRow in _children )
				row.updateColumns();
		}
		public function updateColumnSize() : void
		{
			for each( var row : TableRow in _children )
				row.updateColumSize();
		}
		override public function get tracksViewportH () : Boolean
		{
			return preferredWidth < parentContainer.width;
		}

		override protected function getCell ( itemIndex : int = 0, childIndex : int = 0  ) : ListCell
		{
			var row : TableRow = super.getCell( itemIndex, childIndex ) as TableRow;
			if( row )
			{
				row.table = _owner;
				row.owner = this;
			}
			return row;
		}

		override protected function setCell (cell : ListCell, data : *, index : uint) : void
		{
			super.setCell(cell, data, index);
			var row : TableRow = cell as TableRow;
			if( row )
			{
				row.columns = _columns;
				row.table = owner;
				row.owner = this;
			}
		}
		override public function getScrollableUnitIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number 
		{ 
			var lc : Component;
			var increment : Number;
			
			lc = getComponentUnderPoint( new Point( r.x + 2, r.y + 2 ) );
			if( lc )
			{
				if( direction > 0 )
					increment = x + lc.x + lc.width;
				else
				{
					var index : Number = _children.indexOf(lc) - 1;
					
					if( index >= 0 )
						increment = x + _children[index].x;
					else
						increment = x;
				}
			}
			else
				increment = direction;
			
			return increment; 
		}
		override public function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number 
		{ 
			var lc : Component;
			var increment : Number;
			
			lc = getComponentUnderPoint( new Point( r.x + 2, r.y + 2 ) );
				
			if( lc )
			{
				var index : Number = _children.indexOf( lc );
				
				if( direction > 0 )
				{
					index += 3;
					if( index < _children.length )
					{
						lc = _children[index];
						increment = x + lc.x;
					}
					else
						increment = x + ( width - r.width );
				}
				else
				{
					index -= 3;
					if( index > -1 )
					{
						lc = _children[index];
						increment = x + lc.x;
					}
					else
						increment = x * -1;
				}	
			}
			else
				increment = direction*10;
			
			return increment; 
		}
		FEATURES::DND { 
		override public function get supportedFlavors () : Array
		{
			return super.supportedFlavors.concat( ComponentsFlavors.TABLE_ROW );
		}
		
		override public function dragEnter (e : DropTargetDragEvent) : void
		{
			if( ComponentsFlavors.TABLE_ROW.isSupported( e.flavors ) )
			{
				startScrollDuringDragInterval();
				e.acceptDrag(this);
			}
			else
				super.dragEnter( e );
		}
		} 
	}
}
