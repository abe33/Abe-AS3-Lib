package aesia.com.ponents.models 
{
	import aesia.com.ponents.events.ComponentEvent;
	/**
	 * @author cedric
	 */
	public class LabelComboBoxModel extends DefaultListModel implements ComboBoxModel 
	{
		protected var _selectedIndex : int;
		protected var _labels : Array;

		public function LabelComboBoxModel ( initialData : Array = null, labels : Array = null )
		{
			super( initialData );
			_selectedIndex = 0;
			_labels = labels;
		}
		
		public function get selectedElement () : * { return get( _selectedIndex ); }
		public function set selectedElement ( el : *) : void
		{
			if( contains( el ) )
			{
				_selectedIndex = indexOf( el ); 
				fireSelectionChange();
			}
		}

		public function fireSelectionChange () : void
		{
			dispatchEvent( new ComponentEvent ( ComponentEvent.SELECTION_CHANGE ) );
		}
		public function getLabel( i : * ) : String
		{
			return _labels[ _datas.indexOf( i ) ];
		}
	}
}
