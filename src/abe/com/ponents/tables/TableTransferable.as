package abe.com.ponents.tables
{
    import abe.com.ponents.lists.List;
    import abe.com.ponents.lists.ListTransferable;
    import abe.com.ponents.transfer.ComponentsFlavors;
    import abe.com.ponents.transfer.Transferable;
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