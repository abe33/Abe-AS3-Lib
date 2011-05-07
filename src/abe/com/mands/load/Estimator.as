package abe.com.mands.load 
{
	import flash.events.IEventDispatcher;
	/**
	 * @author Cédric Néhémie
	 */
	public interface Estimator extends IEventDispatcher
	{
		/**
		 * 
		 * 
		 * @param	rate
		 * @param	remain
		 */
		function fireEstimationAvailable ( rate : Number, remain : Number ) : void;
		
		/**
		 * 
		 * 
		 * @param	rate
		 * @param	remain
		 */
		function fireNewEstimation ( rate : Number, remain : Number ) : void;
	}
}
