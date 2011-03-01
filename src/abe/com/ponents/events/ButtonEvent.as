/**
 * @license
 */
package abe.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class ButtonEvent extends ComponentEvent 
	{
		static public const BUTTON_CLICK : String = "buttonClick";
		public function ButtonEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}