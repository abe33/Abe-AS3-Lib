package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.geom.Surface;

	[Serialize(constructorArgs="surface")]
    public class OutOfSurfaceDeathActionStrategy extends AbstractActionStrategy
	{
		protected var _surface : Surface;

        public function OutOfSurfaceDeathActionStrategy ( surface : Surface )
		{
			_surface = surface;
		}
        public function get surface () : Surface { return _surface; }
        public function set surface ( surface : Surface ) : void { _surface = surface; }
		
		override public function process( particle : Particle ) : void
		{
			if( !_surface.containsPoint( particle.position ) )
			{
				particle.life = particle.maxLife;
            }
        }
	}
}