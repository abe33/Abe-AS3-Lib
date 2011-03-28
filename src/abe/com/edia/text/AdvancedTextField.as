/**
 * @license
 */
package abe.com.edia.text
{
	import abe.com.edia.text.builds.BasicBuild;
	import abe.com.edia.text.builds.CharBuild;
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.core.CharEvent;
	import abe.com.edia.text.core.NewLineChar;
	import abe.com.edia.text.core.ParagraphChar;
	import abe.com.edia.text.core.WordWrapNewLineChar;
	import abe.com.edia.text.layouts.BasicLayout;
	import abe.com.edia.text.layouts.CharLayout;
	import abe.com.mon.core.Clearable;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.ITextField;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.Range;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	[Event(name="change", type="flash.events.Event")]	[Event(name="link", type="flash.events.TextEvent")]
	public class AdvancedTextField extends Sprite implements IDisplayObject,
															 IDisplayObjectContainer,
															 IInteractiveObject,
															 Suspendable, 
															 ITextField,
															 Clearable
	{
		protected var _text : String;			
		protected var _build : CharBuild;
		protected var _layout : CharLayout;
		
		protected var _size : Dimension;
		protected var _allowMask : Boolean;
		
		protected var _type : String;
		protected var _selectable : Boolean;
		
		protected var _align : String;		
		
		protected var _selectionBeginIndex : int;
		protected var _selectionEndIndex : int;
		protected var _caretIndex : int;
		protected var _selectionDrag : Boolean;
		protected var _selectionDragStartIndex : int;
		protected var _selectionDragEndIndex : int;
		
		protected var _selectionShape : Shape;
		protected var _alwaysShowSelection : Boolean;
		protected var _focus : Boolean;

		public function AdvancedTextField( build : CharBuild = null, layout : CharLayout = null )
		{
			super();
			_build = build ? build : new BasicBuild();
			_layout = layout ? layout : new BasicLayout();
			_layout.owner = this;
			_size = new Dimension( 100, 100 );
			_allowMask = true;
			_type = TextFieldType.DYNAMIC;
			_align = "left";
			//mouseChildren = false;
			//mouseEnabled = false;
			tabEnabled = false;
			tabChildren = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true );			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true );
			
			registerToBuildEvents( _build );
		}

