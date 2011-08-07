package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.geom.Surface;

    /**
     * @author cedric
     */
    public class ContactWithSurfaceDeathAction extends AbstractActionStrategy
    {
        protected var _surface : Surface;
        
        public function ContactWithSurfaceDeathAction ( surface : Surface )
        {
            _surface = surface;
        }

        override public function process ( particle : Particle ) : void
        {
            if( _surface.containsPoint( particle.position ) )
            	particle.die();
        }
    }
}
