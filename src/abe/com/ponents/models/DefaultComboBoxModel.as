package abe.com.ponents.models 
{
	import abe.com.ponents.events.ComponentEvent;
	/**
	 * @author Cédric Néhémie
	 */
	public class DefaultComboBoxModel extends DefaultListModel implements ComboBoxModel 
	{
		protected var _selectedIndex : int;
		
		public function DefaultComboBoxModel (initialData : Array = null)
		{
			super( initialData );
			_selectedIndex = 0;
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
	}
}
