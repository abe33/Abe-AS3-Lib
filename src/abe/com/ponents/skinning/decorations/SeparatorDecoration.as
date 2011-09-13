package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;
	import abe.com.ponents.utils.Orientations;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="colorLight,colorShadow,orientation,bevelSize,padding")]
	public class SeparatorDecoration extends EmptyFill implements ComponentDecoration 
	{
		public var colorLight : Color;
		public var colorShadow : Color;
		public var orientation : uint;
		public var bevelSize : Number;
		public var padding : Number;

		public function SeparatorDecoration ( colorLight : Color = null, 
										 	  colorShadow : Color = null, 
										 	  orientation : uint = 0, 
										 	  bevelSize : Number = 1, 
										 	  padding : Number = 4 )
		{
			this.colorLight = colorLight ? colorLight : Color.White;
			this.colorShadow = colorShadow ? colorShadow : Color.Black;
			this.orientation = orientation;
			this.bevelSize = bevelSize;
			this.padding = padding;
		}
		override public function clone () : *
		{
			return new SeparatorDecoration(colorLight, colorShadow, orientation, bevelSize, padding);
		}

		override public function equals (o : *) : Boolean 
		{
			if( o is SeparatorDecoration )
			{
				var d : SeparatorDecoration = o as SeparatorDecoration;
				return d.orientation == orientation && 
						d.colorLight.equals( colorLight ) &&
						d.colorShadow.equals( colorShadow ) && 
						d.bevelSize == bevelSize && 
						d.padding == padding;
			}
			return false;
		}

		override public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			super.draw( r, g, c, borders, corners, smoothing );
			switch( orientation )
			{
				case Orientations.HORIZONTAL : 
					g.beginFill( colorShadow.hexa, colorShadow.alpha/255 );
					g.drawRect(padding, Math.floor(r.height / 2 - bevelSize), r.width - padding * 2, bevelSize );
					g.endFill();
					
					g.beginFill( colorLight.hexa, colorLight.alpha/255 );					g.drawRect(padding, Math.floor(r.height / 2), r.width - padding * 2, bevelSize );
					g.endFill();
					break;
				case Orientations.VERTICAL : 
				default :
					g.beginFill( colorShadow.hexa, colorShadow.alpha/255 );
					g.drawRect( Math.floor(r.width / 2 )-  bevelSize, padding, bevelSize, r.height - padding * 2 );
					g.endFill();
					
					g.beginFill( colorLight.hexa, colorLight.alpha/255 );					g.drawRect( Math.floor( r.width / 2 ), padding, bevelSize, r.height - padding * 2 );
					g.endFill();
			}
		}
	}
}
