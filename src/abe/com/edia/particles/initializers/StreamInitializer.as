package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.PointUtils;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;
	[Serialize(constructorArgs="stream,randomLength,randomDirection,randomSource")]
	public class StreamInitializer extends AbstractInitializer implements Randomizable
	{
		protected var _stream : Point;
		protected var _randomLength : Number;
        protected var _randomDirection : Number;
        protected var _randomSource : Random;
		
		public function StreamInitializer ( stream : Point, randomLength : Number = 0, randomDirection : Number = 0, random : Random = null )
		{
			_stream = stream ? stream : new Point();
			_randomLength = isNaN( randomLength ) ? 0 : randomLength;
			_randomDirection = isNaN ( randomDirection ) ? 0 : randomDirection;
            
            _randomSource = random ? random : RandomUtils;
		}
        public function get stream () : Point { return _stream; }
        public function set stream ( stream : Point ) : void { _stream = stream; }

        public function get randomLength () : Number { return _randomLength; }
        public function set randomLength ( randomLength : Number ) : void { _randomLength = randomLength; }

        public function get randomDirection () : Number { return _randomDirection; }
        public function set randomDirection ( randomDirection : Number ) : void { _randomDirection = randomDirection; }
        
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
		override public function initialize(particle:Particle):void
		{
			var l : Number = _stream.length;
			var p : Point = _stream.clone();
            if( _randomLength != 0 ) 
            {
                l+= _randomSource.balance( _randomLength );
				p.normalize( l );
            }
            if( _randomDirection != 0 )
				PointUtils.rotate( p, _randomSource.balance( _randomDirection / 180 * Math.PI ) );

			particle.velocity.x = p.x;
			particle.velocity.y = p.y;
        }

	}
}