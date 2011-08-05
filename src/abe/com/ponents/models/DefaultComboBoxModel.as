package abe.com.ponents.models 
{
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
        
        
        override public function addElementAt ( el : *, id : uint ) : void
        {
            if( id < _selectedIndex )
            	_selectedIndex++;
            super.addElementAt ( el, id );
        }

        override public function removeElement ( el : * ) : void
        {
            if( indexOf(el) < _selectedIndex )
            	_selectedIndex--;
            else if( indexOf(el) == _selectedIndex )
            	_selectedIndex = 0;
            
            super.removeElement ( el );
        }

        override public function removeElementAt ( id : uint ) : void
        {
            super.removeElementAt ( id );
            if( id < _selectedIndex )
            	_selectedIndex--;
            else if( id == _selectedIndex )
            	_selectedIndex = 0;
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
