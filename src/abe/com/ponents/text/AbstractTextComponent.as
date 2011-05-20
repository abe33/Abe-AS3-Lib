/**
 * @license
 */
package abe.com.ponents.text
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.ITextField;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.Range;
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.core.AbstractComponent;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.dnd.DragSource;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.layouts.display.DOStretchLayout;
	import abe.com.ponents.layouts.display.DisplayObjectLayout;

	import com.adobe.linguistics.spelling.SpellChecker;

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextLineMetrics;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	[Style(name="embedFonts",type="Boolean",enumeration="true,false")]
	[Style(name="mispellWordsColor",type="abe.com.mon.colors.Color")]

	[Skinable(skin="Text")]
	public class AbstractTextComponent extends AbstractComponent implements Component,
																			IDisplayObject,
																			IInteractiveObject,
																			IDisplayObjectContainer,
																			Focusable,
																			LayeredSprite,
																			IEventDispatcher,
																			DragSource,
																			FormComponent
	{
		public var textContentChanged : Signal;
		protected var _dataChanged : Signal;
		
		protected var _value : *;
		protected var _label : ITextField;
		protected var _childrenLayout : DisplayObjectLayout;
		protected var _allowInput : Boolean;
		protected var _selectable : Boolean;
		protected var _safeTextType : String;
		protected var _disabledMode : uint;
		protected var _disabledValue : *;
		protected var _allowHTML : Boolean;

		public function AbstractTextComponent ()
		{
			super( );
			textContentChanged = new Signal();
			_dataChanged = new Signal();
			_label = _label ? _label : new TextFieldImpl();
			//_label = _label ? _label : new TLFTextFieldImpl();
			_label.width = 100;
			_label.height = 20;
			_label.type = TextFieldType.INPUT;
			_label.embedFonts = _style.embedFonts;
			_label.text = _value = "";

			_childrenContainer.addChild( _label as DisplayObject );
			_childrenContainer.mouseEnabled = true;
			_childrenContainer.mouseChildren = true;
			//_childrenLayout = _childrenLayout ? _childrenLayout : new TextLayout( _childrenContainer, _label );
			_childrenLayout = _childrenLayout ? _childrenLayout : new DOStretchLayout( _childrenContainer, _label );
			_allowPressed = false;
			_allowOver = false;
			_allowInput = true;
			_selectable = true;
			_allowHTML = true;

			_disabledMode = 0;

			FEATURES::MENU_CONTEXT { 
			    _contextMenu = new ContextMenu( );
			    _contextMenu.addEventListener( ContextMenuEvent.MENU_SELECT, checkForContextMenu );
			} 

			FEATURES::SPELLING { 
				FEATURES::MENU_CONTEXT { 
			        (_label as InteractiveObject).contextMenu = _contextMenu;
				} 
			    _mispelledWordsShape = new Shape( );
			    addChildAt( _mispelledWordsShape, 1 );
			} 

			invalidatePreferredSizeCache( );
		}
		public function get dataChanged() : Signal { return _dataChanged; }
		public function get caretIndex () : int	 { return _label.caretIndex; }
		public function get selectionBeginIndex () : int { return _label.selectionBeginIndex; }
		public function get selectionEndIndex () : int { return _label.selectionEndIndex; }
		
		public function get childrenLayout () : DisplayObjectLayout	{ return _childrenLayout; }
		public function set childrenLayout (childrenLayout : DisplayObjectLayout) : void { _childrenLayout = childrenLayout; }
		
		public function get textfield () : ITextField { return _label; }
		
		public function get multiline () : Boolean	{ 	return _label.multiline;}
		public function set multiline ( b : Boolean ) : void
		{
			_label.multiline = b;
			updateTextFormat();
			invalidatePreferredSizeCache();
		}
		public function get wordWrap () : Boolean { return _label.wordWrap; }
		public function set wordWrap ( b : Boolean ) : void
		{
			_label.wordWrap = b;
			updateTextFormat();
			invalidatePreferredSizeCache();
		}
		public function get autoSize () : String { return _label.autoSize; }
		public function set autoSize ( s : String ) : void
		{
			_label.autoSize = s;
			updateTextFormat();
			invalidatePreferredSizeCache();
		}
		public function get text () : String { return _label.text; }
		public function get htmlText () : String 
		{ 
			return _label.htmlText; 
		}
		public function get value () : * { return _value; }
		public function set value ( val : * ) : void
		{
			// avoid the text to scroll while clicking on a text component (will be buggy on style changes)
			if( _value == val )
				return;

			_value = val;

			updateTextFormat();
			invalidatePreferredSizeCache();
		}
		public function get allowInput () : Boolean 
		{ 
			return _allowInput; 
		}
		public function set allowInput (allowInput : Boolean) : void
		{
			_allowInput = allowInput;
			_label.type = _allowInput ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}
		public function get selectable () : Boolean	
		{ 
			return _selectable; 
		}
		public function set selectable (selectable : Boolean) : void
		{
			_selectable = selectable;
			_label.selectable = _enabled && _selectable && _interactive;
		}
		override public function set enabled (b : Boolean) : void
		{
			_label.tabEnabled = b;
			_label.selectable = b && _selectable && _interactive;
			super.enabled = b;

			if( !_enabled )
			{
				checkDisableMode( );
			}
			affectTextValue( );
		}
		public function get disabledMode () : uint 
		{ 
			return _disabledMode; 
		}
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			checkDisableMode( );
		}
		public function get disabledValue () : * 
		{ 
			return _disabledValue; 
		}
		public function set disabledValue (v : *) : void
		{
			_disabledValue = v;
		}
		public function get allowHTML () : Boolean
		{ 
			return _allowHTML; 
		}
		public function set allowHTML (allowHTML : Boolean) : void
		{
			_allowHTML = allowHTML;
		}
		public function reset () : void
		{
			value = "";
		}
		protected function checkDisableMode () : void
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY :
					disabledValue = _( "different values across many" );
					break;
				case FormComponentDisabledModes.UNDEFINED :
					disabledValue = _( "not defined" );
					break;
				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED :
				default :
					disabledValue = value;
					break;
			}
		}
		override public function set interactive (interactive : Boolean) : void
		{
			super.interactive = interactive;
			if( !_interactive )
			{
				_safeTextType = _label.type;
				_label.type = TextFieldType.DYNAMIC;
				_label.selectable = false;
			}
			else
			{
				if( _safeTextType )
					_label.type = _safeTextType;

				_label.selectable = _enabled && _selectable && _interactive;
			}
		}
		override public function get maxContentScrollV () : Number
		{
			return _childrenLayout.preferredSize.height - ( _childrenContainer.scrollRect.height - _style.insets.vertical );
		}
		override public function get maxContentScrollH () : Number
		{
			return _childrenLayout.preferredSize.width - ( _childrenContainer.scrollRect.width - _style.insets.vertical );
		}
		override public function isValidateRoot () : Boolean
		{
			return true;
		}
		/*-----------------------------------------------------------------
		 * 	TEXTFIELD COMPOSITION & TEXT MANIPULATION
		 *----------------------------------------------------------------*/
		public function selectAll () : void
		{
			setSelection( 0, _label.length );
		}
		public function caretAtEnd () : void
		{
			setSelection( _label.length, _label.length );
		}
		public function caretAtStart () : void
		{
			setSelection( 0, 0 );
		}
		public function getWordAt ( index : int ) : String
		{
			var s : String = _label.text;
			if( s.substr( index, 1 ).match( /^\s$/ ) )
				return null;
			else
			{
				var previousNonWordCharIndex : int = getPreviousNonWordCharIndex( s, index );
				var nextNonWordCharIndex : int = getNextNonWordCharIndex( s, index );

				if( previousNonWordCharIndex != -1 && nextNonWordCharIndex != -1 )
					return s.substr( previousNonWordCharIndex, nextNonWordCharIndex - previousNonWordCharIndex );
			}
			return null;
		}
		public function getWordRangeAt ( index : int ) : Range
		{
			var s : String = _label.text;
			if( s.substr( index, 1 ).match( /^\s$/ ) )
				return null;
			else
			{
				var previousNonWordCharIndex : int = getPreviousNonWordCharIndex( s, index );
				var nextNonWordCharIndex : int = getNextNonWordCharIndex( s, index );

				if( previousNonWordCharIndex != -1 && nextNonWordCharIndex != -1 )
					return new Range( previousNonWordCharIndex, nextNonWordCharIndex );
			}
			return null;
		}
		public function getPreviousNonWordCharIndex ( s : String, index : int ) : int
		{
			while ( index-- )
			{
				if( index == 0 )
					return index;
				else if ( s.substr( index, 1 ).match( /[^\w]/ ) )
					return index + 1;
			}
			return -1;
		}
		public function getNextNonWordCharIndex ( s : String, index : int ) : int
		{
			while ( index++ )
			{
				if( index >= s.length || s.substr( index, 1 ).match( /[^\w]/ )  )
					return index - 1;
			}
			return -1;
		}
		public function getCharBoundaries ( charIndex : int ) : Rectangle 
		{ 
			return _label.getCharBoundaries( charIndex ); 
		}
		public function getCharIndexAtPoint ( x : Number, y : Number ) : int 
		{ 
			return _label.getCharIndexAtPoint( x, y ); 
		}
		public function getFirstCharInParagraph ( charIndex : int ) : int 
		{ 
			return _label.getFirstCharInParagraph( charIndex ); 
		}
		public function getLineIndexAtPoint (x : Number, y : Number) : int 
		{ 
			return _label.getLineIndexAtPoint( x, y ); 
		}
		public function getLineIndexOfChar ( charIndex : int ) : int 
		{ 
			return _label.getLineIndexOfChar( charIndex ); 
		}
		public function getLineLength ( lineIndex : int ) : int 
		{ 
			return _label.getLineLength( lineIndex ); 
		}
		public function getLineMetrics ( lineIndex : int ) : TextLineMetrics 
		{ 
			return _label.getLineMetrics( lineIndex ); 
		}
		public function getLineOffset ( lineIndex : int ) : int 
		{ 
			return _label.getLineOffset( lineIndex ); 
		}
		public function getLineText ( lineIndex : int ) : String 
		{ 
			return _label.getLineText( lineIndex ); 
		}
		public function getParagraphLength ( charIndex : int ) : int 
		{ 
			return _label.getParagraphLength( charIndex ); 
		}
		public function replaceSelectedText ( value : String ) : void 
		{ 
			_label.replaceSelectedText( value ); 
		}
		public function replaceText ( beginIndex : int, endIndex : int, newText : String) : void 
		{ 
			_label.replaceText( beginIndex, endIndex, newText ); 
		}
		public function setSelection (beginIndex : int, endIndex : int) : void 
		{ 
			_label.setSelection( beginIndex, endIndex ); 
		}
		public function get textWidth () : Number 
		{ 
			return _label.textWidth; 
		}
		public function get textHeight () : Number 
		{ 
			return _label.textHeight; 
		}
		/*-----------------------------------------------------------------
		 * 	VALIDATION & REPAINT
		 *----------------------------------------------------------------*/
		override public function invalidatePreferredSizeCache () : void
		{
			if( _label.autoSize != TextFieldAutoSize.NONE )
				_preferredSizeCache = new Dimension( _label.textWidth + 4, _label.textHeight + 4 ).grow( _style.insets.horizontal, _style.insets.vertical );
			else
				_preferredSizeCache = _childrenLayout.preferredSize.grow( _style.insets.horizontal, _style.insets.vertical );
			
			super.invalidatePreferredSizeCache();
		}
		override public function repaint () : void
		{
			_background.graphics.clear( );
			_foreground.graphics.clear( );
			var ls : Number = _label.scrollV;
			var lh : Number = _label.scrollH;

			updateTextFormat( );

			var size : Dimension = calculateComponentSize( );

			_childrenLayout.layout( size, _style.insets );
			super.repaint( );

			_label.scrollV = ls;
			_label.scrollH = lh;
		}
		protected function updateTextFormat () : void
		{
			var lastScrollV : Number = _label.scrollV;
			var lastScrollH : Number = _label.scrollH;
			_label.defaultTextFormat = _style.format;
			_label.textColor = _style.textColor.hexa;
			affectTextValue();
			
			_label.scrollH = lastScrollH;
			_label.scrollV = lastScrollV;
			textContentChanged.dispatch( this, _value );
		}
		protected function affectTextValue () : void
		{
			if( _allowHTML )
			{
				if( _enabled )
					_label.htmlText = String( _value );
				else
					_label.htmlText = String( _disabledValue );
			}
			else
			{
				if( _enabled )
					_label.text = String( _value );
				else
					_label.text = String( _disabledValue );
			}
		}
		protected function calculateScrollOffset () : Number
		{
			var startLine : int = _label.scrollV - 1;
			var offset : Number = 0;

			for(var i : int = 0; i < startLine; i++)
			{
				var m : TextLineMetrics = getLineMetrics( i );
				offset += m.height;
			}

			return offset;
		}
		/*-----------------------------------------------------------------
		 * 	EVENTS HANDLERS
		 *----------------------------------------------------------------*/
		override protected function registerToOnStageEvents () : void
		{
			super.registerToOnStageEvents( );

			_label.addEventListener( FocusEvent.FOCUS_OUT, registerValue );
			_label.addEventListener( Event.CHANGE, registerValue );
			_label.addEventListener( TextEvent.TEXT_INPUT, textInput );
		}
		override protected function unregisterFromOnStageEvents () : void
		{
			super.unregisterFromOnStageEvents( );

			_label.removeEventListener( FocusEvent.FOCUS_OUT, registerValue );
			_label.removeEventListener( Event.CHANGE, registerValue );
			_label.removeEventListener( TextEvent.TEXT_INPUT, textInput );
		}
		protected function textInput (event : TextEvent) : void 
		{
			//FIXME:Scrolling issue when typing
			//var c : int = _label.caretIndex;
			//var l : int = _label.getLineIndexOfChar( c );
		}
		override protected function stylePropertyChanged (  propertyName : String, propertyValue : *  ) : void
		{
			switch( propertyName )
			{
				case "embedFonts" :
					_label.embedFonts = _style.embedFonts;
					updateTextFormat( );
					invalidatePreferredSizeCache( );
					break;
				case "format" :
					updateTextFormat( );
					invalidatePreferredSizeCache( );
					break;
				default :
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}
		public function registerValue ( e : Event = null ) : void
		{
			if( _label && _label.type == "input" )
			{
				_value = _label.htmlText;

				FEATURES::SPELLING { 
				checkContent( );
				} 
			}
		}
		override public function focusIn (e : FocusEvent) : void
		{
			if( e.target != _label )
			{
				e.stopPropagation( );
				StageUtils.stage.focus = _label as InteractiveObject;
			}
			_focusIn( e );
		}
		override public function focusOut (e : FocusEvent) : void 
		{
			registerValue( );
			super.focusOut( e );
		}

		/*-----------------------------------------------------------------
		 * 	CONTEXT MENUS
		 *----------------------------------------------------------------*/
		FEATURES::MENU_CONTEXT { 
		protected var _contextMenu : ContextMenu;

		protected function checkForContextMenu ( event : ContextMenuEvent ) : void
		{
			var a : Array = [];

			FEATURES::SPELLING { 
			checkForSpellingContext( event, a );
			} 

			var b : Array = [];
			
			
			TARGET::FLASH_9 { var v : Array = menuContext; }
			TARGET::FLASH_10 { var v : Vector.<ContextMenuItem> = menuContext; }
			TARGET::FLASH_10_1 { 
			var v : Vector.<ContextMenuItem> = menuContext; } 
			
			var l : uint = v.length;
			var c : Array = StageUtils.root.contextMenu["customItems"];

			for(var i : int = 0; i < l; i++ )
				if( c.indexOf( v[i] ) == -1 )
					b.push( v[i] );

			b = b.concat( c );

			if( b.length > 0 )
				(b[0] as ContextMenuItem).separatorBefore = true;
			if( c.length > 0 )
				(c[0] as ContextMenuItem).separatorBefore = true;

			_contextMenu.customItems = a.concat( b );
		}
		} 

		/*-----------------------------------------------------------------
		 * 	SPELL CHECK
		 *----------------------------------------------------------------*/
		FEATURES::SPELLING { 
		protected var _spellChecker : SpellChecker;
		protected var _spellCheckerRules : String;
		protected var _spellCheckerDict : String;
		protected var _spellCheckEnabled : Boolean;
		
		
		TARGET::FLASH_9
		protected var _lastMispelledWords : Array;
		TARGET::FLASH_10
		protected var _lastMispelledWords : Vector.<Range>;
		TARGET::FLASH_10_1 
		protected var _lastMispelledWords : Vector.<Range>;
		protected var _mispelledWordsShape : Shape;
		protected var _lastMispelledWordSuggestions : Array;

		public function get spellCheckEnabled () : Boolean 
		{ 
			return _spellCheckEnabled; 
		}
		public function set spellCheckEnabled (spellCheckEnabled : Boolean) : void
		{
			_spellCheckEnabled = spellCheckEnabled;
		}
		
		public function setSpellCheckerDictionnary ( spellCheckerRules : String, spellCheckerDict : String ) : void
		{
			_spellCheckerRules = spellCheckerRules;
			_spellCheckerDict = spellCheckerDict;
			SpellCheckManagerInstance.loadDictionary( _spellCheckerRules, _spellCheckerDict, spellCheckLoadingCallback );
		}
		
		public function get spellChecker () : SpellChecker 
		{ 
			return _spellChecker; 
		}
		protected function drawDottedLine ( x1 : Number, x2 : Number, y : Number, color : Color ) : void
		{
			var x : Number = x1;
			while( x < x2 )
			{
				_mispelledWordsShape.graphics.beginFill( color.hexa, color.alpha );
				_mispelledWordsShape.graphics.drawRect( x, y, 1, 1 );
				_mispelledWordsShape.graphics.endFill( );
				x += 2;
			}
		}
		protected function checkContent () : void
		{
			if( _spellCheckEnabled && _spellChecker )
			{
				_lastMispelledWords = SpellCheckManagerInstance.checkText( _label.text, _spellChecker );
				renderMispelledWords( );
			}
		}
		private function checkForSpellingContext (event : ContextMenuEvent, array : Array = null) : void
		{
			if( _lastMispelledWords && _lastMispelledWords.length > 0 )
			{
				var c : int = getCharIndexAtPoint( _label.mouseX, _label.mouseY );
				var l : int = _lastMispelledWords.length;
				//StageUtils.unsetMenus();
				for( var i : int = 0 ; i < l ; i++ )
				{
					var r : Range = _lastMispelledWords[i];
					if( r.surround( c ) )
					{
						getSuggestionsForWordAtIndex( c );

						//var a : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem>();
						var l2 : int = _lastMispelledWordSuggestions.length;
						for(var j : int = 0; j < l2; j++)
						{
							var s : String = _lastMispelledWordSuggestions[j];
							var item : ContextMenuItem = new ContextMenuItem( s );
							item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelected, false, 0, true );
							array.push( item );
						}
						//StageUtils.setMenus( a );
						break;
					}
				}
			}
		}
		protected function renderMispelledWords () : void
		{
			if( _lastMispelledWords )
			{
				_mispelledWordsShape.graphics.clear( );

				var l : Number = _lastMispelledWords.length;
				var startLine : int = _label.scrollV - 1;
				var endLine : int = getLineIndexAtPoint( _label.width - 4, _label.height - 4 );
				var lineRange : Range = new Range( startLine, endLine );
				var lineOffset : Number = calculateScrollOffset( );
				var color : Color = _style.mispellWordsColor as Color;
				if( l > 0 )
				{
					var r : Range;
					for(var i : int = 0; i < l; i++)
					{
						r = _lastMispelledWords[i];
						var li : int = getLineIndexOfChar( r.min );
						if( endLine == -1 || lineRange.surround( li ) )
						{
							var bb1 : Rectangle = getCharBoundaries( r.min );
							var bb2 : Rectangle = getCharBoundaries( r.max - 1 );
							if( bb1 && bb2 && bb1.bottom - lineOffset < height )
							{
								drawDottedLine( bb1.left, bb2.right, bb1.bottom - lineOffset, color );
							}
						}
					}
				}
			}
		}
		protected function getSuggestionsForWordAtIndex ( index : int ) : void
		{
			if( _spellCheckEnabled && _spellChecker )
			{
				var l : int = _lastMispelledWords.length;
				if( l > 0 )
				{
					var r : Range;
					for( var i : int = 0; i < l; i++ )
					{
						r = _lastMispelledWords[ i ];
						if( r.surround( index ) )
						{
							var word : String = _label.text.substr( r.min, r.size( ) );
							_lastMispelledWordSuggestions = _spellChecker.getSuggestions( word );
							break;
						}
					}
				}
			}
		}
		protected function spellCheckLoadingCallback ( sp : SpellChecker ) : void
		{
			_spellChecker = sp;
			checkContent( );
		}
		protected function menuItemSelected ( e : ContextMenuEvent ) : void
		{
			var ls : Number = _label.scrollV;
			var c : int = getCharIndexAtPoint( _label.mouseX, _label.mouseY );
			var l : int = _lastMispelledWords.length;
			var r : Range;
			var s : String;
			for( var i : int = 0 ; i < l ; i++ )
			{
				r = _lastMispelledWords[i];
				if( r.surround( c ) )
				{
					s = (e.target as ContextMenuItem).caption;
					break;
				}
			}
			_label.replaceText( r.min, r.max, s );
			registerValue( );
			invalidate( );
			FEATURES::MENU_CONTEXT { 
			_contextMenu.customItems = [];
			} 
			_label.scrollV = ls;
		}
		} 
	}
}
