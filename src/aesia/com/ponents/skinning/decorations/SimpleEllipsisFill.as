package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

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
		
		override public function equals (o : *) : Boolean
		{
			if( o is SimpleEllipsisFill )
				return ( o as SimpleEllipsisFill ).color.equals( color );
				
			return false;
		}
	}
}
