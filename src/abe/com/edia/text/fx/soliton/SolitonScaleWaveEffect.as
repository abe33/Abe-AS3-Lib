/**
 * @license
 */
package abe.com.edia.text.fx.soliton 
{
	import abe.com.edia.text.core.Char;

	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class SolitonScaleWaveEffect extends SolitonWaveEffect 
	{
		protected var sizexs : Dictionary;
		protected var sizeys : Dictionary;
			
		public function SolitonScaleWaveEffect ( waveSpeed : Number = 3, waveLength : Number = 6, waveAmplitude : Number = 2, timeout : Number = 0, autoStart : Boolean = true )
		{
			super( waveSpeed, waveLength, waveAmplitude, timeout, autoStart );
			this.sizexs = new Dictionary( true );
			this.sizeys = new Dictionary( true );
		}
		override public function init () :void
		{
			super.init();
			
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				sizexs[ char ] = char.width;
				sizeys[ char ] = char.height;
			}
		}

		override protected function changeChar ( c : Char, i : Number ) : void
		{
			var factor : Number = 1+i * waveAmplitude;
			c.charContent.scaleX = c.charContent.scaleY = factor;
			c.charContent.x = ( sizexs[ c ] - sizexs[ c ] * factor ) / 2;
			c.charContent.y = ( sizeys[ c ] - sizeys[ c ] * factor ) / 2;			
		}
	}
}
