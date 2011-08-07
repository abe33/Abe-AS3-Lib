/**
 * @license
 */
package abe.com.edia.text.fx.soliton 
{
    import abe.com.edia.text.core.Char;
    import abe.com.edia.text.fx.AbstractCharEffect;
    import abe.com.mands.Timeout;
	/**
	 * @author Cédric Néhémie
	 */
	public class SolitonWaveEffect extends AbstractCharEffect 
	{
		protected var cursor : Number;
		protected var waveLength : Number;		protected var waveSpeed : Number;		protected var waveAmplitude : Number;
		
		protected var timeout : Timeout;

		public function SolitonWaveEffect ( waveSpeed : Number = 6, waveLength : Number = 6, waveAmplitude : Number = 5, timeout : Number = 0, autoStart : Boolean = true )
		{
			super( autoStart );
			this.waveLength = waveLength;
			this.waveSpeed = waveSpeed;
			this.waveAmplitude = waveAmplitude;
			this.timeout = new Timeout( super.start, timeout );
		}

		override public function init () :void
		{
			cursor = 0;
			super.init();
		}

		override public function start () : void
		{
			timeout.start();
		}

		override public function stop () : void
		{
			timeout.stop();
			super.stop();
		}

		override public function dispose () : void
		{
			super.dispose();
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				changeChar( chars[ i ], 0 );
			}
			stop();
		}

		override public function tick ( bias:Number, biasInSecond : Number, time : Number ) : void
		{
			var l : Number = chars.length;
			
			for( var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				
				if( char != null )
				{
					if( i > cursor - waveLength && i < cursor + waveLength )
						changeChar( char, getRatio ( i ) );
					else
						changeChar( char, 0 );
				}
			}
			
			if( cursor - waveLength > chars.length )
				stop();
						
			cursor += waveSpeed * biasInSecond;
		}

		protected function changeChar ( c : Char, i : Number ) : void
		{
			if( c.charContent )
				c.charContent.y = Math.cos( i * Math.PI ) * waveAmplitude;
		}

		protected function getRatio ( i : Number ) : Number
		{
			return 1 - Math.abs( ( i - cursor ) / waveLength );
		}
	}
}
