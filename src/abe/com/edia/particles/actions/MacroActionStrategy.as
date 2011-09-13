package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="...actions")]
    public class MacroActionStrategy implements ActionStrategy
    {
        protected var _actions : Array;
        protected var _system : ParticleSystem;

        public function MacroActionStrategy ( ... args )
        {
            _actions = args;
        }
        public function get actions () : Array { return _actions; }
        public function set actions ( actions : Array ) : void { _actions = actions; }
        
        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void 
        {
        	_system = s; 
            for each( var a : ActionStrategy in _actions )
            	a.system = s;
        }

        public function prepare ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            for each( var a : ActionStrategy in _actions )
            	a.prepare(bias, biasInSeconds, currentTime);
        }

        public function process ( particle : Particle ) : void
        {
            for each( var a : ActionStrategy in _actions )
            	a.process(particle);
        }
    }
}
