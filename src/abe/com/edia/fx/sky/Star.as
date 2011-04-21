package abe.com.edia.fx.sky 
{
	import abe.com.mon.colors.Color;

	import flash.display.Shape;
	import flash.filters.GlowFilter;
	/**
	 * @author Cédric Néhémie
	 */
	public class Star extends Shape 
	{
		public function Star ( color : Color, size : Number, lensFlare : Boolean = true, glow : Boolean = true )
		{
			if( lensFlare )
			{
				graphics.beginFill( Color.White.hexa, .5 );
				graphics.drawEllipse(-size/2, -size*5, size, size*10);
				graphics.endFill();
				
				graphics.beginFill( Color.White.hexa, .5 );
				graphics.drawEllipse(-size*5, -size/2, size*10, size );				graphics.endFill();
			}
			if ( glow )
			{
				filters = [ new GlowFilter( color.hexa ) ];
			}

			graphics.beginFill( Color.White.hexa );
			graphics.drawCircle( 0, 0, size );
			graphics.endFill();
		}
	}
}
