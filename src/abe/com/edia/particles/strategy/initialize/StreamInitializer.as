package abe.com.edia.particles.strategy.initialize
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.PointUtils;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;

	public class StreamInitializer extends AbstractInitializer
	{
		protected var _stream : Point;
		protected var _randomLength : Number;
		protected var _randomDirection : Number;
		
		public function StreamInitializer ( stream : Point, randomLength : Number = 0, randomDirection : Number = 0 )
		{
			_stream = stream ? stream : new Point();
			_randomLength = isNaN( randomLength ) ? 0 : randomLength;
			_randomDirection = isNaN ( randomDirection ) ? 0 : randomDirection;
		}
		override public function initialize(particle:Particle):void
		{
			var l : Number = _stream.length;
			var p : Point = _stream.clone();
            if( _randomLength != 0 ) 
            {
                l+= RandomUtils.balance( _randomLength );
				p.normalize( l );
            }
            if( _randomDirection != 0 )
				PointUtils.rotate( p, RandomUtils.balance( _randomDirection / 180 * Math.PI ) );

			particle.velocity.x = p.x;
			particle.velocity.y = p.y;
        }

        public function get stream () : Point { return _stream; }
        public function set stream ( stream : Point ) : void { _stream = stream; }

        public function get randomLength () : Number { return _randomLength; }
        public function set randomLength ( randomLength : Number ) : void { _randomLength = randomLength; }

        public function get randomDirection () : Number { return _randomDirection; }
        public function set randomDirection ( randomDirection : Number ) : void { _randomDirection = randomDirection; }
         
        override protected function getSourceArguments () : String
        {
            return [ _$("new flash.geom.Point($0,$1)", _stream.x, _stream.y ), _randomDirection, _randomLength ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ _$("new flash.geom::Point($0,$1)", _stream.x, _stream.y ), _randomDirection, _randomLength ].join(", ");
        }
	}
}