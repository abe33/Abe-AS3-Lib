package abe.com.ponents.lists 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.colors.Palette;
    import abe.com.mon.utils.Reflection;
    import abe.com.ponents.buttons.ColorPicker;
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
