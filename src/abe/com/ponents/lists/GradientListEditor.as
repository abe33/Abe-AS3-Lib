package abe.com.ponents.lists 
{
	import abe.com.mon.colors.Gradient;
	import abe.com.ponents.buttons.GradientPicker;
	/**
	 * @author cedric
	 */
	public class GradientListEditor extends ListEditor 
	{
		public function GradientListEditor ( ... args )
		{
			super( args, new GradientPicker(), Gradient );
			_list.listCellClass = GradientListCell;
			_list.listLayout.clearEstimatedSize();
			invalidatePreferredSizeCache();
		}
	}
}
