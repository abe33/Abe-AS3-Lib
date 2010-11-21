package aesia.com.ponents.text 
{
	import aesia.com.mon.core.ITextField;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.scrollbars.Scrollable;

	import fl.text.TLFTextField;

	import flash.geom.Rectangle;

	/**
	 * @author cedric
	 */
	public class TLFTextFieldImpl extends TLFTextField implements ITextField, Scrollable
	{
		public function TLFTextFieldImpl ()
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
