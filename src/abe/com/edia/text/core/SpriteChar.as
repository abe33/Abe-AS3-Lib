/**
 * @license
 */
package abe.com.edia.text.core 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public class SpriteChar extends Sprite implements Char 
	{
		protected var _text : String;

		public function SpriteChar ( spr : DisplayObject = null, text : String = "" ) 
		{
			if( spr )
				addChild( spr );
			_text = text;
		}

		private var _link : String;
		public function set link ( s  : String ) : void
		{
			_link = s;
			buttonMode = true;
			useHandCursor = true;
			mouseEnabled = true;
			addEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
		public function get link () : String 					{ return _link; }
		public function get charWidth () : Number				{ return width; }
		public function get charHeight () : Number 				{ return height; }
		public function get text () : String 					{ return _text; }
		public function get format () : TextFormat				{ return null; }
		public function get background () : Boolean 			{ return false; }
		public function get backgroundColor () : uint 			{ return 0xffffff; }
		public function get charContent () : DisplayObject		{ return getChildAt(0); }
		public function get baseline () : Number 				{ return height; }
		public function set text (s : String) : void 			{}
		public function set format (tf : TextFormat) : void 	{}
		public function set background (b : Boolean) : void 	{}
		public function set backgroundColor (b : uint) : void 	{}
		protected function mouseUp ( e : MouseEvent ) : void 	{ dispatchEvent( new TextEvent( TextEvent.LINK, true, true, _link ) ); }
		override public function toString () : String {	return text; }
	}
}
