package abe.com.ponents.scrollbars 
{
	import abe.com.mon.geom.Dimension;

	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public interface Scrollable extends IEventDispatcher
	{
		function get preferredViewportSize () : Dimension;
		
		function get tracksViewportH () : Boolean;		function get tracksViewportV () : Boolean;
		
		function getScrollableUnitIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number;		function getScrollableUnitIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number;
		
		function getScrollableBlockIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number;		function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number;
	}
}
