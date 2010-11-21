package aesia.com.ponents.text 
{
	import aesia.com.mon.core.ITextField;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.scrollbars.Scrollable;

	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author Cédric Néhémie
	 */
	public class TextFieldImpl extends TextField implements ITextField, Scrollable
	{
		public function TextFieldImpl ()
		{
			super();
		}
		
		public function getScrollableUnitIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return direction; }		
		public function getScrollableUnitIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return direction; }		
		public function getScrollableBlockIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return direction*3; }	
		public function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return direction*3; }
		
		public function get preferredViewportSize () : Dimension
		{
			return new Dimension ( textWidth + 4, textHeight + 4 );
		}
		
		public function get tracksViewportH () : Boolean { return multiline && wordWrap; }		
		public function get tracksViewportV () : Boolean { return false; }	
	}
}
