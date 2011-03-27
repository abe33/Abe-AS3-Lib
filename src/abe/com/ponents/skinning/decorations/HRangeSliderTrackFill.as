package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.geom.Range;
	import abe.com.mon.colors.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.sliders.HRangeSlider;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class HRangeSliderTrackFill implements ComponentDecoration 
	{
		protected var _backgroundColor : Color;
		protected var _borderColor : Color;		protected var _rangeColor : Color;
		protected var _trackOffset : Number;
		protected var _trackHeight : Number;
		
		public function HRangeSliderTrackFill ( backgroundColor : Color = null, 
												borderColor : Color = null, 
												rangeColor : Color = null,
												trackHeight : Number = 4, 
												trackOffset : Number = 0 )
		{
			_backgroundColor = backgroundColor ? backgroundColor : Color.White;
			_borderColor = borderColor ? borderColor : Color.Black;			_rangeColor = rangeColor ? rangeColor : Color.Blue;
			_trackOffset = trackOffset;
			_trackHeight = trackHeight;
		}
		public function clone () : *
		{
			return new HRangeSliderTrackFill(_backgroundColor, _borderColor, _rangeColor, _trackHeight, _trackOffset);
		}
		public function draw ( r : Rectangle, 
							   g : Graphics, 
							   c : Component, 
							   borders : Borders = null, 
							   cornerRadius : Corners = null, 
							   smoothing : Boolean = false) : void
		{
			//g.lineStyle();
			g.beginFill( 0, 0 );
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
			
			cornerRadius = cornerRadius ? cornerRadius : new Corners();
			//g.lineStyle( 0,_borderColor.hexa, _borderColor.alpha / 255 );
			
			var x : Number = r.x + _trackOffset;			var y : Number = r.y + ( ( r.height - _trackHeight ) / 2 );			var w : Number = r.width - _trackOffset * 2;			var h : Number = _trackHeight;
			
			g.beginFill( _borderColor.hexa, _borderColor.alpha / 255 );
			g.drawRoundRectComplex( x, 
									y, 
									w, 
									h, 
									cornerRadius.topLeft, 
									cornerRadius.topRight, 
									cornerRadius.bottomLeft, 
									cornerRadius.bottomRight );
			
			x += borders.left;
			y += borders.top;
			w -= borders.horizontal;			h -= borders.vertical;
			
			g.beginFill( _backgroundColor.hexa, _backgroundColor.alpha / 255 );
			g.drawRoundRectComplex( x, 
									y, 
									w, 
									h, 
									cornerRadius.topLeft-1, 
									cornerRadius.topRight-1, 
									cornerRadius.bottomLeft-1, 
									cornerRadius.bottomRight-1 );
			g.endFill();
			
			if( c )
			{
				var m : BoundedRangeModel = (c.parentContainer as HRangeSlider ).model;
				if( m )
				{
					var ra : Range = new Range( m.value, m.value + m.extent ); 
					var minRatio : Number = ra.min / m.maximum;
					var maxRatio : Number = ra.max / m.maximum;
					
					var wmin : Number = w * minRatio;					var wmax : Number = w * maxRatio;
					
					x += wmin; 
					w = wmax - wmin;
					
					g.beginFill( _rangeColor.hexa, _rangeColor.alpha / 255 );
					g.drawRect( x, 
								y, 
								w, 
								h );
					g.endFill();
				}
			}
		}

		public function get trackOffset () : Number { return _trackOffset; }		
		public function set trackOffset (trackOffset : Number) : void
		{
			_trackOffset = trackOffset;
		}
		public function get backgroundColor () : Color { return _backgroundColor; }		
		public function set backgroundColor (backgroundColor : Color) : void
		{
			_backgroundColor = backgroundColor;
		}
		
		public function get borderColor () : Color { return _borderColor; }
		public function set borderColor (borderColor : Color) : void
		{
			_borderColor = borderColor;
		}
		
		public function get trackHeight () : Number { return _trackHeight; }		
		public function set trackHeight (trackHeight : Number) : void
		{
			_trackHeight = trackHeight;
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is HRangeSliderTrackFill )
			{
				var hs : HRangeSliderTrackFill = o as HRangeSliderTrackFill;
				return 	hs.trackOffset == trackOffset && 
						hs.trackHeight == trackHeight &&
						hs.backgroundColor == backgroundColor &&
						hs.borderColor == borderColor;
			}
			return false;
		}
		public function toSource () : String 
		{
			return toReflectionSource().replace("::", ".");
		}
		public function toReflectionSource () : String 
		{
			return "new "+ getQualifiedClassName(this) + "(color(0x" + backgroundColor.rgba+ 
															  "), color(0x" + borderColor.rgba + 
															  "), " + trackHeight + 
															  ", " + trackOffset + ")";
		}
		
	}
}
