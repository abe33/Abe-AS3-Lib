package aesia.com.ponents.menus 
{
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.text.TextFormat;

	/**
	 * @author cedric
	 */
	public class FontMenuItem extends MenuItem
	{
		public function FontMenuItem ( actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
			cacheAsBitmap= true;
			var tf : TextFormat = new TextFormat();
			tf.tabStops = [ 100 ];
			style.setForAllStates( "format" , tf );
			
			_labelTextField.defaultTextFormat = style.format;
			_labelTextField.textColor = style.textColor.hexa;
			updateLabelText();
		}
	}
}
