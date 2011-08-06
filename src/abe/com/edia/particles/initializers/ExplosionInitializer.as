package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.geom.Range;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

	public class ExplosionInitializer extends AbstractInitializer implements Randomizable
	{
		protected var _angleRange : Range;
		protected var _radiusMin : Number;
		protected var _radiusMax : Number;
        protected var _randomSource : Random;
		
		public function ExplosionInitializer ( radiusMin : Number, radiusMax : Number, angle : Range = null )
		{
			_radiusMin = isNaN( radiusMin ) ? 0 : radiusMin;
			_radiusMax = isNaN( radiusMax ) ? 0 : radiusMax;
			_angleRange = angle ? angle : new Range( 0, Math.PI * 2 );
            
            _randomSource = RandomUtils;
		}
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
        public function get angleRange () : Range { return _angleRange; }
        public function set angleRange ( angleRange : Range ) : void { _angleRange = angleRange; }

        public function get radiusMin () : Number { return _radiusMin; }
        public function set radiusMin ( radiusMin : Number ) : void { _radiusMin = radiusMin; }

        public function get radiusMax () : Number { return _radiusMax; }
        public function set radiusMax ( radiusMax : Number ) : void { _radiusMax = radiusMax; }
        
		override public function initialize(particle:Particle):void
		{
			var a : Number = _randomSource.range( _angleRange );
			var rad : Number = _randomSource.rangeAB( _radiusMin, _radiusMax );
			
			particle.velocity.x = Math.sin( a ) * rad;
			particle.velocity.y = Math.cos( a ) * rad;
        }

        override protected function getSourceArguments () : String
        {
            return [ _radiusMin, _radiusMax, _angleRange.toSource() ].join(", ");
        }

        override protected function getReflectionSourceArguments () : String
        {
            return [ _radiusMin, _radiusMax, _angleRange.toReflectionSource () ].join ( ", " );
        }


	}
}