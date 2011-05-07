/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
	import abe.com.mon.utils.RandomUtils;
	/**
	 * @author Cédric Néhémie
	 */
	public class RandomTimeTweenScaleDisplayEffect extends TweenScaleDisplayEffect 
	{
		public function RandomTimeTweenScaleDisplayEffect (delay : Number = 50, 
														   tweenDuration : Number = 500, 
														   easing : Function = null, 
														   timeout : Number = 0, 
														   autoStart : Boolean = true)
		{
			super( delay, tweenDuration, easing, timeout, autoStart );
		}
		override public function init () : void
		{
			chars.sort( RandomUtils.randomSort );
			super.init( );
		}
	}
}
