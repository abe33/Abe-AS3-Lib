package abe.com.edia.particles.display
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.colors.Color;
    import abe.com.mon.colors.Gradient;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

    import flash.display.Shape;
    /**
     * @author cedric
     */
    public function discShapeFromGradient ( gradient : Gradient, radius : Number = 1, random : Random = null ) : Function
    {
        random = random ? random : RandomUtils;
        return function(p:Particle):Shape
        {
	        var color : Color = gradient.getColor( random.random() );
            var s : Shape =  new Shape();
            s.graphics.beginFill(color.hexa, color.alpha/255);
            s.graphics.drawCircle(0, 0, radius );
            s.graphics.endFill();
            return s;
        };
    }
}
