package aesia.com.ponents.tables
{
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.transfer.DataFlavor;
	import aesia.com.ponents.transfer.Transferable;

	/**
	 * @author Cédric Néhémie
	 */
	public class TableColumnTransferable implements Transferable
	{
		private var _data : *;
		private var _table : Table;
		private var _mode : String;
		private var _pos : int;

		public function TableColumnTransferable ( data : *, table : Table, mode : String = "move", pos : int = 0)
		{
			_data = data;
			_table = table;
			_mode = mode;
			_pos = pos;
		}
		public function getData (flavor : DataFlavor) : *
		{
			if( flavor.isSupported( flavors ) )
				return _data;
			else
				return null;
		}
		public function transferPerformed () : void
		{
			
		}
		
		public function get flavors () : Array
		{
			return [ ComponentsFlavors.TABLE_COLUMN ];
		}
		public function get mode () : String
		{
			return _mode;
		}
	}
}
