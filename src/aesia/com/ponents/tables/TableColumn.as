/**
 * @license
 */
package aesia.com.ponents.tables 
{
	public class TableColumn 
	{
		public var name : String;
		public var field : String;
		public var _size : Number;
		public var _finalSize : Number;
		public var sortable : Boolean;
		public var sortingMethod : Function;
		public var formatFunction : Function;
		public var cellClass : Class;
		public var headerClass : Class;
		public function TableColumn ( name : String, 
									  field : String,
									  size : Number = 100, 
									  cellClass : Class = null,
									  headerClass : Class = null,
									  sortable : Boolean = true, 
									  sortingMethod : Function = null,
									  formatFunction : Function = null )
		{
			this.name = name;
			this._size = this._finalSize = size;
			this.field = field;
			this.cellClass = cellClass ? cellClass : DefaultTableCell;
			this.headerClass = headerClass ? headerClass : DefaultTableColumnHeader;
			this.sortable = sortable;			this.sortingMethod = sortingMethod;
			this.formatFunction = formatFunction;
		}

		public function get size () : Number { return _size; }
		public function set size ( n : Number ) : void
		{
			_size = n;
		}
		public function get finalSize () : Number { return _finalSize; }
		public function set finalSize ( n : Number ) : void
		{
			_finalSize = n;
		}	
	}
}
