/**
 * @license
 */
package abe.com.ponents.tables 
{
	public interface TableColumnHeader extends TableCell
	{
		function set sortOrder ( b : Boolean ) : void;
		
		function get sorted () : Boolean;
	}
}