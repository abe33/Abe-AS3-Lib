package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;

	[Serialize(constructorArgs="blendSpeed")]
    public class AlphaBlendActionStrategy extends AbstractActionStrategy
	{
		protected var _blendSpeed : Number;

        public function AlphaBlendActionStrategy ( blendSpeed : Number = 0 )
		{
			_blendSpeed = blendSpeed;
		}
		
		override public function process( particle : Particle ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
            p.alpha -= _blendSpeed * _nTimeStep;
        }

        public function get blendSpeed () : Number {
            return _blendSpeed;
        }

        public function set blendSpeed ( blendSpeed : Number ) : void {
            _blendSpeed = blendSpeed;
        }
        
	}
}