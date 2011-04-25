/**
 * @license
 */
package abe.com.edia.text.core 
{
	/**
	 * @author Cédric Néhémie
	 */
	public class SpaceChar extends TextFieldChar 
	{
		public function SpaceChar () 
		{
			text = " ";
		}
		override public function get text () : String { return " "; }
	}
}
