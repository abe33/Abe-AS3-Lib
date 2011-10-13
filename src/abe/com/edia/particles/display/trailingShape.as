package abe.com.edia.particles.display
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.display.objects.TrailingShape;
    import abe.com.mon.colors.Color;
    /**
     * @author cedric
     */
    public function trailingShape ( trailColor : Color = null,
        							trailThickness : Number = 2, 
                                    trailLength : Number = 10 ) : Function
    {
        return function ( p : Particle ) : TrailingShape 
        {
            return new TrailingShape(p, trailColor, trailThickness, trailLength);
        };
    }
}