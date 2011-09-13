package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

	[Serialize(constructorArgs="lifeMin,lifeMax,randomSource")]
	public class LifeInitializer extends AbstractInitializer implements Randomizable 
	{
		protected var _lifeMin : uint;
        protected var _lifeMax : uint;
        protected var _randomSource : Random;
		
		public function LifeInitializer ( lifeMin : uint, lifeMax : uint = 0, random : Random = null )
		{
			_lifeMin = lifeMin;
			_lifeMax = lifeMax;
            
            _randomSource = random ? random : RandomUtils;
		}
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
		override public function initialize( particle : Particle ) : void
		{
            if( _lifeMax != 0 )
				particle.maxLife = _randomSource.irangeAB(_lifeMin,_lifeMax);
            else
                particle.maxLife = _lifeMin;
        }

        public function get lifeMin () : uint {
            return _lifeMin;
        }

        public function set lifeMin ( lifeMin : uint ) : void {
            _lifeMin = lifeMin;
        }

        public function get lifeMax () : uint {
            return _lifeMax;
        }

        public function set lifeMax ( lifeMax : uint ) : void {
            _lifeMax = lifeMax;
        }
       
	}
}