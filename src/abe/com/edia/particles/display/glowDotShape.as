package abe.com.edia.particles.display
{
    import abe.com.mon.colors.Color;

    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.geom.Matrix;
    /**
     * @author cedric
     */
    public function glowDotShape ( radius1 : Number = 1, 
    							   radius2 : Number = 3,
                                   blurred : Boolean = false,
    							   color1 : Color = null,
    							   color2 : Color = null
                                  ) : Function
    {
        color1 = color1 ? color1 : Color.White;
        color2 = color2 ? color2 : color1.alphaClone(0x88);
        
        if( blurred )
            return function():Shape
            {
                var s : Shape = new Shape(); 
                var m1 : Matrix = new Matrix();
                var m2 : Matrix = new Matrix();
                var d1 : Number = radius1 * 2;
                var d2 : Number = radius2 * 2;
                
                m1.createGradientBox( d1, d1, 0, -radius1, -radius1 );
                m2.createGradientBox( d2, d2, 0, -radius2, -radius2 );
                
                s.graphics.beginGradientFill(GradientType.RADIAL, [color2.hexa, color2.hexa], [color2.alpha/255,0], [0,255], m2 );
                s.graphics.drawCircle(0, 0, radius2);
                s.graphics.endFill();
                
                s.graphics.beginGradientFill(GradientType.RADIAL, [color1.hexa, color1.hexa], [color1.alpha/255,0], [0,255], m1 );
                s.graphics.drawCircle(0, 0, radius1);
                s.graphics.endFill();
                
                return s;
            };
		else
        	return function():Shape
            {
                var s : Shape = new Shape(); 
                
                s.graphics.beginFill(color2.hexa, color2.alpha/255 );
                s.graphics.drawCircle(0, 0, radius2);
                s.graphics.endFill();
                
                s.graphics.beginFill( color1.hexa, color1.alpha/255 );
                s.graphics.drawCircle(0, 0, radius1);
                s.graphics.endFill();
                
                return s;
            };
    }
}