/*-------------------------------------------------------------------------
 * 	GETTER/SETTER
 *-------------------------------------------------------------------------*/
		override public function get width () : Number 
		{
			if( _layout.autoSize == TextFieldAutoSize.NONE || _layout.wordWrap )
				return _size.width; 
			else
				return _layout.textSize.width + 4;
		}
		override public function set width ( n : Number ) : void 
		{ 
			_size.width = n;
			_layout.layout( _build.chars );
		}
		override public function get height () : Number 
		{ 
			if( _layout.autoSize == TextFieldAutoSize.NONE )
				return _size.height; 
			else
				return _layout.textSize.height+7;
		}
		override public function set height ( n : Number ) : void 
		{ 
			_size.height = n;
			_layout.layout( _build.chars );
		}
		public function get embedFonts () : Boolean	{ return _build.embedFonts; }
		public function set embedFonts (b : Boolean) : void
		{
			if( _build.embedFonts != b )
				_build.embedFonts = b;
		}
		public function get text () : String { return _build.chars.join(""); }
		public function set text ( s : String ) : void
		{
			htmlText = StringUtils.stripTags( s );
			
		}
		public function get htmlText () : String { return _text; }
		public function set htmlText (s : String) : void
		{
			_text = s;
			_build.buildChars( _text );
			if( _allowMask )
				scrollRect = new Rectangle(0,0,width,height);
		}
		
		public function get chars () : Vector.<Char> { return _build.chars; }		
		public function get effects () : Object { return _build.effects; }
		
		public function get build () : CharBuild { return _build; }
		public function set build ( b : CharBuild ) : void
		{
			if( _build )
				_build.clear();
				
			_build = b;
			_build.buildChars(_text );
		}
		
		public function get layout () : CharLayout { return _layout; }
		public function set layout ( l : CharLayout ) : void
		{
			_layout = l;
			_layout.owner = this;
			_layout.layout( _build.chars );
			
			if( _layout.autoSize != TextFieldAutoSize.NONE )
				_size = _layout.textSize;
		}

		public function get length () : int { return chars.length; }
		public function get numLines () : int { return _layout.numLines; }

		public function get autoSize () : String { return _layout.autoSize; }
		public function set autoSize (s : String) : void
		{
			_layout.autoSize = s;
		}
		public function get multiline () : Boolean { return _layout.multiline; }
		public function set multiline (b : Boolean) : void
		{
			_layout.multiline = b;
		}
		public function get wordWrap () : Boolean { return _layout.wordWrap; }
		public function set wordWrap (b : Boolean) : void
		{
			_layout.wordWrap = b;
		}
		public function get defaultTextFormat () : TextFormat { return _build.defaultTextFormat; }
		public function set defaultTextFormat (tf : TextFormat) : void
		{
			_build.defaultTextFormat = tf;
			_layout.layout( _build.chars );
		}

		public function get textColor () : uint { return 0;	}
		public function set textColor (c : uint) : void
		{
			_build.defaultTextFormat.color = c;
			_build.defaultTextFormat = _build.defaultTextFormat;
		}
		public function get allowMask () : Boolean { return _allowMask; }		
		public function set allowMask (allowMask : Boolean) : void
		{
			_allowMask = allowMask;
			if( _allowMask )
				scrollRect = new Rectangle(0,0,width,height);
			else
				scrollRect = null;
		}
		public function get align () : String { return _align; }		
		public function set align (align : String) : void
		{
			_align = align;
			_layout.layout( _build.chars );
		}
		public function get type () : String { return _type; }
		public function set type (s : String) : void
		{
			_type = s;
		}		

		public function get selectable () : Boolean { return _selectable; }
		public function set selectable (b : Boolean) : void
		{
			if( _selectable == b )
				return;
			
			_selectable = b;
			
			if( b )
			{
				_selectionShape = new Shape();
				_selectionShape.blendMode = BlendMode.INVERT;
				addChild(_selectionShape);
				registerToSelectableEvent();
			}
			else
			{
				removeChild(_selectionShape);
				_selectionShape = null;
				unregisterFromSelectableEvent();
			}
		}
		public function get alwaysShowSelection () : Boolean { return _alwaysShowSelection; }
		public function set alwaysShowSelection (b : Boolean) : void
		{
			_alwaysShowSelection = b;
		}
		
		public function get caretIndex () : int { return _caretIndex; }				public function get selectionBeginIndex () : int { return _selectionBeginIndex; }		
		public function get selectionEndIndex () : int { return _selectionEndIndex; }
		
		
		public function get maxChars () : int { return 0; }
		public function set maxChars (m : int) : void
		{
		}
		
		public function get displayAsPassword () : Boolean { return false; }
		public function set displayAsPassword (b : Boolean) : void
		{
		}
		
		public function get textWidth () : Number { return _layout.textSize.width; }
		public function get textHeight () : Number { return _layout.textSize.height; }
		
		public function get maxScrollV () : int { return 0; }		
		public function get bottomScrollV () : int { return 0; }
		
		public function get scrollV () : int { return 0; }
		public function set scrollV (s : int) : void
		{
		}
		
		public function get maxScrollH () : int { return 0;	}
		
		public function get scrollH () : int { return 0; }
		public function set scrollH (s : int) : void
		{
		}
