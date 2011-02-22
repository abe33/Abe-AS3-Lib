package abe.com.ponents.menus 
{
	import abe.com.mon.utils.Reflection;
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
				b[i] = f.fontName;
			}
			var m : DefaultComboBoxModel = new DefaultComboBoxModel( b );

			super( m );
			_popupMenu.scrollLayout = PopupMenu.SCROLLBAR_SCROLL_LAYOUT;
			
			var tf : TextFormat = new TextFormat();
			tf.tabStops = [ 100 ];
			style.setForAllStates( "format" , tf );
			
			itemFormatingFunction = function(v:*):String
			{
				return "<font face='"+v+"' size='16' color='" + Reflection.get("skin.DarkBlue.html") + "'>Sample</font>\t"+v;
			};
		}
		/*
		override protected function formatLabel ( value : *) : String 
		{
			return _$(_("$0\t<font face='$0' size='13'>Sample</font>"), value );
		}*/
	}
}
