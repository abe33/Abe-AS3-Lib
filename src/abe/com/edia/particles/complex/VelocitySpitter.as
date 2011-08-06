package abe.com.edia.particles.complex
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.edia.particles.counters.Counter;
    import abe.com.edia.particles.emitters.Emitter;
    import abe.com.edia.particles.initializers.Initializer;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.PointUtils;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;


    /**
     * @author cedric
     */
    public class VelocitySpitter implements Counter, Emitter, Initializer
    {
        protected var _target : Object;
        protected var _system : ParticleSystem;
        protected var _velocityMin : Number;
        protected var _velocityMult : Number;
        protected var _velocityCountRatio : Number;
        
        protected var _currentPosition : Point;
       	protected var _currentVelocity : Point;
        protected var _lastPosition : Point;
        protected var _lastVelocity : Point;
        
        protected var _count : int;
        protected var _iterator : int;
        
        public function VelocitySpitter ( target : Object, 
        								  velocityMin : Number = 60,
                                          velocityCountRatio : Number = 0.1,
                                          velocityMult : Number = 3 )
        {
            this.target = target;
            
            _velocityMin = velocityMin;
            _velocityMult = velocityMult;
            _velocityCountRatio = velocityCountRatio;
            
            _lastPosition = pt( target.x, target.y );
            _currentPosition = pt( target.x, target.y );
            _lastVelocity = pt( 0,0 );
            _currentVelocity = pt( 0, 0 );
            
            
            _count = 0; 
        }

        public function get count () : int { return _count; }
        
        public function get target () : Object { return _target; }
        public function set target ( target : Object ) : void {
            if( !target.hasOwnProperty("x") || !target.hasOwnProperty("y") )
            	throw new Error("Target object must have both x and y properties.");
            
            _target = target;
        }
        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ) : void { _system = s; }
        

        public function get ( n : Number = NaN ) : Point
        {
            var l : Number = _currentVelocity.length;
            var p : Point = _currentVelocity.clone();
            p.normalize(l * _iterator/_count);
            p = p.add(_lastPosition);
            _iterator++;
            return p;
        }
        
        public function initialize ( particle : Particle ) : void
        {
            particle.velocity = PointUtils.scaleNew( _currentVelocity, _velocityMult );
        }
        
        public function prepare ( t : Number, ts : Number, time : Number ) : void
        {
            _lastPosition = _currentPosition;
            _currentPosition = pt( _target.x, _target.y );
            _lastVelocity = _currentVelocity;
            _currentVelocity = pt( _target.x - _lastPosition.x, _target.y - _lastPosition.y );
            _iterator = 0;
            
            var l2 : Number = _currentVelocity.length;
            if( l2 > _velocityMin * ts )
            	_count = l2 * _velocityCountRatio;
            else
            	_count = 0; 
        }

		public function toSource():String
		{
		    return _$("new $0($1)", getQualifiedClassName(this).replace("::", "."), getSource( _target, "${target}" ) );
		}
		public function toReflectionSource():String
		{
		    return _$("new $0($1)", getQualifiedClassName(this), getReflectionSource( _target, "${target}" ) );
		}

        public function clone () : *
        {
            return new VelocitySpitter(_target);
        }

     
    }
}
