package abe.com.ponents.lists 
{
    import abe.com.mon.utils.DimensionUtils;
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.utils.Directions;

    import flash.display.BitmapData;
	/**
	 * @author cedric
	 */
	public class BitmapListCell extends DefaultListCell 
	{
		public function BitmapListCell ()
		{
			super( );
			(_childrenLayout as DOInlineLayout).direction = Directions.RIGHT_TO_LEFT;
		}

		override public function set value (val : *) : void
		{
			super.value = val;
			var ico : Icon = magicIconBuild(val);
			ico.preferredSize = DimensionUtils.fitDimension( ico.preferredSize, 40 );
			icon = ico;
		}

		override protected function formatLabel (value : *) : String
		{
			var bmp : BitmapData = value as BitmapData;
			return bmp.width + "x" + bmp.height;
		}
	}
}
