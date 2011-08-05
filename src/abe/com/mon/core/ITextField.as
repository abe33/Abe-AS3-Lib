/**
 * @license
 */
package abe.com.mon.core 
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	/**
	 * An interface that mimic the structure of the <code>TextField</code>
	 * class in order to allow an access to its members from an interface which
	 * concret classes will extends a display class from Flash.
	 * 
	 * <fr>
	 * Interface mimant la structure de la classe <code>TextField</code> servant
	 * ainsi de pont d'accès entre les différentes API de texte.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface ITextField extends IInteractiveObject
	{
		function get text () : String;		function set text ( s : String ) : void;
		
		function get htmlText () : String;
		function set htmlText ( s : String ) : void;

		function get length () : int;		function get numLines () : int;
		
		function get type() : String;
		function set type( s : String ): void;
	
		function get autoSize() : String;
		function set autoSize( s : String ): void;
		
		function get caretIndex () : int;
		function get selectionBeginIndex () : int;
		function get selectionEndIndex () : int;
		
		function get defaultTextFormat () : TextFormat;		function set defaultTextFormat ( tf : TextFormat ) : void;
		
		function get textColor () : uint;
		function set textColor ( c : uint ) : void;
		
		function get multiline () : Boolean;
		function set multiline ( b : Boolean ) : void;
		
		function get alwaysShowSelection () : Boolean;
		function set alwaysShowSelection ( b : Boolean ) : void;
		
		function get maxChars () : int;		function set maxChars ( m : int ) : void;
		
		function get displayAsPassword () : Boolean;
		function set displayAsPassword ( b : Boolean ) : void;

		function get wordWrap () : Boolean;		function set wordWrap ( b : Boolean ) : void;
		
		function get embedFonts () : Boolean;
		function set embedFonts ( b : Boolean ) : void;
		
		function get selectable () : Boolean;		function set selectable ( b : Boolean ) : void;
		
		function appendText( s : String ) : void;
		function getCharBoundaries ( charIndex : int ) : Rectangle;
		function getCharIndexAtPoint ( x : Number, y : Number ) : int;
		function getFirstCharInParagraph( charIndex : int ) : int;
		function getLineIndexAtPoint(x:Number, y:Number) : int;
		function getLineIndexOfChar( charIndex : int ) : int;
		function getLineLength( lineIndex : int ) : int;
		function getLineMetrics( lineIndex : int ) : TextLineMetrics;
		function getLineOffset( lineIndex : int ) : int;
		function getLineText( lineIndex : int ) : String;
		function getParagraphLength( charIndex : int ) : int;
		function replaceSelectedText( value : String ) : void;
		function replaceText( beginIndex : int, endIndex : int, newText : String) : void;
		function setSelection(beginIndex:int, endIndex:int):void; 
		
		function get textWidth () : Number;
		function get textHeight () : Number;
		
		function get maxScrollV () : int;
		function get bottomScrollV () : int;
		function get scrollV () : int;
		function set scrollV ( s : int ) : void;
		
		function get maxScrollH () : int;		function get scrollH () : int;
		function set scrollH ( s : int ) : void;
	}
}
