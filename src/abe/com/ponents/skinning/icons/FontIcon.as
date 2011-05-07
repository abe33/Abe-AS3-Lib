package abe.com.ponents.skinning.icons 
{
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * @author Cédric Néhémie
	 */
	public class FontIcon extends Icon 
	{
		protected var _font : Font;
		protected var _class : Class;
		protected var _icon : TextField;
		
		public function FontIcon ( f : Class )
		{
			super();
			_font = new f();
			_class = f;
			_contentType = "Font";
			Font.registerFont(_class);
		}
		override public function dispose () : void 
		{
			if( _icon && _childrenContainer.contains( _icon ) )
				_childrenContainer.removeChild( _icon );
				
			super.dispose();
		}		
		override public function init () : void 
		{
			_icon = new TextField();
			_icon.autoSize = "left";
			_icon.embedFonts = true;
			_icon.defaultTextFormat = new TextFormat( _font.fontName, 20, 0, _font.fontStyle == FontStyle.BOLD || 
																			 _font.fontStyle == FontStyle.BOLD_ITALIC, 
																			 _font.fontStyle == FontStyle.ITALIC || 
																			 _font.fontStyle == FontStyle.BOLD_ITALIC );
			_icon.text = "Aa";
			_childrenContainer.addChild( _icon );
			
			super.init();
		}
		override public function clone () : * 
		{ 
			return new FontIcon( _class ); 
		}
	}
}
