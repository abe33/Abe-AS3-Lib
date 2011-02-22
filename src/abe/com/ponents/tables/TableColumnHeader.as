/**
 * @license
 */
package abe.com.ponents.tables 
{
	public interface TableColumnHeader extends TableCell
	{
		function set sortOrder ( b : Boolean ) : void;		function get sortOrder () : Boolean;
		
		function get sorted () : Boolean;		function set sorted ( b : Boolean ) : void;
	}
}
