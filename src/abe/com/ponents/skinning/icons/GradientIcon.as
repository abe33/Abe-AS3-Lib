package abe.com.ponents.skinning.icons 
{
	import abe.com.mon.colors.Gradient;
	import abe.com.ponents.utils.Insets;

	import flash.display.GradientType;
	import flash.geom.Matrix;

	/**
	 * @author Cédric Néhémie
	 */
	public class GradientIcon extends ColorIcon 
	{
		protected var _gradient : Gradient;
		public function GradientIcon (gradient : Gradient = null)
		{
			super( null );
			_contentType = "Gradient";
			_gradient = gradient;
			invalidatePreferredSizeCache();
		}

		override public function clone () : *
		{
			return new GradientIcon( _gradient );
		}

		override protected function drawColor () : void
		{
			if( _gradient )
			{
				var insets : Insets = _style.insets;
				var m : Matrix = new Matrix();
				m.createGradientBox(width-insets.horizontal, height-insets.vertical,0,insets.left, insets.top);
				
				//_childrenContainer.graphics.beginFill( _color.hexa, _color.alpha/255 );
				_childrenContainer.graphics.beginGradientFill(GradientType.LINEAR, 
															  _gradient.toGradientFillColorsArray(), 
															  _gradient.toGradientFillAlphasArray(), 
															  _gradient.toGradientFillPositionsArray(),
															  m );	
				_childrenContainer.graphics.drawRect( insets.left, insets.top, width-insets.horizontal, height-insets.vertical );
				_childrenContainer.graphics.endFill( );
			}
		}
		
		public function get gradient () : Gradient { return _gradient; }
		public function set gradient (gradient : Gradient) : void
		{
			_gradient = gradient;
			invalidate();
		}
	}
}
