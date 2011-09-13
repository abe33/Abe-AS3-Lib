package abe.com.ponents.text 
{
    import abe.com.mon.core.ITextField;
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.scrollbars.Scrollable;

    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
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
		public function getScrollableBlockIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return direction; }	
		public function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return direction; }
		
		public function get preferredViewportSize () : Dimension
		{
			return new Dimension ( textWidth + 4, textHeight + 4 );
		}
		
		public function get tracksViewportH () : Boolean { return multiline && wordWrap; }		
		public function get tracksViewportV () : Boolean { return false; }	
		
		override public function set defaultTextFormat (format : TextFormat) : void 
		{
			if( !styleSheet && format )
				super.defaultTextFormat = format;
		}
		override public function set textColor (value : uint) : void 
		{
			if( !styleSheet )
				super.textColor = value;
		}
	}
}
