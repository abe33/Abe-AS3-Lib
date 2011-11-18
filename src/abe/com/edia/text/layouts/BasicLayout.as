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
		protected var _linesRanges : Array;		protected var _lines : Array;
		
		protected var _chars : Vector.<Char>;		
		private var __x__ : Number;
		private var __y__ : Number;
		private var __linewidth__ : Number;		private var __lineHeight__ : Number;		private var __baseline__ : Number;
		
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
			_numLines = 0;
			
			if( tabs.length == 0 )
				_tabSize = 24;
			else if( tabs.length == 1 )
				_tabSize = tabs[0];
			else
				_tabs = tabs;
			
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
        public function get lineSpacing () : Number { return _lineSpacing; }
        public function set lineSpacing ( lineSpacing : Number ) : void {
            _lineSpacing = lineSpacing;
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
		public function getLineIndexAt (y : Number) : int
		{
			var a : Number;			var b : Number;
			var l : int = _linesRanges.length;			var i : int;
			for ( i=1; i<l; i++ )
			{
				a = _linesRanges[i-1];				b = _linesRanges[i];
				if( y > a && y < b )
					return i-1;
			}
			return -1;
		}
		public function getLineAt ( i : uint ) : Array
		{
			return _lines[i];
		}
		public function layout( chars : Vector.<Char> ):void
		{
			_textSize = new Dimension();
			_linesRanges = [0];
			_lines = [];
			
			var l : Number = chars.length;
			__x__ = 0;
			__y__ = 0;
			__linewidth__ = 0;
			__lineHeight__ = 0;
			__baseline__ = 0;
			_numLines = 0;
			toAlign = [];
			var wasParagraphEnd : Boolean;
			var currentAlign : String = _owner.align;
			var currentAlignLine : Array = [];
			var tc : Number = 0;
			var i : Number;
			_chars = chars.concat();
			// pour chaque caractère de la chaîne
			for( i = 0; i < l; i++ )
			{	
				wasParagraphEnd = false;
				
				var char : Char = _chars[ i ];
				if( !char )
					continue;
							
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
					
						if( __lineHeight__ == 0)
						
							__lineHeight__ = c.lineHeight;
						
						__linewidth__ = __x__;
						_textSize.width = Math.max( _textSize.width, __linewidth__ );
						__x__ = 0;
						tc = 0;
						__y__ += __lineHeight__ + _lineSpacing + _paragraphMargin;

						
						if( currentAlignLine != null && currentAlign != "left" )
							toAlign.push( {line:currentAlignLine, align:currentAlign,width:__linewidth__} );
						
						alignVertical( currentAlignLine );
						
						/*
						if( currentAlignLine != null && _alignMap.hasOwnProperty( currentAlign ) )
							_alignMap[ currentAlign ].call( null, currentAlignLine );
						*/
						
						currentAlign = c.align;						
						currentAlignLine = [];	
						
						__lineHeight__ = 0;
						__baseline__ = 0;
						_numLines++;
						break;
						
					case char is ParagraphEndChar :
						wasParagraphEnd = true;
						if( !_multiline )
							break;
						
						if( i + 1 < l)
						{ 
							var nc : Char = _chars[ i + 1 ];
							if ( nc is NewLineChar && ( nc as NewLineChar ).ignoredAfterParagraph ) 
								break;
						}						  	
						__y__ += _paragraphMargin;
					
					case char is NewLineChar : 
						if( !_multiline )
							break;
						
						if( __lineHeight__ == 0 )
							__lineHeight__ = ( char as NewLineChar ).lineHeight;
						
						__linewidth__ = __x__;
						_textSize.width = Math.max( _textSize.width, __linewidth__ );
						__x__ = 0;
						tc = 0;
						__y__ += __lineHeight__ + _lineSpacing;
						
						/*
						if( currentAlignLine != null && _alignMap.hasOwnProperty( currentAlign ) )
							_alignMap[ currentAlign ].call( null, currentAlignLine );
						*/
						
						if( currentAlignLine != null && currentAlign != "left" )
							toAlign.push( {line:currentAlignLine, align:currentAlign,width:__linewidth__} );
						
						alignVertical( currentAlignLine );
						
						currentAlignLine = [];	
						
						if( wasParagraphEnd )
							currentAlign = "left";
						__lineHeight__ = 0;
						__baseline__ = 0;
						_numLines++;	
						break;
					
					case char is TabChar :
						if( _tabs )
							__x__ = _tabs[ tc++ % _tabs.length ];
						else
							__x__ = _tabSize + Math.ceil( __x__ / _tabSize ) * _tabSize;
						break;
					
					case char is NullChar : 
						break;
					
					default : 
						if( _wordwrap && 
							__x__ + char.charWidth > _owner.size.width - 4 )
						{
                            var si : int = i;
							i = lookupWordStart( i, _chars, currentAlignLine );
                            if( i != 0 )
                            {
								_chars.splice(i+1, 0, new WordWrapNewLineChar());
                            }
                            else
                            {
                            	i = si-1;
                                
                                var char2 : TextFieldChar = new TextFieldChar();
                                char2.text = "-";
                                char2.format = char.format;
                                _chars.splice(i, 0, char2, new WordWrapNewLineChar());
                            }
							l++;
						}
						else
						{
							currentAlignLine.push( char );
							placeChar( char );
							__lineHeight__ = Math.max( __lineHeight__, char.charHeight );
							__baseline__ = Math.max( __baseline__, char.baseline );
						}
						break;
				}
			}
			__linewidth__ = __x__;
			_textSize.width = Math.max( _textSize.width, __linewidth__ );
			
			if( currentAlignLine != null && currentAlign != "left" )
				toAlign.push( {line:currentAlignLine, align:currentAlign,width:__linewidth__} );
						
			alignVertical( currentAlignLine );	
			
			for( i = 0; i < toAlign.length; i++ )
				_alignMap[ toAlign[ i ].align ].call( null, toAlign[ i ].line, toAlign[ i ].width );
			
			_textSize.height = __y__ + __lineHeight__;
		}

		protected function lookupWordStart ( i : Number, chars:Vector.<Char>, currentAlignLine : Array ) : Number
		{
            
			for(i=i-1;i>=0;i--)
			{
				if( chars[ i ] is NullChar || chars[i].text == " " )
				{
					return i;
				}
				else
				{					__x__ -= chars[i].charWidth + _tracking;					currentAlignLine.pop();
				}
			}
			return 0;
		}
		
		protected function alignVertical ( line : Array ) : void
		{
			_linesRanges.push( __y__ );
			_lines.push( line );
			for each( var c : Char in line )
				c.y += __baseline__ - c.baseline;				//c.y += __lineHeight__ - c.baseline;
		}
		
		protected function alignRight ( line : Array, w : Number ) : void
		{
			var dif : Number = _owner.size.width - w - 4;
			for each( var c : Char in line )
				c.x += dif;
		}
		protected function alignCenter ( line : Array, w : Number ) : void
		{ 
			var dif : Number = (_owner.size.width - w) / 2;
			for each ( var c : Char in line )
				c.x += dif;
		}
		protected function placeChar ( char : Char ) : void
		{
			if( char is SpriteChar )
			{
				char.x = __x__ + 2;
				char.y = __y__ + 4;
			}
			else
			{
				char.x = __x__;
				char.y = __y__;
			}
			__x__ += char.charWidth + int( char.format ? char.format.letterSpacing : 0 ) + _tracking;
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
