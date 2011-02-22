/**
 * @license
 */
package abe.com.ponents.tables 
{
	import abe.com.ponents.lists.ListCell;

	public interface TableCell extends ListCell 
	{
		function set table ( t : Table ) : void;		
		function get table () : Table;
		
		function set row ( r : TableRow ) : void;
		function get row () : TableRow;
		
		function get column (): TableColumn; 
		function set column ( t : TableColumn ) : void
		
		function set field ( s : String ) : void;
		function get field () : String;
	}
}
