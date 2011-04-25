/**
 * @license
 */
package abe.com.edia.text.core 
{
	import flash.display.DisplayObject;

	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.ITextField;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	/**
	 * @author Cédric Néhémie
	 */
	public class TextFieldChar extends Sprite implements ITextField, Char, Allocable
	{
		protected var _textField : TextField;
		protected var _safeText : String;

		public function TextFieldChar ()
		{
			_textField = new TextField();
			addChild( _textField );
		}
		public function get charWidth () : Number { return textWidth; }
		public function get charHeight () : Number { return _textField.defaultTextFormat != null ? 
															_textField.defaultTextFormat.size as Number : 
															_textField.textHeight;	}

		public function get text () : String { return _textField.text; }
		public function set text (value : String) : void { _textField.htmlText = _safeText = value; }

		public function get format () : TextFormat { return _textField.defaultTextFormat; }
		public function set format ( tf : TextFormat ) : void
		{
			_textField.defaultTextFormat = tf;
			_textField.htmlText = _safeText;
		}
		
		public function get charContent () : DisplayObject 		{ return _textField; }
		public function get htmlText () : String 				{ return _textField.htmlText; }
		public function get length () : int 					{ return _textField.length; }
		public function get numLines () : int 					{ return _textField.numLines; }
		public function get type () : String 					{ return _textField.type; }
		public function get autoSize () : String				{ return _textField.autoSize; }
		public function get caretIndex () : int					{ return _textField.caretIndex; }
		public function get selectionBeginIndex () : int 		{ return _textField.selectionBeginIndex; }
		public function get selectionEndIndex () : int			{ return _textField.selectionEndIndex; }
		public function get defaultTextFormat () : TextFormat	{ return _textField.defaultTextFormat; }
		public function get textColor () : uint					{ return _textField.textColor; }
		public function get multiline () : Boolean				{ return _textField.multiline; }
		public function get alwaysShowSelection () : Boolean 	{ return _textField.alwaysShowSelection; }
		public function get maxChars () : int					{ return _textField.maxChars; }
		public function get displayAsPassword () : Boolean		{ return _textField.displayAsPassword; }
		public function get wordWrap () : Boolean				{ return _textField.wordWrap; }
		public function get embedFonts () : Boolean				{ return _textField.embedFonts; }
		public function get selectable () : Boolean				{ return _textField.selectable;	}
		public function get textWidth () : Number				{ return _textField.textWidth; }
		public function get textHeight () : Number				{ return _textField.textHeight; }
		public function get maxScrollV () : int					{ return _textField.maxScrollV;	}
		public function get bottomScrollV () : int				{ return _textField.bottomScrollV; }
		public function get scrollV () : int					{ return _textField.scrollV; }
		public function get maxScrollH () : int					{ return _textField.maxScrollH; }
		public function get scrollH () : int					{ return _textField.scrollH; }
		public function get background () : Boolean				{ return _textField.background; }
		public function get backgroundColor () : uint			{ return _textField.backgroundColor; }
		public function get baseline () : Number				{ return _textField.getLineMetrics( 0 ).ascent;	}
		
		public function set htmlText (s : String) : void				{ _textField.htmlText = s; }
		public function set type (s : String) : void					{ _textField.type = s; }
		public function set autoSize (s : String) : void				{ _textField.autoSize = s; }
		public function set defaultTextFormat (tf : TextFormat) : void 	{ _textField.defaultTextFormat = tf; }
		public function set textColor (c : uint) : void					{ _textField.textColor = c;	}
		public function set multiline (b : Boolean) : void				{ _textField.multiline = b; }
		public function set alwaysShowSelection (b : Boolean) : void	{ _textField.alwaysShowSelection = b; }
		public function set maxChars (m : int) : void					{ _textField.maxChars = m; }
		public function set displayAsPassword (b : Boolean) : void		{ _textField.displayAsPassword = b; }
		public function set wordWrap (b : Boolean) : void				{ _textField.wordWrap = b; }
		public function set embedFonts (b : Boolean) : void				{ _textField.embedFonts = b; }
		public function set selectable (b : Boolean) : void				{ _textField.selectable = b; }
		public function set scrollV (s : int) : void					{ _textField.scrollV = s; }
		public function set scrollH (s : int) : void					{ _textField.scrollH = s; }
		public function set background (b : Boolean) : void				{ _textField.background = b; }
		public function set backgroundColor (b : uint) : void			{ _textField.backgroundColor = b; }
		
		public function init () : void
		{
			reset();
		}
		public function dispose () : void
		{
			reset();
		}
		public function reset() : void
		{			scaleX = scaleY = 1;
			_textField.scaleX = _textField.scaleY = 1;
			_textField.x = _textField.y = 0;
			alpha = 1;
		}
		
		public function appendText (s : String) : void 						{ _textField.appendText(s); }
		public function getCharBoundaries (charIndex : int) : Rectangle 	{ return _textField.getCharBoundaries(charIndex); }
		public function getCharIndexAtPoint (x : Number, y : Number) : int 	{ return _textField.getCharIndexAtPoint(x, y); }
		public function getFirstCharInParagraph (charIndex : int) : int		{ return _textField.getFirstCharInParagraph(charIndex);	}
		public function getLineIndexAtPoint (x : Number, y : Number) : int	{ return _textField.getLineIndexAtPoint(x, y); }
		public function getLineIndexOfChar (charIndex : int) : int			{ return _textField.getLineIndexOfChar(charIndex); }
		public function getLineLength (lineIndex : int) : int				{ return _textField.getLineLength(lineIndex); }
		public function getLineMetrics (lineIndex : int) : TextLineMetrics	{ return _textField.getLineMetrics(lineIndex); }
		public function getLineOffset (lineIndex : int) : int 				{ return _textField.getLineOffset(lineIndex); }
		public function getLineText (lineIndex : int) : String				{ return _textField.getLineText(lineIndex);	}
		public function getParagraphLength (charIndex : int) : int			{ return _textField.getParagraphLength(charIndex); }
		public function replaceSelectedText (value : String) : void			{ _textField.replaceSelectedText(value); }
		public function replaceText (beginIndex : int, endIndex : int, newText : String) : void	{ _textField.replaceText(beginIndex, endIndex, newText); }
		public function setSelection (beginIndex : int, endIndex : int) : void { _textField.setSelection(beginIndex, endIndex); }
		
		override public function toString() : String { return text; }
	}
}
