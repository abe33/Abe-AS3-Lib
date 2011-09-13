package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

    import flash.utils.Dictionary;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="minRotationSpeed, maxRotationSpeed, perParticle, randomSource")]
    public class RotateActionStrategy extends AbstractActionStrategy implements Randomizable
    {
        protected var _minRotationSpeed : Number;
        protected var _maxRotationSpeed : Number;
        protected var _perParticle : Boolean;
        protected var _allParticlesRotationSpeed : Number;
        protected var _randomSource : Random;
        
        protected var _particlesRotationSpeeds : Dictionary;
        
        public function RotateActionStrategy ( minRotationSpeed : Number = -3, 
        									   maxRotationSpeed : Number = 3, 
                                               perParticle : Boolean = true,
                                               random : Random = null )
        {
            _minRotationSpeed = minRotationSpeed;
            _maxRotationSpeed = maxRotationSpeed;
            _randomSource = random ? random : RandomUtils;
            
            this.perParticle = perParticle;
        }
        
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
        public function get perParticle () : Boolean { return _perParticle; }
        public function set perParticle ( perParticle : Boolean ) : void {
            _perParticle = perParticle;
            
            if( _perParticle )
            	_particlesRotationSpeeds = new Dictionary(true);
            else 
            {
            	_particlesRotationSpeeds = null;
                _allParticlesRotationSpeed = _randomSource.rangeAB( _minRotationSpeed, _maxRotationSpeed );
            }
        }
        public function get maxRotationSpeed () : Number { return _maxRotationSpeed; }
        public function set maxRotationSpeed ( maxRotationSpeed : Number ) : void { _maxRotationSpeed = maxRotationSpeed; }

        public function get minRotationSpeed () : Number { return _minRotationSpeed; }
        public function set minRotationSpeed ( minRotationSpeed : Number ) : void { _minRotationSpeed = minRotationSpeed; }

        override public function process ( particle : Particle ) : void
        {
            var doparticle : DisplayObjectParticle = particle as DisplayObjectParticle;
            if( _perParticle )
            {
                if( !_particlesRotationSpeeds[ particle ] )
                	_particlesRotationSpeeds[ particle ] = _randomSource.rangeAB( _minRotationSpeed, _maxRotationSpeed );
                
                doparticle.rotation += _particlesRotationSpeeds[ particle ] * _nTimeStep;
            }
            else
                doparticle.rotation += _allParticlesRotationSpeed * _nTimeStep;
        }
    }
}
