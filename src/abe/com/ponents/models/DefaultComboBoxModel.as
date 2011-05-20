package abe.com.ponents.models 
{
	import abe.com.ponents.events.ComponentEvent;
	
	import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	public class DefaultComboBoxModel extends DefaultListModel implements ComboBoxModel 
	{
		protected var _selectedIndex : int;
		protected var _selectionChanged : Signal;
		
		public function DefaultComboBoxModel (initialData : Array = null)
		{
			super( initialData );
			_selectedIndex = 0;
			_selectionChanged = new Signal();
		}
		
		public function get selectionChanged() : Signal { return _selectionChanged; }

		public function get selectedElement () : * { return get( _selectedIndex ); }
		public function set selectedElement ( el : *) : void
		{
			if( contains( el ) )
			{
				_selectedIndex = indexOf( el ); 
				fireSelectionChangedSignal();
			}
		}

		public function fireSelectionChangedSignal () : void
		{
			_selectionChanged.dispatch( this, _selectedIndex, getElementAt( _selectedIndex ) );
		}
	}
}
