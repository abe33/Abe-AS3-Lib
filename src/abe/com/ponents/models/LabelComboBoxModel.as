package abe.com.ponents.models 
{
    import org.osflash.signals.Signal;
	/**
	 * @author cedric
	 */
	public class LabelComboBoxModel extends DefaultListModel implements ComboBoxModel 
	{
		protected var _selectedIndex : int;
		protected var _labels : Array;
		
		public var selectionChanged : Signal;

		public function LabelComboBoxModel ( initialData : Array = null, labels : Array = null )
		{
		    selectionChanged = new Signal();
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
			selectionChanged.dispatch( _selectedIndex );
		}
		public function getLabel( i : * ) : String
		{
			return _labels[ _datas.indexOf( i ) ];
		}
	}
}
