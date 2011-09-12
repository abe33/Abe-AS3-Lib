package abe.com.edia.particles.display
{
	import abe.com.edia.particles.core.Particle;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.RandomUtils;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
    /**
     * @author cedric
     */
    public function blurryDotFromGradient ( gradient : Gradient, 
    										sizeMin : Number = 1, 
                                            sizeMax : Number = 4, 
                                            blurMin : Number = 1, 
                                            blurMax : Number = 8, 
                                            alphaMin : Number = .5,
                                            alphaMax : Number = 1,
                                            random : Random = null ) : Function
    {
        return function( p : Particle ) : Shape 
        {
            random = random ? random : RandomUtils;	
            
            var s : Shape =  new Shape();
            var c : Color = gradient.getColor( random.random() );
            var b : Number = random.rangeAB(blurMin, blurMax);
            var r : Number = random.rangeAB(sizeMin, sizeMax) + b/2;
            var a : Number = random.rangeAB(alphaMin, alphaMax);
            var pr : Number = 255 * ( ( r-b )/r );
            var m : Matrix = new Matrix();
            
            m.createGradientBox(r*2, r*2, 0, -r, -r);
            s.graphics.beginGradientFill("radial", [c.hexa,c.hexa], [a,0], [pr,255], m );
            s.graphics.drawCircle(0, 0, r );
            s.graphics.endFill();
            s.blendMode = "add";
            return s;
        };
    }
}
