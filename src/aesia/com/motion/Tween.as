/**
 * @license
 */
package  aesia.com.motion
{
	import aesia.com.mands.Command;
	import aesia.com.mon.core.Runnable;
	import aesia.com.mon.core.Suspendable;
	public interface Tween extends Command, Runnable, Suspendable, ImpulseListener
	{
		/**
		 * Une valeur booléenne indiquant si l'interpolation se fait
		 * dans le sens inverse ou non.
		 */
		function get reversed() : Boolean;
		function set reversed( b : Boolean ) : void;
		/**
		 * La position de la tête de lecture de cette interpolation dans la plage
		 * <code>0-1</code>.
		 */
		function get playHeadPosition () : Number;
		function set playHeadPosition ( n : Number ) : void;

		/**
		 * La fonction de transition utilisée pour cette interpolation.
		 */
		function get easing() : Function;
		function set easing( f : Function ) : void;
		/**
		 * La durée de cette interpolation.
		 */
		function get duration() : Number;
		function set duration( n : Number ) : void;
		/**
		 * La cible de cette interpolation.
		 */
		function get target() : Object;
		function set target( o : Object ) : void;


	}
}