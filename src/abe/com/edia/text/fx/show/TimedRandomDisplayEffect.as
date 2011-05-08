/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
	import abe.com.mon.utils.RandomUtils;
	/**
	 * @author Cédric Néhémie
	 */
	public class TimedRandomDisplayEffect extends DefaultTimedDisplayEffect 
	{
		public function TimedRandomDisplayEffect (delay : Number = 50, start : Number = 0, autoStart : Boolean = true)
		{
			super( delay, start, autoStart );
		}

		override public function init () : void
		{
			chars.sort( RandomUtils.randomSort );
			super.init();
		}
	}
}
