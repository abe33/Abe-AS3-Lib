package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.utils.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	/**
	 * @author cedric
	 */
	public class SimpleEllipsisBorders extends SimpleBorders 
	{
		public function SimpleEllipsisBorders (color : Color) 
		{
			super(color);
		}
		override public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null,corners : Corners = null, smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			g.lineStyle( borders.top, color.hexa, color.alpha/255 );
			g.drawEllipse(r.x, r.y, r.width, r.height );
		}
		override public function clone () : *
		{
			return new SimpleEllipsisBorders(color);
		}
		override public function equals (o : *) : Boolean
		{
			if( o is SimpleEllipsisBorders )
				return ( o as SimpleEllipsisBorders ).color.equals( color );
				
			return false;
		}
	}
}
