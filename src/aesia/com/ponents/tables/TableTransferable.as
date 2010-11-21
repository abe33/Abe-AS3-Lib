package aesia.com.ponents.tables
{
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListTransferable;
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.transfer.Transferable;

	/**
	 * @author Cédric Néhémie
	 */
	public class TableTransferable extends ListTransferable implements Transferable
	{
		public function TableTransferable (data : *, list : List, mode : String = "move", pos : int = 0)
		{
			super( data, list, mode, pos );
		}
		
		override public function get flavors () : Array
		{
			return [ ComponentsFlavors.TABLE_ROW, ComponentsFlavors.LIST_ITEM ];
		}
	}
}