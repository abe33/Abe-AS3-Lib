package abe.com.ponents.progress 
{
	import abe.com.mon.geom.dm;
	import abe.com.mon.utils.Color;
	import abe.com.ponents.core.SimpleDOContainer;
	import abe.com.ponents.layouts.display.DONoLayout;

	import flash.display.Shape;

	[Skinable(skin="MinimalProgress")]
	[Skin(define="MinimalProgress",
			  inherit="DefaultComponent",
			  state__all__background="skin.emptyDecoration"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class MinimalProgressBar extends SimpleDOContainer 
	{
		protected var _value : Number;
		protected var _bar : Shape;
		protected var _barColor : Color;

		public function MinimalProgressBar ( value : Number = 0, barColor : Color = null )
		{
			_childrenLayout = new DONoLayout( _childrenContainer );
			super( );
			_allowFocus = false;
			_allowOver = false;
			_allowPressed = false;
			_bar = new Shape();
			addComponentChild(_bar);
			_barColor = barColor ? barColor : Color.Red;
			invalidatePreferredSizeCache();
			this.value = value;
		}
		public function get value () : Number { return _value; }		
		public function set value (value : Number) : void
		{
			_value = value;
			invalidate(true);
		}
		public function get barColor () : Color { return _barColor; }		
		public function set barColor (barColor : Color) : void
		{
			_barColor = barColor;
			invalidate(true);
		}

		override public function invalidatePreferredSizeCache () : void 
		{
			_preferredSizeCache = dm(30, 6);
			invalidate();
		}

		override public function repaint () : void 
		{
			super.repaint();
			updateBar();
		}

		protected function updateBar () : void 
		{
			_bar.graphics.clear();
			_bar.graphics.beginFill( _barColor.hexa, _barColor.alpha );
			_bar.graphics.drawRect( 0, 0, _value/100 * width, height );
			_bar.graphics.endFill();
		}
	}
}
