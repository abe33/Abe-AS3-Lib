package abe.com.ponents.tables 
{
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.transfer.Transferable;

	import flash.events.Event;
	import flash.events.FocusEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="ascendingIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="descendingIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="ColumnHeader")]
	[Skin(define="ColumnHeader",
		  //inherit="ListCell",		  inherit="EmptyComponent",
		  state__all__insets="new cutils::Insets(4,0,0,0)",
		  custom_ascendingIcon="icon(abe.com.ponents.tables::DefaultTableColumnHeader.ASCENDING_ICON)",		  custom_descendingIcon="icon(abe.com.ponents.tables::DefaultTableColumnHeader.DESCENDING_ICON)"
	)]
	public class DefaultTableColumnHeader extends DefaultTableCell implements TableColumnHeader 
	{
		[Embed(source="../skinning/icons/scrollup.png")]
		static public var ASCENDING_ICON : Class;
		
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var DESCENDING_ICON : Class;
		
		protected var _sortOrder : Boolean;
		protected var _sorted : Boolean;
		
		public function DefaultTableColumnHeader ()
		{
			super();
			doubleClickEnabled = false;
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			allowDrag = true;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		override public function get supportEdit () : Boolean { return false; }
		public function get sortOrder () : Boolean {	return _sortOrder; }		
		public function set sortOrder (sortOrder : Boolean) : void
		{
			_sortOrder = sortOrder;
			updateIcon();
		}
		
		private function updateIcon () : void
		{
			if( _sorted )
			{
				if( _sortOrder )
					icon = _style.ascendingIcon.clone();
				else
					icon = _style.descendingIcon.clone();
			}
			else
			{
				clearIcon();
			}
		}
		private function clearIcon () : void
		{
			icon = null;
		}

		public function get sorted () : Boolean { return _sorted; }		
		public function set sorted (sorted : Boolean) : void
		{
			_focus = _sorted = sorted;
			updateIcon();
		}

		override public function repaint () : void
		{
			super.repaint();
		}

		override public function set column (column : TableColumn) : void
		{
			super.column = column;
			sorted = _table.currentSortingField == column.field &&
					 _table.currentSortingMethod == column.sortingMethod;
		}

		override public function click () : void
		{
			super.click();
			if( _column.sortable )
			{
				if ( _sorted )
				{
					sortOrder = !_sortOrder;
					_table.sortBy( _column.field, _sortOrder, column.sortingMethod );
				}
				else
				{
					_sortOrder = false;
					sorted = true;
					_table.sortBy( _column.field, _sortOrder, column.sortingMethod );
				}
			}
		}

		override public function focusOut (e : FocusEvent) : void
		{
			super.focusOut( e );
			_focus =  _table.currentSortingField == column.field &&
					  _table.currentSortingMethod == column.sortingMethod;
			invalidate();
		}

		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get transferData () : Transferable
		{
			return new TableColumnTransferable( _column, _table, "move" );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		override protected function stylePropertyChanged ( event : PropertyEvent ) : void
		{
			switch( event.propertyName )
			{
				case "ascendingIcon" : 
				case "descendingIcon" : 
					updateIcon();
					break;	
				default : 
					super.stylePropertyChanged( event );
					break;
			}
		}
	}
}
