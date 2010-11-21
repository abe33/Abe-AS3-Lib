/**
 * @license
 */
package aesia.com.ponents.events 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class ButtonEvent extends ComponentEvent 
	{
		static public const BUTTON_CLICK : String = "buttonClick";		static public const BUTTON_RELEASE_OUTSIDE : String = "buttonReleaseOutside";		static public const BUTTON_DBLE_CLICK : String = "buttonDbleClick";		
		public function ButtonEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
