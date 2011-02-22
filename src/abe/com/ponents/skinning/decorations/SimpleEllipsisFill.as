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
	public class SimpleEllipsisFill extends SimpleFill 
	{
		public function SimpleEllipsisFill (color : Color = null)
		{
			super( color );
		}

		override public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null,corners : Corners = null, smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			g.beginFill( color.hexa, color.alpha/255 );
			g.drawEllipse(r.x, r.y, r.width, r.height );
			g.endFill( );
		}
		override public function clone () : *
		{
			return new SimpleEllipsisFill(color);
		}
		override public function equals (o : *) : Boolean
		{
			if( o is SimpleEllipsisFill )
				return ( o as SimpleEllipsisFill ).color.equals( color );
				
			return false;
		}
	}
}
