package aesia.com.ponents.models 
{
	
	/**
	 * @author Cédric Néhémie
	 */
	public class SpinnerListModel extends AbstractSpinnerModel 
	{
		protected var _values : Array;
		protected var _index : Number;
		
		public function SpinnerListModel ( ... args )
		{
			if( args.length == 0 )
				_values = [];
			else if( args.length == 1 )
			{
				if( args[ 0 ] is Array )
					_values = args[0];
				else
					_values = [];
			}
			else
				_values = args;
				
			_index = 0;
		}
		
		override public function get displayValue () : String {	return String( _values[_index] ); }
		override public function get value () : * { return _values[_index]; }
		
		override public function set value (v : *) : void 
		{
			var sv : String = String ( v );
			var a : Array = _values.filter( function (item:*, ... args ) : Boolean
			{
				if( String(item).indexOf( sv ) != -1 )
					return true;
					
				return false;
			} );
			if( a.length > 0 )
				_index = _values.indexOf(a[0]);
			
			fireDataChange();
		}

		override public function getNextValue () : *
		{
			if( hasNextValue() )
				return _values[ ++_index ];
		}
		override public function getPreviousValue () : *
		{
			if( hasPreviousValue() )
				return _values[ --_index ];
		}

		override public function hasPreviousValue () : Boolean
		{
			return _index - 1 >= 0;
		}

		override public function hasNextValue () : Boolean
		{
			return _index + 1 < _values.length;
		}
	}
}
