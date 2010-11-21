package aesia.com.ponents.lists 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Palette;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.ponents.buttons.ColorPicker;

	/**
	 * @author cedric
	 */
	public class ColorListEditor extends ListEditor
	{
		public function ColorListEditor ( ... args )
		{
			super( args, new ColorPicker(), Color );
			_list.listCellClass = ColorListCell;
			_list.listLayout.clearEstimatedSize();
			invalidatePreferredSizeCache();
		}
		public function getPalette() : Palette
		{
			return Reflection.buildInstance( Palette, ["Unnamed Palette"].concat( value as Array ) ) as Palette;
		}
	}
}
