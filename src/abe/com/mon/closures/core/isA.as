/**
 * @license
 */
package abe.com.mon.closures.core
{
	/**
	 * Returns a function that can be used in combination with the 
	 * <code>Array.some</code> and <code>Array.every</code> methods.
	 *  
	 * @author Cédric Néhémie
	 */
	public function isA ( cls : Class ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return o is cls; };
	}
}
