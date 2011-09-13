package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="emission,particle")]
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
        
        public function get particle () : Particle { return _particle; }
        public function get emission () : ParticleEmission { return _emission; }

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
            var p : Particle = _emission.next();
            p.setParasite( "parentParticle", _particle );
            return p;
        }
        public function remove () : void
        {
            _emission.remove();
        }
        public function reset () : void
        {
            _emission.reset();
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
