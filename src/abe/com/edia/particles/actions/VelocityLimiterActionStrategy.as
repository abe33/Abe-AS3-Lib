package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="maxSpeed")]
    public class VelocityLimiterActionStrategy extends AbstractActionStrategy
    {
        protected var _maxSpeed : Number;
        
        public function VelocityLimiterActionStrategy ( maxSpeed : Number )
        {
            _maxSpeed = maxSpeed;
        }
        
        override public function process ( particle : Particle ) : void
        {
            if( particle.velocity.length > _maxSpeed )
                particle.velocity.normalize ( _maxSpeed );
        }

        public function get maxSpeed () : Number {
            return _maxSpeed;
        }

        public function set maxSpeed ( maxSpeed : Number ) : void {
            _maxSpeed = maxSpeed;
        }

    }
}
