/**
 * @license
 */
package abe.com.mon.core 
{
	import abe.com.mon.randoms.Random;
	/**
	 * A <code>Randomizable</code> object is subject to random in its behavior. 
	 * A <code>Randomizable</code> object defines a <code>randomSource</code>, another
	 * object dedicated to provide random values when requested by the <code>Randomizable</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Randomizable 
	{
		/**
		 * A reference to the <code>Random</code> object to use as source for 
		 * random values.
		 */
		function get randomSource() : Random;
		function set randomSource( randomSource : Random ) : void;
	}
}
