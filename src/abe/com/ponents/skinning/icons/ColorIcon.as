package abe.com.ponents.skinning.icons 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.utils.Insets;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	[Skinable(skin="ColorIcon")]
	[Skin(define="ColorIcon",
			  inherit="EmptyComponent",
			  custom_checkerColor1="color(0xffffffff)",			  custom_checkerColor2="color(0xcccccccc)",
			  state__all__foreground="new abe.com.ponents.skinning.decorations::SimpleBorders(color(DimGray))"
	)]
	public class ColorIcon extends Icon
	{
		static protected var _checkerBitmapData : BitmapData;
		
		static public const _checkerSize : int = 4;
		
		protected var _color : Color;
		protected var _checkerColor1 : Color;
		protected var _checkerColor2 : Color;

		public function ColorIcon ( color : Color )
		{
			super();
			_contentType = "Color";
			_allowFocus = false;
			_allowFocusTraversing = false;
			_color = color;
			_checkerColor1 = _style.checkerColor1;			_checkerColor2 = _style.checkerColor2;
			
			if( !_checkerBitmapData )
			{
				_checkerBitmapData = new BitmapData(_checkerSize*2, _checkerSize*2, false, 0xffffffff);
				drawBitmapData();
			}
			
			invalidatePreferredSizeCache();
		}
		
		[Form(label="Color", type="color", order="0")]
		public function get color () : Color { return _color; }		
		public function set color (color : Color) : void
		{
			_color = color;
			invalidate();
		}

		override public function init () : void
		{
			super.init();
			repaint();
		}

		override public function clone () : *
		{
			return new ColorIcon( _color );
		}

		protected function drawBitmapData () : void
		{
			_checkerBitmapData.fillRect(new Rectangle(0,0,_checkerSize,_checkerSize), _checkerColor1.hexa );			_checkerBitmapData.fillRect(new Rectangle(_checkerSize,_checkerSize,_checkerSize,_checkerSize), _checkerColor1.hexa );			_checkerBitmapData.fillRect(new Rectangle(0,_checkerSize,_checkerSize,_checkerSize), _checkerColor2.hexa );			_checkerBitmapData.fillRect(new Rectangle(_checkerSize,0,_checkerSize,_checkerSize), _checkerColor2.hexa );
			
		}
		override protected function _repaint (size : Dimension, forceClear : Boolean = true ) : void
		{
			super._repaint( size, forceClear );
			
			drawChecker();
			drawColor();
		}
		protected function drawColor () : void
		{
			if( _color )
			{
				var insets : Insets = _style.insets;
				
				_childrenContainer.graphics.beginFill( _color.hexa, _color.alpha/255 );
				_childrenContainer.graphics.drawRect( insets.left, insets.top, width-insets.horizontal, height-insets.vertical );
				_childrenContainer.graphics.endFill();
			}
		}
		protected function drawChecker () : void
		{
			_childrenContainer.graphics.clear();
				
			if( _checkerBitmapData )
			{
				var insets : Insets = _style.insets;			
				var m : Matrix = new Matrix();
				m.createBox( 1, 1, 0, 0, 0 );
				
				_childrenContainer.graphics.beginBitmapFill( _checkerBitmapData, m, true );
				_childrenContainer.graphics.drawRect( insets.left, insets.top, width-insets.horizontal, height-insets.vertical );
				_childrenContainer.graphics.endFill();
			}
		}
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = new Dimension(16,16);
			invalidate( false );
		}
		override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "checkerColor1" : 
					_checkerColor1 = propertyValue;
					dispose();
					init();
					break;
				case "checkerColor2" : 
					_checkerColor2 = propertyValue;
					dispose();
					init();
					break;
				default : 
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}
	}
}
