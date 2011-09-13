package abe.com.ponents.progress 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.colors.Gradient;
	/**
	 * @author Cédric Néhémie
	 */
	public class MinimalGradientProgressBar extends MinimalProgressBar 
	{
		protected var _gradient : Gradient;

		public function MinimalGradientProgressBar (value : Number = 0, gradient : Gradient = null )
		{
			_gradient = gradient ? gradient : new Gradient([Color.Red, Color.Yellow, Color.YellowGreen ], [.1,.5,.9] );
			super( value, null );
		}
		
		public function get gradient () : Gradient { return _gradient; }		
		public function set gradient (gradient : Gradient) : void
		{
			_gradient = gradient;
			invalidate();
		}

		override protected function updateBar () : void 
		{
			_barColor = _gradient.getColor( _value / 100 );
			super.updateBar();
		}
	}
}
