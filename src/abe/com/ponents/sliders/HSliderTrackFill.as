package abe.com.ponents.sliders 
{
	import abe.com.mon.utils.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.skinning.decorations.ComponentDecoration;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class HSliderTrackFill implements ComponentDecoration 
	{
		protected var _backgroundColor : Color;		protected var _borderColor : Color;
		protected var _trackOffset : Number;		protected var _trackHeight : Number;
		
		public function HSliderTrackFill ( backgroundColor : Color = null, borderColor : Color = null, trackHeight : Number = 4, trackOffset : Number = 0 )
		{
			_backgroundColor = backgroundColor ? backgroundColor : Color.White;			_borderColor = borderColor ? borderColor : Color.Black;
			_trackOffset = trackOffset;
			_trackHeight = trackHeight;
		}
		public function clone () : *
		{
			return new HSliderTrackFill(_backgroundColor, _borderColor, _trackHeight, _trackOffset);
		}
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, cornerRadius : Corners = null, smoothing : Boolean = false) : void
		{
			//g.lineStyle();
			g.beginFill( 0, 0 );
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
			
			cornerRadius = cornerRadius ? cornerRadius : new Corners();
			//g.lineStyle( 0,_borderColor.hexa, _borderColor.alpha / 255 );
			
			g.beginFill( _borderColor.hexa, _borderColor.alpha / 255 );
			g.drawRoundRectComplex( r.x + _trackOffset, 
									r.y + ( ( r.height - _trackHeight ) / 2 ), 
									r.width - _trackOffset * 2, 
									_trackHeight, 
									cornerRadius.topLeft, 
									cornerRadius.topRight, 
									cornerRadius.bottomLeft, 
									cornerRadius.bottomRight );
			
			g.beginFill( _backgroundColor.hexa, _backgroundColor.alpha / 255 );
			g.drawRoundRectComplex( r.x + _trackOffset + borders.left, 
									r.y + ( ( r.height - _trackHeight ) / 2 ) + borders.top, 
									r.width - _trackOffset * 2 - borders.left - borders.right, 
									_trackHeight - borders.top - borders.bottom, 
									cornerRadius.topLeft-1, 
									cornerRadius.topRight-1, 
									cornerRadius.bottomLeft-1, 
									cornerRadius.bottomRight-1 );			g.endFill();

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
			if( o is HSliderTrackFill )
			{
				var hs : HSliderTrackFill = o as HSliderTrackFill;
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
