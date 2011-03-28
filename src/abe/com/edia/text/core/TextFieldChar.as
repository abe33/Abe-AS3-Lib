/**
 * @license
 */
package abe.com.edia.text.core 
{
	import abe.com.mon.core.Allocable;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public class TextFieldChar extends TextField implements Char, Allocable
	{
		protected var _safeText : String;

		public function TextFieldChar ()
		{
		}
				
		public function get charWidth () : Number
		{
			return textWidth;
		}

		override public function get text () : String { return _safeText; }
		override public function set text (value : String) : void
		{
			htmlText = _safeText = value;
		}

		public function get format () : TextFormat
		{
			return defaultTextFormat;
		}
		
		public function set format ( tf : TextFormat ) : void
		{
			defaultTextFormat = tf;
			text = text;
		}
		
		override public function toString() : String 
		{
			return text;
		}
		
		public function get charHeight () : Number
		{
			return defaultTextFormat != null ? defaultTextFormat.size as Number : textHeight;
		}
		
		public function init () : void
		{
			scaleX = scaleY = 1;
			alpha = 1;
		}
		
		public function dispose () : void
		{
			scaleX = scaleY = 1;
			alpha = 1;
		}
	}
}
