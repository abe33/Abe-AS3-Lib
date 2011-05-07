package abe.com.ponents.text 
{
	import abe.com.mon.core.ITextField;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.scrollbars.Scrollable;

	import fl.text.TLFTextField;

	import flash.display.DisplayObject;
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
		
		public function get preferredViewportSize () : Dimension { return dm ( textWidth + 4, textHeight + 6 ); }
		
	 	override public function get y () : Number { return super.y - 2; }
		override public function set y ( value : Number ) : void { super.y = value + 2;  }

		public function get tracksViewportH () : Boolean { return multiline && wordWrap; }		
		public function get tracksViewportV () : Boolean { return false; }	
        
		override public function getBounds (targetCoordinateSpace : DisplayObject) : Rectangle 
		{
			var r : Rectangle = super.getBounds( targetCoordinateSpace );
			r.y -= 2;
			r.height += 2;			
			return r;
		}
	}
}
