package aesia.com.ponents.lists 
{
	import aesia.com.mon.utils.DimensionUtils;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.Directions;

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
