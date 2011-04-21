/**
 * @license
 */
package abe.com.edia.text.fx.hide 
{
	import abe.com.mon.utils.RandomUtils;

	/**
	 * @author Cédric Néhémie
	 */
	public class RandomFallingChars extends FallingChars 
	{
		public function RandomFallingChars (delay : Number = 50, gravity : Number = 50, start : Number = 0, autoStart : Boolean = true)
		{
			super( delay, gravity, start, autoStart );
		}
		override public function init () : void
		{
			chars.sort( RandomUtils.randomSort );
			super.init( );
		}
	}
}