/*-------------------------------------------------------------------------
 * 	ITEXTFIELD METHODS
 *-------------------------------------------------------------------------*/
	
		public function appendText (s : String) : void
		{
			htmlText = htmlText+s;
		}
		public function getCharIndex ( char : Char ) : int
		{
			return _layout.chars.indexOf(char);
		}
		public function getCharBoundaries (charIndex : int) : Rectangle
		{
			var c : Char = _layout.chars[ charIndex ];
			return new Rectangle( c.x, c.y, c.width, c.height );
		}
		
		public function getCharIndexAtPoint (x : Number, y : Number) : int
		{
			var a : Array = getObjectsUnderPoint(new Point( x, y ));
			
			a = a.filter( charFilter );
			
			if( a.length > 0 )
				return getCharIndex(a[a.length-1] as Char);
			else
				return -1;
		}
		protected function charFilter ( c : Object, ... args ) : Boolean 
		{ 
			return c is Char; 
		}
		
		public function getFirstCharInParagraph ( charIndex : int ) : int
		{
			var index : int = findParagraphStartBefore(charIndex)+1;
			return index;
		}
		public function getLineIndexAtPoint ( x : Number, y : Number ) : int
		{
			var ci : int = getCharIndexAtPoint(x, y);
			
			return getLineIndexOfChar( ci );
		}
		public function getLineIndexOfChar ( charIndex : int ) : int
		{
			return countCharBefore( charIndex, NewLineChar );
		}
		
		public function getLineLength ( lineIndex : int ) : int
		{
			var cli : int = findNthCharIndexAfter( 0, lineIndex, NewLineChar )+1;			var cli2 : int = findNthCharIndexAfter( cli, 1, NewLineChar )+1;
			
			if( cli2 == 0 )
				cli2 = _layout.chars.length;
				
			return cli2 - cli;
		}
		
		public function getLineMetrics ( lineIndex : int ) : TextLineMetrics
		{
			var r : Range = getLineRange(lineIndex);
			return _layout.getMetrics( r );
		}
		
		public function getLineOffset ( lineIndex : int ) : int
		{
			return findNthCharIndexAfter( 0, lineIndex, NewLineChar ) + 1;
		}
		
		public function getLineText ( lineIndex : int ) : String
		{
			var r : Range = getLineRange(lineIndex);
			
			return _layout.chars.slice( r.min, r.max ).join("");
		}
			
		public function getParagraphLength ( charIndex : int ) : int
		{
			return getParagraphRange( charIndex ).size();
		}
		public function getParagraphText ( charIndex : int ) : String
		{
			var r : Range = getParagraphRange( charIndex );
			return _layout.chars.slice( r.min, r.max ).join("");
		}
		
		public function getLineRange ( lineIndex : int ) : Range
		{
			var cli : int = findNthCharIndexAfter( 0, lineIndex, NewLineChar )+1;
			var cli2 : int = findNthCharIndexAfter( cli, 1, NewLineChar )+1;
			
			if( cli2 == 0 )
				cli2 = _layout.chars.length;
			
			return new Range(cli,cli2);
		}
		public function getParagraphRange ( charIndex : int ) : Range
		{
			var cli : int = findParagraphStartBefore(charIndex)+1;
			var cli2 : int = findParagraphEndAfter(charIndex);
			
			if( cli2 == 0 )
				cli2 = _layout.chars.length;
			
			return new Range(cli,cli2);
		}
		protected function findNthCharIndexAfter( charIndex : int, n : int, charType : Class ) : int
		{
			var c : Char;
			var i : int = 0;			var chars : Vector.<Char> = _layout.chars;
			var l : uint = chars.length;
			for( charIndex ; charIndex < l ; charIndex++ )
			{
				c = chars[charIndex];
				if( c is charType )
				{
					i++;
					if( i == n )
						return charIndex;
				}
			}
			return -1;
		}
		
		protected function findParagraphStartBefore( charIndex : int ) : int
		{
			var c : Char;
			var chars : Vector.<Char> = _layout.chars;
			while( charIndex-- )
			{
				c = chars[charIndex];
				if( ( c is ParagraphChar || c is NewLineChar ) && !(c is WordWrapNewLineChar) )
					return charIndex;
			}
			return -1;
		}
		protected function findParagraphEndAfter( charIndex : int ) : int
		{
			var c : Char;
			var chars : Vector.<Char> = _layout.chars;
			var l : uint = chars.length;
			for( charIndex ; charIndex < l ; charIndex++ )
			{
				c = chars[charIndex];
				if( ( c is ParagraphChar || c is NewLineChar ) && !(c is WordWrapNewLineChar) )
					return charIndex;
			}
			return l;
		}
		protected function countCharBefore ( charIndex : int, charType : Class ) : int
		{
			var c : Char;
			var i : int = 0;
			var chars : Vector.<Char> = _layout.chars;
			if( charIndex > 0 )
			{
				while( charIndex-- )
				{
					c = chars[charIndex];
					if( c is charType )
						i++;
				}
				return i;
			}
			return 0;
		}
		protected function countCharAfter ( charIndex : int, charType : Class ) : int
		{
			var c : Char;
			var i : int = 0;
			var chars : Vector.<Char> = _layout.chars;
			var l : uint = chars.length;
			for( charIndex ; charIndex < l ; charIndex++ )
			{
				c = chars[charIndex];
				if( c is charType )
					i++;
			}
			return i;
		}
