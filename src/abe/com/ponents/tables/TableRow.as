package abe.com.ponents.tables 
{
	import abe.com.ponents.lists.ListCell;
	/**
	 * @author Cédric Néhémie
	 */
	public interface TableRow extends ListCell
	{
		function get columns () : Array;		function set columns ( a : Array ) : void;
		
		function set table ( t : Table ) : void;		
		function get table () : Table;
		
		function updateColumSize () : void;
		function updateColumns () : void;
	}
}
