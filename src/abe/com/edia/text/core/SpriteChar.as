/**
 * @license
 */
package abe.com.edia.text.core 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public class SpriteChar extends Sprite implements Char 
	{
		private var _link : String;
		public function set link ( s  : String ) : void
		{
			_link = s;
			buttonMode = true;
			useHandCursor = true;
			mouseEnabled = true;
			addEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
		
		protected function mouseUp ( e : MouseEvent ) : void
		{
			dispatchEvent( new TextEvent( TextEvent.LINK, true, true, _link ) );
		}
		
		public function get link () : String
		{
			return _link;
		}

		public function get charWidth () : Number
		{
			return width;
		}
		
		public function get charHeight () : Number
		{
			return height;
		}
		
		public function get text () : String
		{
			return "";
		}
		public function set text (s : String) : void
		{
		}
		
		public function get format () : TextFormat
		{
			return null;
		}
		public function set format (tf : TextFormat) : void
		{
		}
		
		public function get background () : Boolean
		{
			return false;
		}
		
		public function get backgroundColor () : uint
		{
			return 0xffffff;
		}
		
		public function set background (b : Boolean) : void
		{
		}
		
		public function set backgroundColor (b : uint) : void
		{
		}
	}
}
