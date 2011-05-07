/**
 * @license
 */
package abe.com.edia.text.fx 
{
	import abe.com.edia.text.core.Char;
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Clearable;
	/**
	 * @author Cédric Néhémie
	 */
	public interface CharEffect extends Allocable, Clearable
	{
		function addChar ( l : Char ) : void;
	}
}
