package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="forceRadius, forceStrength, forceDecay")]
    public class ParticleForceActionStrategy extends PonctualForceActionStrategy
    {
        public function ParticleForceActionStrategy ( forceRadius : Number = 100, 
                                                      forceStrength : Number = 10,
                                                      forceDecay : Function = null )
        {
            super( null, forceRadius, forceStrength, forceDecay );
        }
        
        override public function process ( particle : Particle ) : void
        {
            for each( var p : Particle in _system.particles )
                processForce(particle, p.position, _forceRadius, _forceStrength, _forceDecay );
        }
    }
}
