/**
 * @license
 */
package  aesia.com.ponents.tables 
{
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.models.ListModel;

	[Event(name="selectionChange", type="aesia.com.ponents.events.ComponentEvent")]
	public class Table extends ScrollPane
	{		
		static public const SORT_CHANGE : String = "sortChange";
		
		private var _columns : Array;
		private var _list : TableList;
		private var _header : TableHeader;

		private var _currentSortingField : String;
		private var _currentSortingOrder : Boolean;
		private var _currentSortingMethod : Function;
		
		public function Table ( ... args )
		{
			_columns = [];
			
			_list = new TableList( args );
			_list.owner = this;
			
			_header = new TableHeader();
			_header.table = this;
			_header.addEventListener(ComponentEvent.DATA_CHANGE, headerDataChanged );
			
			super();
			view = _list;
			colHead = _header;
		}

		/*-----------------------------------------------------------------------------------
		 * TABLE API
		 *----------------------------------------------------------------------------------*/

		public function sortBy ( field : String, invert : Boolean = false, sortMethod : Function = null ) : void
		{
			_currentSortingField = field;
			_currentSortingOrder = invert;
			_currentSortingMethod = sortMethod;
			
			if( sortMethod != null )
			{
				if( invert )
					_list.model.sort( sortMethod, Array.DESCENDING | Array.CASEINSENSITIVE );
				else
					_list.model.sort( sortMethod, Array.CASEINSENSITIVE );
			}
			else
			{
				_list.model.sortOn( field, invert ? Array.DESCENDING | Array.CASEINSENSITIVE : Array.CASEINSENSITIVE );
			}
			_header.updateColumnsSort();
		}
		
		/*-----------------------------------------------------------------------------------
		 * GETTERS SETTERS
		 *----------------------------------------------------------------------------------*/
		public function get header () : TableHeader { return _header; }		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		public function get dragEnabled () : Boolean { return _list.dragEnabled }
		public function set dragEnabled (dragEnabled : Boolean) : void
		{
			_list.dragEnabled = dragEnabled;
		}
		public function get dropEnabled () : Boolean { return _list.dropEnabled }
		public function set dropEnabled (dropEnabled : Boolean) : void
		{
			_list.dropEnabled = dropEnabled;
		}
		public function set dndEnabled (dndEnabled : Boolean) : void
		{
			_list.dndEnabled = dndEnabled;
		}
		public function set headerDnDEnabled ( b : Boolean ) : void
		{
			_header.dndEnabled = b;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function get editEnabled () : Boolean { return _list.editEnabled; }		
		public function set editEnabled (editEnabled : Boolean) : void
		{
			doubleClickEnabled = editEnabled;
			_list.editEnabled = editEnabled;
		}
		public function get allowMultiSelection () : Boolean { return _list.allowMultiSelection; }		
		public function set allowMultiSelection ( b : Boolean) : void
		{
			_list.allowMultiSelection = b;
		}
		public function get model() : ListModel { return _list.model; }
		public function set model( m : ListModel ) : void 
		{ 
			_list.listLayout.clearEstimatedSize();
			_list.model = m; 
		} 
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get items () : Array { return _list.items; }
		TARGET::FLASH_10
		public function get items () : Vector.<Component> { return _list.items; }
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function get items () : Vector.<Component> { return _list.items; }

		public function get selectedIndex() : Number { return _list.selectedIndex; }
		public function set selectedIndex( i : Number ) : void
		{
			_list.selectedIndex = i;
		}
		public function get selectedValue() : * { return _list.selectedValue; }		
		public function get currentSortingField () : String { return _currentSortingField; }
		public function get currentSortingOrder () : Boolean { return _currentSortingOrder; }
		public function get currentSortingMethod () : Function { return _currentSortingMethod; }
				
		public function get allowMultipleSelection () : Boolean { return _list.allowMultiSelection; }
		public function set allowMultipleSelection ( b : Boolean ) : void
		{
			_list.allowMultiSelection = b;
		}
		public function get selectedIndices () : Array { return _list.selectedIndices; }
		public function set selectedIndices ( a : Array ) : void
		{
			_list.selectedIndices = a;
		}
		
		public function get loseSelectionOnFocusOut () : Boolean { return _list.loseSelectionOnFocusOut; }		public function set loseSelectionOnFocusOut ( b : Boolean ) : void 
		{ 
			_list.loseSelectionOnFocusOut = b; 
		}

		public function get selectedValues () : Array { return _list.selectedValues; }
		
		protected function headerDataChanged (event : ComponentEvent) : void
		{
			_list.columns = _header.columns;

			layout.hscrollbar.invalidate(true );
		}
		
		public function get list () : TableList { return _list; 
		}
	}
}