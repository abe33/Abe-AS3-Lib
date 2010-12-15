package aesia.com.mon.core 
{
	import aesia.com.mon.utils.Random;
	/**
	 * @author cedric
	 */
	public interface Randomizable 
	{
		function get randomSource() : Random;
		function set randomSource( randomSource : Random ) : void;
	}
}
