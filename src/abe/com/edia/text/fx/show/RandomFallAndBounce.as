/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
	import abe.com.mon.utils.RandomUtils;
	/**
	 * @author Cédric Néhémie
	 */
	public class RandomFallAndBounce extends FallAndBounce 
	{
		public function RandomFallAndBounce (delay : Number = 50, height : Number = 200, gravity : Number = 50, start : Number = 0, autoStart : Boolean = true)
		{
			super( delay, height, gravity, start, autoStart );
		}
		override public function init () : void
		{
			chars.sort( RandomUtils.randomSort );
			super.init( );
		}
	}
}
