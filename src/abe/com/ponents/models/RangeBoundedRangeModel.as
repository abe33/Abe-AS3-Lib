package abe.com.ponents.models 
{
	import abe.com.mon.geom.Range;
	/**
	 * @author cedric
	 */
	public class RangeBoundedRangeModel extends DefaultBoundedRangeModel 
	{
		public function RangeBoundedRangeModel ( range : Range, min : Number = 0, max : Number = 100 )
		{
			super( range.min, min, max, range.size() );
		}
		public function get range() : Range { return new Range( value, value + extent ); }
		public function set range( r : Range ) : void 
		{ 
			value = range.min; 
			extent = range.size(); 
		}
		public function get displayRangeMax () : String { return _formatFunction( _value + _extent ); 
		}
	}
}
