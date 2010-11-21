package aesia.com.ponents.lists 
{
	import aesia.com.mon.utils.Gradient;
	import aesia.com.ponents.buttons.GradientPicker;

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