/*-------------------------------------------------------------------------
 * 	CLEANING METHODS
 *-------------------------------------------------------------------------*/
 		public function clear() : void
		{
			_text = "";
			stop();
 			_build.clear();
 			_layout.clear();
 		}
/*-------------------------------------------------------------------------
 * 	SELECTION MANAGEMENT METHODS
 *-------------------------------------------------------------------------*/
		public function replaceSelectedText (value : String) : void
		{
		}
		
		public function replaceText (beginIndex : int, endIndex : int, newText : String) : void
		{
		}
		
		public function setSelection (beginIndex : int, endIndex : int) : void
		{
			_selectionBeginIndex = MathUtils.restrict( beginIndex, 0, _layout.chars.length-1 );			_selectionEndIndex = MathUtils.restrict( endIndex, 0, _layout.chars.length-1 );
			updateSelection();
		}

		protected function updateSelection () : void
		{
			if( _selectionDragEndIndex >= 0 && 
				_selectionDragEndIndex >= 0  )
				if( _selectionDragEndIndex > _selectionDragStartIndex )
				{
					_selectionBeginIndex = _selectionDragStartIndex;
					_selectionEndIndex = _selectionDragEndIndex;
					drawSelection();
				}
				else
				{
					_selectionEndIndex = _selectionDragStartIndex;
					_selectionBeginIndex = _selectionDragEndIndex;
					drawSelection();
				}
		}
		protected function drawSelection () : void
		{
			setChildIndex(_selectionShape, numChildren-1 );
			_selectionShape.graphics.clear();
			
			if( _focus )
				_selectionShape.blendMode = BlendMode.INVERT;
			else				_selectionShape.blendMode = BlendMode.DARKEN;
			
			
			for( var i : int = selectionBeginIndex; i<selectionEndIndex; i++ )
			{
				var r : Rectangle = getCharBoundaries(i);
				
				if( _focus )
					_selectionShape.graphics.beginFill(0);
				else					_selectionShape.graphics.beginFill(0x888888);
									_selectionShape.graphics.drawRect(r.x, r.y, r.width, r.height);
				_selectionShape.graphics.endFill();
			}
		}
/*-------------------------------------------------------------------------
 * 	DISPLAY OBJECTS OVERRIDE
 *-------------------------------------------------------------------------*/
		override public function getBounds (targetCoordinateSpace : DisplayObject) : Rectangle 
		{
			//var pt : Point = new Point( x, y );
			//pt = targetCoordinateSpace.localToGlobal( pt );
			var r : Rectangle = new Rectangle( x, y, width, height );
			return r;
		}
		
/*-------------------------------------------------------------------------
 * 	ANIMATIONS
 *-------------------------------------------------------------------------*/
		public function start () : void
		{
			for each( var o : Object in _build.effects )
				if( o.hasOwnProperty( "start" ) )
					o.start();
		}
		
		public function stop () : void
		{
			for each( var o : Object in _build.effects )
				if( o.hasOwnProperty( "stop" ) )
					o.stop();
		}
		
		public function isRunning () : Boolean
		{
			var b : Boolean = false;
			for each( var o : Object in _build.effects )
				if( o.hasOwnProperty( "isRunning" ) )
					b ||= o.isRunning();
			
			return b;
		}
		
