package abe.com.ponents.menus 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.Reflection;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.models.DefaultComboBoxModel;

	import flash.text.Font;
	import flash.text.TextFormat;
	/**
	 * @author cedric
	 */

	public class FontListComboBox extends ComboBox 
	{
		public function FontListComboBox ( enumerateDeviceFonts : Boolean = true )
		{
			var a : Array = Font.enumerateFonts( enumerateDeviceFonts );
			a.sortOn( "fontName", Array.CASEINSENSITIVE );
			var l : Number = a.length;
			_menuItemClass = FontMenuItem;
			
			var b : Array = [];
			for( var i:Number = 0; i<l; i++ )
			{
				var f : Font = a[i];
				b[i] = f;
			}
			var m : DefaultComboBoxModel = new DefaultComboBoxModel( b );

			super( m );
			_popupMenu.scrollLayout = PopupMenu.SCROLLBAR_SCROLL_LAYOUT;
			_popupMenu.maximumVisibleItems = 12;
            
			var tf : TextFormat = new TextFormat();
			tf.tabStops = [ 100 ];
			style.setForAllStates( "format" , tf );
			
			itemFormatingFunction = function(v:*):String
			{
				var f : Font = v as Font;
				var embed : String = "";
				v = f.fontName;
				if( f.fontType == "embedded" )
					embed = _$( " <font color='$0'>(embed)</font>", Color.OrangeRed.html );
				
				return _$("<font face='$0' size='16' color='$1'>Sample</font>\t$0$2", v, Reflection.get("skin.DarkBlue.html"), embed );
			};
		}
		/*
		override protected function formatLabel ( value : *) : String 
		{
			return _$(_("$0\t<font face='$0' size='13'>Sample</font>"), value );
		}*/
	}
}
