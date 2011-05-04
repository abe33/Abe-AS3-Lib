package abe.com.ponents.progress 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.ponents.models.BoundedRangeModel;

	import flash.geom.ColorTransform;
	/**
	 * @author cedric
	 */
	public class GradientProgressBar extends ProgressBar 
	{
		protected var _gradient : Gradient;
		
		public function GradientProgressBar ( model : BoundedRangeModel = null, 
											  gradient : Gradient = null,
											  displayLabel : Boolean = true)
		{
			_gradient = gradient ? gradient : new Gradient( [Color.Red, Color.Yellow, Color.YellowGreen ], [.1,.5,.9] );
			super( model, displayLabel );
		}
		override public function repaint () : void 
		{
			super.repaint();
			var c : ColorTransform = _gradient.getColor( _model.value / 100 ).toColorTransform( 1 );
			_bar.transform.colorTransform = c;
		}
	}
}