/*-------------------------------------------------------------------------
 * 	EVENTS HANDLERS
 *-------------------------------------------------------------------------*/

		protected function charsCreated ( e : CharEvent ) : void
		{
			for each ( var l : Char in e.chars )
			{
				if( l is DisplayObject )
					addChild( l as DisplayObject );
			}
		}
		protected function charsRemoved ( e : CharEvent ) : void
		{
			for each ( var l : Char in e.chars )
			{
				if( l is DisplayObject )
					removeChild( l as DisplayObject );
			}
		}
		protected function buildComplete ( e : CharEvent ) : void
		{
			_layout.layout( _build.chars );
		}

		protected function init ( e : Event ) : void
		{
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		protected function mouseMove (event : MouseEvent) : void 
		{
			if( _selectable && _selectionDrag )
			{
				_caretIndex = _selectionDragEndIndex = getCharIndexAtPoint( event.stageX, event.stageY );
				
				updateSelection ();
			}
		}
		protected function mouseUp (event : MouseEvent) : void 
		{
			if( _selectable )
			{
				_caretIndex = _selectionDragEndIndex = getCharIndexAtPoint( event.stageX, event.stageY );
				_selectionDrag = false;
				updateSelection ();
			}
		}
		protected function mouseDown (event : MouseEvent) : void 
		{
			if( _selectable )
			{
				_caretIndex = _selectionDragEndIndex = _selectionDragStartIndex = getCharIndexAtPoint( event.stageX, event.stageY );				_selectionDrag = true;
			}
		}
		
		protected function addedToStage (event : Event) : void 
		{
			addEventListener(KeyboardEvent.KEY_DOWN, keyDown );
			addEventListener( FocusEvent.FOCUS_OUT, focusOut );
			addEventListener( FocusEvent.FOCUS_IN, focusIn );
		}
		protected function removedFromStage (event : Event) : void 
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, keyDown );
			removeEventListener( FocusEvent.FOCUS_OUT, focusOut );
			removeEventListener( FocusEvent.FOCUS_IN, focusIn );
		}
		
		protected function focusOut (event : FocusEvent) : void 
		{
			_focus = false;
			if( _selectable )
			{
				if( !_alwaysShowSelection )
					_selectionShape.graphics.clear();
				else
					drawSelection();
			}
		}
		protected function focusIn (event : FocusEvent) : void 
		{
			_focus = true;
		}

		protected function keyDown (event : KeyboardEvent) : void 
		{
			//Log.debug( String.fromCharCode(event.charCode) );
		}
		
/*-------------------------------------------------------------------------
 * 	EVENTS MANAGEMENT
 *-------------------------------------------------------------------------*/

		protected function registerToBuildEvents ( b : CharBuild ) : void
		{
			b.addEventListener( CharEvent.CHARS_CREATED, charsCreated );
			b.addEventListener( CharEvent.CHARS_REMOVED, charsRemoved );			b.addEventListener( CharEvent.BUILD_COMPLETE, buildComplete );			b.addEventListener( Event.INIT, init );		}
		protected function unregisterToBuildEvents ( b : CharBuild ) : void
		{
			b.removeEventListener( CharEvent.CHARS_CREATED, charsCreated );
			b.removeEventListener( CharEvent.CHARS_REMOVED, charsRemoved );			b.removeEventListener( CharEvent.BUILD_COMPLETE, buildComplete );			b.removeEventListener( Event.INIT, init );
		}
		protected function registerToSelectableEvent () : void
		{
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );			addEventListener( MouseEvent.MOUSE_UP, mouseUp );			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );					}
		protected function unregisterFromSelectableEvent () : void
		{
			removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
			removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
	}
}
