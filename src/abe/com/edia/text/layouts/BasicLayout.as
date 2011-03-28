/**
 * @license
 */
package abe.com.edia.text.layouts 
{
	import abe.com.edia.text.AdvancedTextField;
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.core.NewLineChar;
	import abe.com.edia.text.core.NullChar;
	import abe.com.edia.text.core.ParagraphChar;
	import abe.com.edia.text.core.ParagraphEndChar;
	import abe.com.edia.text.core.SpriteChar;
	import abe.com.edia.text.core.TabChar;
	import abe.com.edia.text.core.TextFieldChar;
	import abe.com.edia.text.core.WordWrapNewLineChar;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.Range;

	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;

	/**
	 * @author Cédric Néhémie
	 */
	public class BasicLayout implements CharLayout
	{
		protected var _lineSpacing : Number;
		protected var _tracking : Number;
		protected var _tabSize : Number;
		protected var _tabs : Array;
		protected var _alignMap : Object;
		protected var _paragraphMargin : Number;
		
		protected var _wordwrap : Boolean;		protected var _multiline : Boolean;
		protected var _autoSize : String;
		protected var _textSize : Dimension;
		protected var _owner : AdvancedTextField;
		
		protected var _numLines : uint;
		
		protected var _chars : Vector.<Char>;		
		private var x : Number;
		private var y : Number;
		private var linewidth : Number;		private var lineHeight : Number;
		
		private var toAlign : Array;
		
		public function BasicLayout( lineSpacing : Number = 4, 
									 paragraphMargin : Number = 4, 
									 tracking : Number = 0,
									 ... tabs )
		{
			_lineSpacing = lineSpacing;
			_paragraphMargin = paragraphMargin;
			_tracking = tracking;
			_alignMap = {};			_alignMap.right = alignRight;
			_alignMap.center = alignCenter;
			_wordwrap = false;
			_multiline = true;
			_autoSize = TextFieldAutoSize.NONE;
			
			if( tabs.length == 0 )
			{
				_tabSize = 4;
			}
			else if( tabs.length == 1 )
			{
				_tabSize = tabs[0];
			}
			else
			{
				_tabs = tabs;
			}
			_numLines = 0;
		}
		public function get chars () : Vector.<Char> { return _chars; }
		
		public function get owner (): AdvancedTextField { return _owner; }
		public function set owner ( o : AdvancedTextField ) : void
		{
			_owner = o;
		}
		public function get numLines () : uint { return _numLines; }
		
		public function get autoSize () : String { return _autoSize; }		
		public function set autoSize (s : String) : void
		{
			_autoSize = s;
			if( _owner && _owner.build.chars.length )
				layout( _owner.build.chars );
		}

		public function get wordWrap () : Boolean { return _wordwrap; }
		public function set wordWrap (b : Boolean) : void
		{
			_wordwrap = b;
			if( _owner && _owner.build.chars.length )
				layout( _owner.build.chars );
		}

		public function get multiline () : Boolean { return _multiline; }
		public function set multiline (b : Boolean) : void
		{
			_multiline = b;
			if( _owner && _owner.build.chars.length )
				layout( _owner.build.chars );
		}
		
		public function get textSize () : Dimension
		{
			return _textSize;
		}
		
		public function clear () : void
		{
			_chars = null;
			toAlign = null;
		}

		public function layout( chars : Vector.<Char> ):void
		{
			_textSize = new Dimension();
			
			var l : Number = chars.length;
			x = 0;
			y = 0;
			linewidth = 0;
			lineHeight = 0;
			_numLines = 1;
			toAlign = [];
			var wasParagraphEnd : Boolean;
			var currentAlign : String = _owner.align;
			var currentAlignLine : Vector.<Char> = new Vector.<Char>();
			var tc : Number = 0;
			var i : Number;
			_chars = chars.concat();
			
			// pour chaque caractère de la chaîne
			for( i = 0; i < l; i++ )
			{	
				wasParagraphEnd = false;
				
				var char : Char = _chars[ i ];
				
				// selon la nature du caractère
				switch ( true )
				{
					case char is ParagraphChar :
						if( !_multiline )
							break;
							
						var c : ParagraphChar = char as ParagraphChar;
						if( i==0 )
						{
							currentAlign = c.align;
							break;
						}
					
						if( lineHeight == 0)
							lineHeight = 16;
						
						linewidth = x;
						_textSize.width = Math.max( _textSize.width, linewidth );
						x = 0;
						tc = 0;
						y += lineHeight + _lineSpacing + _paragraphMargin;
						
						if( currentAlignLine != null && currentAlign != "left" )
							toAlign.push( {line:currentAlignLine, align:currentAlign,width:linewidth} );
						
						alignVertical( currentAlignLine );
						
						/*
						if( currentAlignLine != null && _alignMap.hasOwnProperty( currentAlign ) )
							_alignMap[ currentAlign ].call( null, currentAlignLine );
						*/
						
						currentAlign = c.align;						
						currentAlignLine = new Vector.<Char>();	
						
						lineHeight = 0;
						_numLines++;
						break;
						
					case char is ParagraphEndChar :
						wasParagraphEnd = true;
						if( !_multiline )
							break;
							
						if( i + 1 < l)
						{ 
							if ( chars[ i + 1 ] is NewLineChar ) 
							{
								y += _paragraphMargin;
								break;
							}
						  	else if ( _chars[ i + 1 ] is ParagraphChar )
						  		break;
					
								}						  	
						y += _paragraphMargin;
					
					case char is NewLineChar : 
						if( !_multiline )
							break;
							
						if( lineHeight == 0 )
							lineHeight = 16;
						
						linewidth = x;
						_textSize.width = Math.max( _textSize.width, linewidth );
						x = 0;
						tc = 0;
						y += lineHeight + _lineSpacing;
						
						/*
						if( currentAlignLine != null && _alignMap.hasOwnProperty( currentAlign ) )
							_alignMap[ currentAlign ].call( null, currentAlignLine );
						*/
						
						if( currentAlignLine != null && currentAlign != "left" )
							toAlign.push( {line:currentAlignLine, align:currentAlign,width:linewidth} );
						
						alignVertical( currentAlignLine );
						
						currentAlignLine = new Vector.<Char>();	
						
						if( wasParagraphEnd )
							currentAlign = "left";
						lineHeight = 0;
						_numLines++;	
						break;
					
					case char is TabChar :
						if( _tabs )
							x = _tabs[ tc++ % _tabs.length ];
						else
							x = Math.ceil( x / _tabSize ) * _tabSize;
						break;
					
					case char is NullChar : 
						break;
					
					default : 
						if( _wordwrap && 
							x + char.charWidth > _owner.width - 4 )
						{
							i = lookupWordStart( i, _chars, currentAlignLine );
							_chars.splice(i+1, 0, new WordWrapNewLineChar());
							l++;
						}
						else
						{
							currentAlignLine.push( char );
							placeChar( char );
							lineHeight = Math.max( lineHeight, char.charHeight );
						}
						break;
				}
			}
			linewidth = x;
			_textSize.width = Math.max( _textSize.width, linewidth );
			
			if( currentAlignLine != null && currentAlign != "left" )
				toAlign.push( {line:currentAlignLine, align:currentAlign,width:linewidth} );
						
			alignVertical( currentAlignLine );	
			
			for( i = 0; i < toAlign.length; i++ )
				_alignMap[ toAlign[ i ].align ].call( null, toAlign[ i ].line, toAlign[ i ].width );
			
			_textSize.height = y + lineHeight;
		}

		protected function lookupWordStart ( i : Number, chars:Vector.<Char>, currentAlignLine : Vector.<Char> ) : Number
		{
			for(i=i-1;i>=0;i--)
			{
				if( chars[ i ] is NullChar || chars[i].text == " " )
				{
					return i;
				}
				else
				{					x -= chars[i].charWidth + _tracking;					currentAlignLine.pop();
				}
			}
			return 0;
		}
		
		protected function alignVertical ( line : Vector.<Char> ) : void
		{
			for each( var c : Char in line )
				c.y += lineHeight - c.charHeight;
		}
		
		protected function alignRight ( line : Vector.<Char>, w : Number ) : void
		{
			var dif : Number = _owner.width - w - 4;
			for each( var c : Char in line )
				c.x += dif;
		}
		protected function alignCenter ( line : Vector.<Char>, w : Number ) : void
		{ 
			var dif : Number = (_owner.width - w) / 2;
			for each ( var c : Char in line )
				c.x += dif;
		}
		protected function placeChar ( char : Char ) : void
		{
			if( char is SpriteChar )
			{
				char.x = x + 2;
				char.y = y + 4;
			}
			else
			{
				char.x = x;
				char.y = y;
			}
			
			x += char.charWidth + _tracking;
		}
		
		public function getMetrics (r : Range) : TextLineMetrics
		{
			
			var lineChars : Vector.<Char> = _chars.slice(r.min, r.max);
			var x : Number = lineChars[0].x;
			var w : Number = 0;
			var h : Number = 0;
			var ascent : Number = 0;
			var descent : Number = 0;
			var c : Char;
			var tfc : TextFieldChar;
			var m : TextLineMetrics;
			var l : int = lineChars.length;
			for(var i : int = 0; i<l; i++)
			{
				c = lineChars[i];
				if( c is TextFieldChar )
				{
					tfc = c as TextFieldChar;
					m = tfc.getLineMetrics(0);
					w = tfc.x + tfc.textWidth;
					
					h = Math.max( h, m.height );
					ascent = Math.max( ascent, m.ascent );
					descent = Math.max( descent, m.descent );
				}
			}
			
			var metrix : TextLineMetrics = new TextLineMetrics(x, w, h + _lineSpacing, ascent, descent, _lineSpacing );
			
			return metrix;
		}
	}
}
