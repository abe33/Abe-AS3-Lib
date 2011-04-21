/**
 * @license
 */
package abe.com.edia.text.core 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class TabChar extends NullChar
	{
		
		override public function get text () : String
		{
			return "\\t";
		}
	}
}
