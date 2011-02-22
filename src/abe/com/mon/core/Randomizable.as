package abe.com.mon.core 
{
	import abe.com.mon.utils.Random;
	/**
	 * @author cedric
	 */
	public interface Randomizable 
	{
		function get randomSource() : Random;
		function set randomSource( randomSource : Random ) : void;
	}
}
