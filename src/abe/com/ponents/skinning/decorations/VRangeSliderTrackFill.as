package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Range;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.sliders.VRangeSlider;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class VRangeSliderTrackFill implements ComponentDecoration 
	{
		protected var _backgroundColor : Color;
		protected var _borderColor : Color;
		protected var _rangeColor : Color;
		protected var _trackOffset : Number;
		protected var _trackWidth : Number;
		
		public function VRangeSliderTrackFill ( backgroundColor : Color = null, 
												borderColor : Color = null, 
												rangeColor : Color = null,
												trackWidth : Number = 4, 
												trackOffset : Number = 0 )
		{
			_backgroundColor = backgroundColor ? backgroundColor : Color.White;
			_borderColor = borderColor ? borderColor : Color.Black;
			_rangeColor = rangeColor ? rangeColor : Color.Blue;
			_trackOffset = trackOffset;
			_trackWidth = trackWidth;
		}
		public function clone () : *
		{
			return new VRangeSliderTrackFill(_backgroundColor, _borderColor, _rangeColor, _trackWidth, _trackOffset);
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
			
			var x : Number = r.x + ( ( r.width - _trackWidth ) / 2 );
			var y : Number = r.y + _trackOffset;
			var w : Number = _trackWidth;
			var h : Number = r.height - _trackOffset * 2;
			
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
			w -= borders.horizontal;
			h -= borders.vertical;
			
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
				var m : BoundedRangeModel = (c.parentContainer as VRangeSlider ).model;
				if( m )
				{
					var ra : Range = new Range( m.value, m.value + m.extent ); 
					var minRatio : Number = ra.min / m.maximum;
					var maxRatio : Number = ra.max / m.maximum;
					
					var hmin : Number = h * minRatio;
					var hmax : Number = h * maxRatio;
					var sh : Number = h;
					
					h = hmax - hmin;
					y = sh - h - hmin; 
					
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
		
		public function get trackWidth () : Number { return _trackWidth; }		
		public function set trackWidth (trackWidth : Number) : void
		{
			_trackWidth = trackWidth;
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is VRangeSliderTrackFill )
			{
				var hs : VRangeSliderTrackFill = o as VRangeSliderTrackFill;
				return 	hs.trackOffset == trackOffset && 
						hs.trackWidth == trackWidth &&
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
															  "), " + trackWidth + 
															  ", " + trackOffset + ")";
		}
		
	}
}
