package abe.com.ponents.skinning.decorations 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.colors.Gradient;
    import abe.com.mon.utils.MathUtils;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.utils.Borders;
    import abe.com.ponents.utils.Corners;

    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class ArrowSideGradientBorders extends ArrowSideBorders 
	{
		public var gradientRotation : Number;
		public var gradient : Gradient;
		
		public function ArrowSideGradientBorders (	gradient : Gradient = null,
								       	  			gradientRotation : Number = 0, 
								       	  			arrowPlacement : String = "north", 
								       	  			arrowSize : Number = 5 )
		{
			super( null, arrowPlacement, arrowSize );
			this.gradient = gradient ? gradient : new Gradient([Color.Black, Color.White],[0,1]);
			this.gradientRotation = gradientRotation;
		}
		override public function clone () : *
		{
			return new ArrowSideGradientBorders( gradient.clone(), gradientRotation, arrowPlacement, arrowSize );
		}
		override public function equals (o : *) : Boolean
		{
			if( o is ArrowSideGradientBorders )
			{
				var g : ArrowSideGradientBorders = o as ArrowSideGradientBorders;
				return 	g.gradient.equals( gradient ) && 
						g.gradientRotation == gradientRotation && 
						g.arrowPlacement == arrowPlacement &&
					   	g.arrowSize == arrowSize;
			}
			return false;
		}
		
		override public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			corners = corners ? corners : new Corners();
			var m : Matrix = new Matrix();
			m.createGradientBox( r.width, r.height, MathUtils.deg2rad(gradientRotation), r.x, r.y );
			
			g.beginGradientFill( GradientType.LINEAR, 
								gradient.toGradientFillColorsArray(), 
								gradient.toGradientFillAlphasArray( ), 
								gradient.toGradientFillPositionsArray(), 
								m );
			
			drawArrow ( r, g, corners, borders );
			
			//g.drawRoundRectComplex(r.x, r.y, r.width, r.height, corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight );
			g.endFill();
		}
	}
}
