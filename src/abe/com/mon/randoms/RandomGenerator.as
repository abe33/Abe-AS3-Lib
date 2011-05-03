package abe.com.mon.randoms 
{
	/**
	 * @author cedric
	 */
	public interface RandomGenerator 
	{
		function random() : Number;
		function get isSeeded () : Boolean;
	}
}
