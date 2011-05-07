package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	/**
	 * @author cedric
	 */
	public class BubbleFill extends BubbleBorders 
	{
		public function BubbleFill (color : Color, tailPlacement : String = "north", tailSize : Number = 15, tailWidth : Number = 5, tailPosition : Number = 0.25, tailOrientation : Number = -2)
		{
			super( color, tailPlacement, tailSize, tailWidth, tailPosition, tailOrientation );
		}
		override public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void 
		{
			corners = corners ? corners : new Corners();			
			var points : Array = getTriplets(r, borders, corners);
			drawOutter(points[0], points[1], points[2], r, g, borders, corners);
			g.endFill();		
		}
	}
}
