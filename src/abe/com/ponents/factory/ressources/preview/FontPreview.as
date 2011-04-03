package abe.com.ponents.factory.ressources.preview 
{
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.HBoxLayout;
	import abe.com.ponents.models.SpinnerListModel;
	import abe.com.ponents.spinners.Spinner;
	import abe.com.mon.logs.Log;
	import abe.com.mon.geom.Range;
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.menus.PopupMenu;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextArea;
	import abe.com.ponents.utils.Insets;

	import flash.text.Font;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * 
	 * @author cedric
	 */
	public class FontPreview extends Panel 
	{
		protected var _font : Font;
		protected var _textPreview : TextArea;
		protected var _selectedRange : Range;

		public function FontPreview ( font : Font = null )
		{
			_selectedRange = UNICODE_RANGES[ UNICODE_RANGES_NAMES[0] ];
			buildChildren();
			
			this.font = font;
		}
		public function get font () : Font { return _font; }
		public function set font (font : Font) : void
		{ 
			_font = font;
			applyRange( _selectedRange );
		}
		
		protected function applyRange( range : Range ) : void
		{
			var s : String = "";
			if( _font )
			{
				var tf : TextFormat = new TextFormat(_font.fontName, 20, 0 );
				tf.leading = 20;
				tf.letterSpacing = 20;
				for( var i : uint = range.min; i <= range.max; i++ )
				{
					s += String.fromCharCode(i);
				}
				
				_textPreview.style.format = tf;
			}
			_textPreview.value = s;
		}
		
		protected function buildChildren () : void 
		{
			var tb : ToolBar = new ToolBar();
			var lb : Label = new Label(_("Unicode Blocks :"));
			//var cb : Spinner = new Spinner(new SpinnerListModel(UNICODE_RANGES_NAMES));
			var cb : ComboBox = new ComboBox(UNICODE_RANGES_NAMES);			cb.popupMenu.scrollLayout = PopupMenu.SCROLLBAR_SCROLL_LAYOUT;
			tb.dndEnabled = false;
			tb.childrenLayout = new HBoxLayout(tb, 3, 
												new BoxSettings(0, "left", "center", lb),
												new BoxSettings(0, "left", "center", cb, true, false, true));
			tb.addComponents( lb, cb );
			cb.addEventListener(ComponentEvent.DATA_CHANGE, unicodeBlockChange );
			
			var bl : BorderLayout = new BorderLayout(this);
						
			_textPreview = new TextArea();
			_textPreview.wordWrap = true;
			_textPreview.textfield.embedFonts = true;
			_textPreview.textfield.type = TextFieldType.DYNAMIC;			_textPreview.style.insets = new Insets(20, 0, 0, 0);
			
			bl.north = tb;
			bl.center = _textPreview;
			childrenLayout = bl;
			
			addComponents(_textPreview,tb );
		}
		protected function unicodeBlockChange (event : ComponentEvent) : void 
		{
			_selectedRange = UNICODE_RANGES[ event.target.value ];
			applyRange( _selectedRange );
		}

		static private const UNICODE_RANGES_NAMES : Array = [
			"Basic Latin",
			"Latin-1 Supplement",
			"Latin Extended-A",
			"Latin Extended-B",
			"IPA Extensions",
			"Spacing Modifier Letters",
			"Combining Diacritical Marks",
			"Greek and Coptic",
			"Cyrillic",
			"Cyrillic Supplement",
			"Armenian",
			"Hebrew",
			"Arabic",
			"Syriac",
			"Arabic Supplement",
			"Thaana",
			"NKo",
			"Samaritan",
			"Mandaic",
			"Devanagari",
			"Bengali",
			"Gurmukhi",
			"Gujarati",
			"Oriya",
			"Tamil",
			"Telugu",
			"Kannada",
			"Malayalam",
			"Sinhala",
			"Thai",
			"Lao",
			"Tibetan",
			"Myanmar",
			"Georgian",
			"Hangul Jamo",
			"Ethiopic",
			"Ethiopic Supplement",
			"Cherokee",
			"Unified Canadian Aboriginal Syllabics",
			"Ogham",
			"Runic",
			"Tagalog",
			"Hanunoo",
			"Buhid",
			"Tagbanwa",
			"Khmer",
			"Mongolian",
			"Unified Canadian Aboriginal Syllabics Extended",
			"Limbu",
			"Tai Le",
			"New Tai Lue",
			"Khmer Symbols",
			"Buginese",
			"Tai Tham",
			"Balinese",
			"Sundanese",
			"Batak",
			"Lepcha",
			"Ol Chiki",
			"Vedic Extensions",
			"Phonetic Extensions",
			"Phonetic Extensions Supplement",
			"Combining Diacritical Marks Supplement",
			"Latin Extended Additional",
			"Greek Extended",
			"General Punctuation",
			"Superscripts and Subscripts",
			"Currency Symbols",
			"Combining Diacritical Marks for Symbols",
			"Letterlike Symbols",
			"Number Forms",
			"Arrows",
			"Mathematical Operators",
			"Miscellaneous Technical",
			"Control Pictures",
			"Optical Character Recognition",
			"Enclosed Alphanumerics",
			"Box Drawing",
			"Block Elements",
			"Geometric Shapes",
			"Miscellaneous Symbols",
			"Dingbats",
			"Miscellaneous Mathematical Symbols-A",
			"Supplemental Arrows-A",
			"Braille Patterns",
			"Supplemental Arrows-B",
			"Miscellaneous Mathematical Symbols-B",
			"Supplemental Mathematical Operators",
			"Miscellaneous Symbols and Arrows",
			"Glagolitic",
			"Latin Extended-C",
			"Coptic",
			"Georgian Supplement",
			"Tifinagh",
			"Ethiopic Extended",
			"Cyrillic Extended-A",
			"Supplemental Punctuation",
			"CJK Radicals Supplement",
			"Kangxi Radicals",
			"Ideographic Description Characters",
			"CJK Symbols and Punctuation",
			"Hiragana",
			"Katakana",
			"Bopomofo",
			"Hangul Compatibility Jamo",
			"Kanbun",
			"Bopomofo Extended",
			"CJK Strokes",
			"Katakana Phonetic Extensions",
			"Enclosed CJK Letters and Months",
			"CJK Compatibility",
			"CJK Unified Ideographs Extension A",
			"Yijing Hexagram Symbols",
			"CJK Unified Ideographs",
			"Yi Syllables",
			"Yi Radicals",
			"Lisu",
			"Vai",
			"Cyrillic Extended-B",
			"Bamum",
			"Modifier Tone Letters",
			"Latin Extended-D",
			"Syloti Nagri",
			"Common Indic Number Forms",
			"Phags-pa",
			"Saurashtra",
			"Devanagari Extended",
			"Kayah Li",
			"Rejang",
			"Hangul Jamo Extended-A",
			"Javanese",
			"Cham",
			"Myanmar Extended-A",
			"Tai Viet",
			"Ethiopic Extended-A",
			"Meetei Mayek",
			"Hangul Syllables",
			"Hangul Jamo Extended-B",
			"High Surrogates",
			"High Private Use Surrogates",
			"Low Surrogates",
			"Private Use Area",
			"CJK Compatibility Ideographs",
			"Alphabetic Presentation Forms",
			"Arabic Presentation Forms-A",
			"Variation Selectors",
			"Vertical Forms",
			"Combining Half Marks",
			"CJK Compatibility Forms",
			"Small Form Variants",
			"Arabic Presentation Forms-B",
			"Halfwidth and Fullwidth Forms",
			"Specials",
			"Linear B Syllabary",
			"Linear B Ideograms",
			"Aegean Numbers",
			"Ancient Greek Numbers",
			"Ancient Symbols",
			"Phaistos Disc",
			"Lycian",
			"Carian",
			"Old Italic",
			"Gothic",
			"Ugaritic",
			"Old Persian",
			"Deseret",
			"Shavian",
			"Osmanya",
			"Cypriot Syllabary",
			"Imperial Aramaic",
			"Phoenician",
			"Lydian",
			"Kharoshthi",
			"Old South Arabian",
			"Avestan",
			"Inscriptional Parthian",
			"Inscriptional Pahlavi",
			"Old Turkic",
			"Rumi Numeral Symbols",
			"Brahmi",
			"Kaithi",
			"Cuneiform",
			"Cuneiform Numbers and Punctuation",
			"Egyptian Hieroglyphs",
			"Bamum Supplement",
			"Kana Supplement",
			"Byzantine Musical Symbols",
			"Musical Symbols",
			"Ancient Greek Musical Notation",
			"Tai Xuan Jing Symbols",
			"Counting Rod Numerals",
			"Mathematical Alphanumeric Symbols",
			"Mahjong Tiles",
			"Domino Tiles",
			"Playing Cards",
			"Enclosed Alphanumeric Supplement",
			"Enclosed Ideographic Supplement",
			"Miscellaneous Symbols And Pictographs",
			"Emoticons",
			"Transport And Map Symbols",
			"Alchemical Symbols",
			"CJK Unified Ideographs Extension B",
			"CJK Unified Ideographs Extension C",
			"CJK Unified Ideographs Extension D",
			"CJK Compatibility Ideographs Supplement",
			"Tags",
			"Variation Selectors Supplement",
			"Supplementary Private Use Area-A",
			"Supplementary Private Use Area-B"
		];
		static private const UNICODE_RANGES : Object = {
			// first range start at 0x0021 and not 0x0000 because
			// 0x0000 break the string and the others produce weird
			// whitespaces 
			'Basic Latin':new Range(0x0021,0x007F),
			'Latin-1 Supplement':new Range(0x0080,0x00FF),
			'Latin Extended-A':new Range(0x0100,0x017F),
			'Latin Extended-B':new Range(0x0180,0x024F),
			'IPA Extensions':new Range(0x0250,0x02AF),
			'Spacing Modifier Letters':new Range(0x02B0,0x02FF),
			'Combining Diacritical Marks':new Range(0x0300,0x036F),
			'Greek and Coptic':new Range(0x0370,0x03FF),
			'Cyrillic':new Range(0x0400,0x04FF),
			'Cyrillic Supplement':new Range(0x0500,0x052F),
			'Armenian':new Range(0x0530,0x058F),
			'Hebrew':new Range(0x0590,0x05FF),
			'Arabic':new Range(0x0600,0x06FF),
			'Syriac':new Range(0x0700,0x074F),
			'Arabic Supplement':new Range(0x0750,0x077F),
			'Thaana':new Range(0x0780,0x07BF),
			'NKo':new Range(0x07C0,0x07FF),
			'Samaritan':new Range(0x0800,0x083F),
			'Mandaic':new Range(0x0840,0x085F),
			'Devanagari':new Range(0x0900,0x097F),
			'Bengali':new Range(0x0980,0x09FF),
			'Gurmukhi':new Range(0x0A00,0x0A7F),
			'Gujarati':new Range(0x0A80,0x0AFF),
			'Oriya':new Range(0x0B00,0x0B7F),
			'Tamil':new Range(0x0B80,0x0BFF),
			'Telugu':new Range(0x0C00,0x0C7F),
			'Kannada':new Range(0x0C80,0x0CFF),
			'Malayalam':new Range(0x0D00,0x0D7F),
			'Sinhala':new Range(0x0D80,0x0DFF),
			'Thai':new Range(0x0E00,0x0E7F),
			'Lao':new Range(0x0E80,0x0EFF),
			'Tibetan':new Range(0x0F00,0x0FFF),
			'Myanmar':new Range(0x1000,0x109F),
			'Georgian':new Range(0x10A0,0x10FF),
			'Hangul Jamo':new Range(0x1100,0x11FF),
			'Ethiopic':new Range(0x1200,0x137F),
			'Ethiopic Supplement':new Range(0x1380,0x139F),
			'Cherokee':new Range(0x13A0,0x13FF),
			'Unified Canadian Aboriginal Syllabics':new Range(0x1400,0x167F),
			'Ogham':new Range(0x1680,0x169F),
			'Runic':new Range(0x16A0,0x16FF),
			'Tagalog':new Range(0x1700,0x171F),
			'Hanunoo':new Range(0x1720,0x173F),
			'Buhid':new Range(0x1740,0x175F),
			'Tagbanwa':new Range(0x1760,0x177F),
			'Khmer':new Range(0x1780,0x17FF),
			'Mongolian':new Range(0x1800,0x18AF),
			'Unified Canadian Aboriginal Syllabics Extended':new Range(0x18B0,0x18FF),
			'Limbu':new Range(0x1900,0x194F),
			'Tai Le':new Range(0x1950,0x197F),
			'New Tai Lue':new Range(0x1980,0x19DF),
			'Khmer Symbols':new Range(0x19E0,0x19FF),
			'Buginese':new Range(0x1A00,0x1A1F),
			'Tai Tham':new Range(0x1A20,0x1AAF),
			'Balinese':new Range(0x1B00,0x1B7F),
			'Sundanese':new Range(0x1B80,0x1BBF),
			'Batak':new Range(0x1BC0,0x1BFF),
			'Lepcha':new Range(0x1C00,0x1C4F),
			'Ol Chiki':new Range(0x1C50,0x1C7F),
			'Vedic Extensions':new Range(0x1CD0,0x1CFF),
			'Phonetic Extensions':new Range(0x1D00,0x1D7F),
			'Phonetic Extensions Supplement':new Range(0x1D80,0x1DBF),
			'Combining Diacritical Marks Supplement':new Range(0x1DC0,0x1DFF),
			'Latin Extended Additional':new Range(0x1E00,0x1EFF),
			'Greek Extended':new Range(0x1F00,0x1FFF),
			'General Punctuation':new Range(0x2000,0x206F),
			'Superscripts and Subscripts':new Range(0x2070,0x209F),
			'Currency Symbols':new Range(0x20A0,0x20CF),
			'Combining Diacritical Marks for Symbols':new Range(0x20D0,0x20FF),
			'Letterlike Symbols':new Range(0x2100,0x214F),
			'Number Forms':new Range(0x2150,0x218F),
			'Arrows':new Range(0x2190,0x21FF),
			'Mathematical Operators':new Range(0x2200,0x22FF),
			'Miscellaneous Technical':new Range(0x2300,0x23FF),
			'Control Pictures':new Range(0x2400,0x243F),
			'Optical Character Recognition':new Range(0x2440,0x245F),
			'Enclosed Alphanumerics':new Range(0x2460,0x24FF),
			'Box Drawing':new Range(0x2500,0x257F),
			'Block Elements':new Range(0x2580,0x259F),
			'Geometric Shapes':new Range(0x25A0,0x25FF),
			'Miscellaneous Symbols':new Range(0x2600,0x26FF),
			'Dingbats':new Range(0x2700,0x27BF),
			'Miscellaneous Mathematical Symbols-A':new Range(0x27C0,0x27EF),
			'Supplemental Arrows-A':new Range(0x27F0,0x27FF),
			'Braille Patterns':new Range(0x2800,0x28FF),
			'Supplemental Arrows-B':new Range(0x2900,0x297F),
			'Miscellaneous Mathematical Symbols-B':new Range(0x2980,0x29FF),
			'Supplemental Mathematical Operators':new Range(0x2A00,0x2AFF),
			'Miscellaneous Symbols and Arrows':new Range(0x2B00,0x2BFF),
			'Glagolitic':new Range(0x2C00,0x2C5F),
			'Latin Extended-C':new Range(0x2C60,0x2C7F),
			'Coptic':new Range(0x2C80,0x2CFF),
			'Georgian Supplement':new Range(0x2D00,0x2D2F),
			'Tifinagh':new Range(0x2D30,0x2D7F),
			'Ethiopic Extended':new Range(0x2D80,0x2DDF),
			'Cyrillic Extended-A':new Range(0x2DE0,0x2DFF),
			'Supplemental Punctuation':new Range(0x2E00,0x2E7F),
			'CJK Radicals Supplement':new Range(0x2E80,0x2EFF),
			'Kangxi Radicals':new Range(0x2F00,0x2FDF),
			'Ideographic Description Characters':new Range(0x2FF0,0x2FFF),
			'CJK Symbols and Punctuation':new Range(0x3000,0x303F),
			'Hiragana':new Range(0x3040,0x309F),
			'Katakana':new Range(0x30A0,0x30FF),
			'Bopomofo':new Range(0x3100,0x312F),
			'Hangul Compatibility Jamo':new Range(0x3130,0x318F),
			'Kanbun':new Range(0x3190,0x319F),
			'Bopomofo Extended':new Range(0x31A0,0x31BF),
			'CJK Strokes':new Range(0x31C0,0x31EF),
			'Katakana Phonetic Extensions':new Range(0x31F0,0x31FF),
			'Enclosed CJK Letters and Months':new Range(0x3200,0x32FF),
			'CJK Compatibility':new Range(0x3300,0x33FF),
			'CJK Unified Ideographs Extension A':new Range(0x3400,0x4DBF),
			'Yijing Hexagram Symbols':new Range(0x4DC0,0x4DFF),
			'CJK Unified Ideographs':new Range(0x4E00,0x9FFF),
			'Yi Syllables':new Range(0xA000,0xA48F),
			'Yi Radicals':new Range(0xA490,0xA4CF),
			'Lisu':new Range(0xA4D0,0xA4FF),
			'Vai':new Range(0xA500,0xA63F),
			'Cyrillic Extended-B':new Range(0xA640,0xA69F),
			'Bamum':new Range(0xA6A0,0xA6FF),
			'Modifier Tone Letters':new Range(0xA700,0xA71F),
			'Latin Extended-D':new Range(0xA720,0xA7FF),
			'Syloti Nagri':new Range(0xA800,0xA82F),
			'Common Indic Number Forms':new Range(0xA830,0xA83F),
			'Phags-pa':new Range(0xA840,0xA87F),
			'Saurashtra':new Range(0xA880,0xA8DF),
			'Devanagari Extended':new Range(0xA8E0,0xA8FF),
			'Kayah Li':new Range(0xA900,0xA92F),
			'Rejang':new Range(0xA930,0xA95F),
			'Hangul Jamo Extended-A':new Range(0xA960,0xA97F),
			'Javanese':new Range(0xA980,0xA9DF),
			'Cham':new Range(0xAA00,0xAA5F),
			'Myanmar Extended-A':new Range(0xAA60,0xAA7F),
			'Tai Viet':new Range(0xAA80,0xAADF),
			'Ethiopic Extended-A':new Range(0xAB00,0xAB2F),
			'Meetei Mayek':new Range(0xABC0,0xABFF),
			'Hangul Syllables':new Range(0xAC00,0xD7AF),
			'Hangul Jamo Extended-B':new Range(0xD7B0,0xD7FF),
			'High Surrogates':new Range(0xD800,0xDB7F),
			'High Private Use Surrogates':new Range(0xDB80,0xDBFF),
			'Low Surrogates':new Range(0xDC00,0xDFFF),
			'Private Use Area':new Range(0xE000,0xF8FF),
			'CJK Compatibility Ideographs':new Range(0xF900,0xFAFF),
			'Alphabetic Presentation Forms':new Range(0xFB00,0xFB4F),
			'Arabic Presentation Forms-A':new Range(0xFB50,0xFDFF),
			'Variation Selectors':new Range(0xFE00,0xFE0F),
			'Vertical Forms':new Range(0xFE10,0xFE1F),
			'Combining Half Marks':new Range(0xFE20,0xFE2F),
			'CJK Compatibility Forms':new Range(0xFE30,0xFE4F),
			'Small Form Variants':new Range(0xFE50,0xFE6F),
			'Arabic Presentation Forms-B':new Range(0xFE70,0xFEFF),
			'Halfwidth and Fullwidth Forms':new Range(0xFF00,0xFFEF),
			'Specials':new Range(0xFFF0,0xFFFF),
			'Linear B Syllabary':new Range(0x10000,0x1007F),
			'Linear B Ideograms':new Range(0x10080,0x100FF),
			'Aegean Numbers':new Range(0x10100,0x1013F),
			'Ancient Greek Numbers':new Range(0x10140,0x1018F),
			'Ancient Symbols':new Range(0x10190,0x101CF),
			'Phaistos Disc':new Range(0x101D0,0x101FF),
			'Lycian':new Range(0x10280,0x1029F),
			'Carian':new Range(0x102A0,0x102DF),
			'Old Italic':new Range(0x10300,0x1032F),
			'Gothic':new Range(0x10330,0x1034F),
			'Ugaritic':new Range(0x10380,0x1039F),
			'Old Persian':new Range(0x103A0,0x103DF),
			'Deseret':new Range(0x10400,0x1044F),
			'Shavian':new Range(0x10450,0x1047F),
			'Osmanya':new Range(0x10480,0x104AF),
			'Cypriot Syllabary':new Range(0x10800,0x1083F),
			'Imperial Aramaic':new Range(0x10840,0x1085F),
			'Phoenician':new Range(0x10900,0x1091F),
			'Lydian':new Range(0x10920,0x1093F),
			'Kharoshthi':new Range(0x10A00,0x10A5F),
			'Old South Arabian':new Range(0x10A60,0x10A7F),
			'Avestan':new Range(0x10B00,0x10B3F),
			'Inscriptional Parthian':new Range(0x10B40,0x10B5F),
			'Inscriptional Pahlavi':new Range(0x10B60,0x10B7F),
			'Old Turkic':new Range(0x10C00,0x10C4F),
			'Rumi Numeral Symbols':new Range(0x10E60,0x10E7F),
			'Brahmi':new Range(0x11000,0x1107F),
			'Kaithi':new Range(0x11080,0x110CF),
			'Cuneiform':new Range(0x12000,0x123FF),
			'Cuneiform Numbers and Punctuation':new Range(0x12400,0x1247F),
			'Egyptian Hieroglyphs':new Range(0x13000,0x1342F),
			'Bamum Supplement':new Range(0x16800,0x16A3F),
			'Kana Supplement':new Range(0x1B000,0x1B0FF),
			'Byzantine Musical Symbols':new Range(0x1D000,0x1D0FF),
			'Musical Symbols':new Range(0x1D100,0x1D1FF),
			'Ancient Greek Musical Notation':new Range(0x1D200,0x1D24F),
			'Tai Xuan Jing Symbols':new Range(0x1D300,0x1D35F),
			'Counting Rod Numerals':new Range(0x1D360,0x1D37F),
			'Mathematical Alphanumeric Symbols':new Range(0x1D400,0x1D7FF),
			'Mahjong Tiles':new Range(0x1F000,0x1F02F),
			'Domino Tiles':new Range(0x1F030,0x1F09F),
			'Playing Cards':new Range(0x1F0A0,0x1F0FF),
			'Enclosed Alphanumeric Supplement':new Range(0x1F100,0x1F1FF),
			'Enclosed Ideographic Supplement':new Range(0x1F200,0x1F2FF),
			'Miscellaneous Symbols And Pictographs':new Range(0x1F300,0x1F5FF),
			'Emoticons':new Range(0x1F600,0x1F64F),
			'Transport And Map Symbols':new Range(0x1F680,0x1F6FF),
			'Alchemical Symbols':new Range(0x1F700,0x1F77F),
			'CJK Unified Ideographs Extension B':new Range(0x20000,0x2A6DF),
			'CJK Unified Ideographs Extension C':new Range(0x2A700,0x2B73F),
			'CJK Unified Ideographs Extension D':new Range(0x2B740,0x2B81F),
			'CJK Compatibility Ideographs Supplement':new Range(0x2F800,0x2FA1F),
			'Tags':new Range(0xE0000,0xE007F),
			'Variation Selectors Supplement':new Range(0xE0100,0xE01EF),
			'Supplementary Private Use Area-A':new Range(0xF0000,0xFFFFF),
			'Supplementary Private Use Area-B':new Range(0x100000,0x10FFFF)
		};
	}
}
