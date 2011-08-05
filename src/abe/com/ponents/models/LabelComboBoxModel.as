package abe.com.ponents.models 
{
	/**
	 * @author cedric
	 */
	public class LabelComboBoxModel extends DefaultComboBoxModel implements ComboBoxModel 
	{
		protected var _labels : Array;

		public function LabelComboBoxModel ( initialData : Array = null, labels : Array = null )
		{
			super( initialData );
			_labels = labels;
		}
        
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
