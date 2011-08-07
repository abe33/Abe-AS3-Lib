package abe.com.edia.particles.display
{
    import abe.com.mon.colors.Color;

    import flash.display.Shape;
    /**
     * @author cedric
     */
    public function squareShape ( width : Number = 1, height : Number = 1, color : Color = null ) : Function
    {
        color = color ? color : Color.White;
        return function():Shape
        {
            var s : Shape =  new Shape();
                s.graphics.beginFill(color.hexa, color.alpha/255);
	            s.graphics.drawRect( -width/2 , -height/2, width, height );
                s.graphics.endFill();
                return s;
        };
    }
}
