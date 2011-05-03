/**
 * @license
 */
package abe.com.edia.text.fx.soliton 
{
	import abe.com.edia.text.core.Char;
	import abe.com.mon.utils.RandomUtils;

	/**
	 * @author Cédric Néhémie
	 */
	public class SolitonTrembleWaveEffect extends SolitonWaveEffect 
	{
		public function SolitonTrembleWaveEffect (waveSpeed : Number = 6, waveLength : Number = 6, waveAmplitude : Number = 5, timeout : Number = 0, autoStart : Boolean = true )
		{
			super( waveSpeed, waveLength, waveAmplitude, timeout, autoStart );
		}
		override protected function changeChar ( c : Char, i : Number ) : void
		{
			if( c.charContent )
			{
				c.charContent.x = RandomUtils.balance( waveAmplitude ) * i;
				c.charContent.y = RandomUtils.balance( waveAmplitude ) * i;	
			}		
		}
	}
}
