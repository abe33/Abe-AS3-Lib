package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.patibility.lang._$;
    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class SubSystemEmission implements ParticleEmission
    {
        protected var _emission : ParticleEmission;
        protected var _particle : Particle;
        protected var _system : ParticleSystem;
        
        public function SubSystemEmission ( emission : ParticleEmission, particle : Particle = null )
        {
            _emission = emission;
            _particle = particle;
            particle.died.addOnce(particleDied);
        }

        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void { _system = s; _emission.system = s; }

        public function isFinish () : Boolean
        {
            return _emission.isFinish() || !_particle || _particle.isDead();
        }
        public function prepare ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            _emission.prepare(bias, biasInSeconds, currentTime);
        }
        public function nextTime () : Number
        {
            return _emission.nextTime();
        }
        public function hasNext () : Boolean
        {
            return _emission.hasNext();
        }
        public function next () : *
        {
            return _emission.next();
        }
        public function remove () : void
        {
            _emission.remove();
        }
        public function reset () : void
        {
            _emission.reset();
        }
        public function toSource () : String
        {
            return _$(	"new $0($1,$2)", 
            			getQualifiedClassName(this).replace("::", "."), 
                        _emission.toSource(), 
                        "${particle}" );
        }
        public function toReflectionSource () : String
        {
            return _$(	"new $0($1,$2)", 
            			getQualifiedClassName(this), 
                        _emission.toReflectionSource(), 
                        "${particle}" );
        }
        public function clone () : *
        {
            return new SubSystemEmission( _emission.clone(), _particle );
        }
        protected function particleDied ( p : Particle ) : void
        {
            _system.stopEmission( this );
            _particle = null;
        }
    }
}
