package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

    /**
     * @author cedric
     */
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
            	particle.velocity.normalize( _maxSpeed );
        }

        override protected function getSourceArguments () : String
        {
            return String( _maxSpeed );
        }
        override protected function getReflectionSourceArguments () : String
        {
            return String( _maxSpeed );
        }
    }
}
