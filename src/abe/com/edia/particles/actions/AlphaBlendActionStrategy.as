package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;

    public class AlphaBlendActionStrategy extends AbstractActionStrategy
	{
		protected var _nBlendSpeed : Number;

        public function AlphaBlendActionStrategy ( blendSpeed : Number = 0 )
		{
			_nBlendSpeed = blendSpeed;
		}
		
		override public function process( particle : Particle ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
			p.alpha -= _nBlendSpeed * _nTimeStep;
		}
        
        
        override protected function getSourceArguments () : String
        {
            return String( _nBlendSpeed );
        }

        override protected function getReflectionSourceArguments () : String
        {
            return String( _nBlendSpeed );
        }
	}
}