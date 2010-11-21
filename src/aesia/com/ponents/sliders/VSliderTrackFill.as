package aesia.com.ponents.sliders 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.skinning.decorations.ComponentDecoration;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class VSliderTrackFill implements ComponentDecoration 
	{
		protected var _backgroundColor : Color;
		protected var _borderColor : Color;
		protected var _trackOffset : Number;
		protected var _trackWidth : Number;
		
		public function VSliderTrackFill ( backgroundColor : Color, borderColor : Color, trackWidth : Number = 4, trackOffset : Number = 0 )
		{
			_backgroundColor = backgroundColor;
			_borderColor = borderColor;
			_trackOffset = trackOffset;
			_trackWidth = trackWidth;
		}

		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, cornerRadius : Corners = null, smoothing : Boolean = false) : void
		{
			//g.lineStyle();
			g.beginFill( 0, 0 );
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
			
			cornerRadius = cornerRadius ? cornerRadius : new Corners();
			//g.lineStyle( 0,_borderColor.hexa, _borderColor.alpha / 255 );
			//g.beginFill( _backgroundColor.hexa, _backgroundColor.alpha / 255 );			g.beginFill( _borderColor.hexa, _borderColor.alpha / 255 );			g.drawRoundRectComplex( r.x + ( ( r.width - _trackWidth ) / 2 ), 
									r.y + _trackOffset , 
									_trackWidth, 
									r.height - _trackOffset * 2, 
									cornerRadius.topLeft, 
									cornerRadius.topRight, 
									cornerRadius.bottomLeft, 
									cornerRadius.bottomRight );
			
			g.beginFill( _backgroundColor.hexa, _backgroundColor.alpha / 255 );
			g.drawRoundRectComplex ( r.x + ( ( r.width - _trackWidth ) / 2 + borders.left ), 
									 r.y + _trackOffset + borders.top, 
									 _trackWidth - borders.left - borders.right, 
									r.height - _trackOffset * 2 - borders.top - borders.bottom, 
									cornerRadius.topLeft-1, 
									cornerRadius.topRight-1, 
									cornerRadius.bottomLeft-1, 
									cornerRadius.bottomRight-1 );
			g.endFill();

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
		public function set trackWidth (trackHeight : Number) : void
		{
			_trackWidth = trackWidth;
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is VSliderTrackFill )
			{
				var hs : VSliderTrackFill = o as VSliderTrackFill;
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
