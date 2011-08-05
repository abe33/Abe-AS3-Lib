package abe.com.mands.load 
{

	import org.osflash.signals.Signal;

	/**
	 * @author Cédric Néhémie
	 */
	public interface Estimator
	{
		function get estimationsAvailable () : Signal;
		function get estimationsProgressed () : Signal;
	}
}
