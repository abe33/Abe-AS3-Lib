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
		protected var _selectionChanged : Signal;

		public function LabelComboBoxModel ( initialData : Array = null, labels : Array = null )
		{
		    _selectionChanged = new Signal();
			super( initialData );
			_selectedIndex = 0;
			_labels = labels;
		}
        public function get selectionChanged () : Signal { return _selectionChanged; }
        
        
        override public function addElement ( el : * ) : void
        {
            _labels.push(el[1]);
            super.addElement ( el[0] );
            
        }
        override public function addElementAt ( el : *, id : uint ) : void
        {
            _labels.splice( id, 0, el[1] );
            super.addElementAt ( el[0], id );
        }
		
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
		public function getLabel( i : * ) : String
		{
            return _labels[ _datas.indexOf ( i ) ];
        }
        public function setLabel( i : *, s : String ) : void
		{
            _labels[ _datas.indexOf ( i ) ] = s;
        }
	}
}
