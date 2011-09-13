package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.geom.Surface;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="surface")]
    public class ContactWithSurfaceDeathActionStrategy extends AbstractActionStrategy
    {
        protected var _surface : Surface;
        
        public function ContactWithSurfaceDeathActionStrategy ( surface : Surface = null )
        {
            _surface = surface;
        }

        override public function process ( particle : Particle ) : void
        {
            if( particle.hasParasite("contactSurface") )
            {
                if( ( particle.getParasite("contactSurface") as Surface).containsPoint( particle.position ) )
                	particle.die();
            }
            else if( _surface && _surface.containsPoint( particle.position ) )
                particle.die ();
        }

        public function get surface () : Surface {
            return _surface;
        }

        public function set surface ( surface : Surface ) : void {
            _surface = surface;
        }
    }
}
