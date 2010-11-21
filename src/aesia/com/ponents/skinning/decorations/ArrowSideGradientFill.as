package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Gradient;
	import aesia.com.mon.utils.MathUtils;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class ArrowSideGradientFill extends ArrowSideFill
	{
		public var gradientRotation : Number;
		public var gradient : Gradient;
		
		public function ArrowSideGradientFill (	gradient : Gradient = null,
							       	  			gradientRotation : Number = 0, 
							       	  			arrowPlacement : String = "north", 
							       	  			arrowSize : Number = 5 )
		{
			super( null, arrowPlacement, arrowSize );
			this.gradient = gradient ? gradient : new Gradient([Color.Black, Color.White],[0,1]);
			this.gradientRotation = gradientRotation;
		}
		
		override public function equals (o : *) : Boolean
		{
			if( o is ArrowSideGradientFill )
			{
				var g : ArrowSideGradientFill = o as ArrowSideGradientFill;
				return 	g.gradient.equals( gradient ) && 
						g.gradientRotation == gradientRotation && 
						g.arrowPlacement == arrowPlacement &&
					   	g.arrowSize == arrowSize;
			}
			return false;
		}
		override public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "(" + gradient.toReflectionSource() + "," + gradientRotation + ", '" + arrowPlacement + "', " + arrowSize + ")" ;
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
