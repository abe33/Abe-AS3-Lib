/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
    import abe.com.edia.text.fx.CharEffect;

    import flash.events.IEventDispatcher;
	/**
	 * @author Cédric Néhémie
	 */
	public interface TimedDisplayEffect extends IEventDispatcher, CharEffect
	{
		function showAll () : void;		
		function fireComplete() : void;
		function reset () : void;
	}
}
