package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.edia.particles.counters.Counter;
    import abe.com.edia.particles.counters.NullCounter;
    import abe.com.edia.particles.emitters.Emitter;
    import abe.com.edia.particles.emitters.PointEmitter;
    import abe.com.edia.particles.initializers.Initializer;
    import abe.com.edia.particles.timers.NullTimer;
    import abe.com.edia.particles.timers.Timer;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.AllocatorInstance;


    /**
     * @author cedric
     */
    [Serialize(constructorArgs="particleType,emitter,timer,couter,initializer")]
    public class Emission implements ParticleEmission
    {
        protected var _particleType:Class;
        protected var _system : ParticleSystem;
        protected var _counter : Counter;
        protected var _timer : Timer;
        protected var _emitter : Emitter;
        protected var _initializer : Initializer;
        
        protected var _currentCount : int;
        protected var _currentTime : int;
        protected var _iterator : int;
        
        public function Emission ( type : Class, 
        						   emitter : Emitter, 
                                   timer : Timer, 
                                   counter : Counter,
                                   initializer : Initializer = null )
        {
            _particleType = type ? type : Particle;
            _emitter = emitter ? emitter : new PointEmitter(pt());
            _timer = timer ? timer : new NullTimer();
            _counter = counter ? counter : new NullCounter();
            _initializer = initializer;
        }

        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ) : void { _system = s; }

        public function prepare ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            _timer.prepare( bias, biasInSeconds, currentTime );
            var t : Number = _timer.nextTime;
            _counter.prepare( t, t/1000, currentTime );
            
            _currentCount = _counter.count;
            _currentTime = _timer.nextTime;
            _iterator = 0;
        }
        public function hasNext () : Boolean
        {
            return _iterator < _currentCount;
        }
        public function next () : *
        {
            var p : Particle = AllocatorInstance.get(  _particleType ) as Particle; 
			p.position = _emitter.get();
            _iterator++;
            
            if( _initializer )
            	_initializer.initialize( p );
			return p;
        }
        public function isFinish () : Boolean {  return _timer.isFinish; }
        
        public function nextTime () : Number
        {
            return _iterator / _currentCount * _currentTime;
        }
        
        public function remove () : void {}
        public function reset () : void {}
        
        public function clone () : *
        {
            return new Emission(_particleType, 
            					_emitter.clone(), 
                                _timer.clone(), 
                                _counter.clone () );
        }

        public function get particleType () : Class {
            return _particleType;
        }

        public function set particleType ( particleType : Class ) : void {
            _particleType = particleType;
        }

        public function get emitter () : Emitter {
            return _emitter;
        }

        public function set emitter ( emitter : Emitter ) : void {
            _emitter = emitter;
        }

        public function get initializer () : Initializer {
            return _initializer;
        }

        public function set initializer ( initializer : Initializer ) : void {
            _initializer = initializer;
        }

        public function get timer () : Timer {
            return _timer;
        }

        public function set timer ( timer : Timer ) : void {
            _timer = timer;
        }

        public function get counter () : Counter {
            return _counter;
        }

        public function set counter ( counter : Counter ) : void {
            _counter = counter;
        }
        
    }
}
