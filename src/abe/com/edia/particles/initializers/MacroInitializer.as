package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="...initializers")]
    public class MacroInitializer extends AbstractInitializer
    {
        protected var _initializers : Array;
        
        public function MacroInitializer ( ... args )
        {
            this._initializers = args;
        }
        public function get initializers () : Array { return _initializers; }
        public function set initializers ( initializers : Array ) : void { _initializers = initializers; }
        
        override public function set system ( s : ParticleSystem ):void 
        {
        	super.system = s; 
            for each( var a : Initializer in _initializers )
            	a.system = s;
        }
        
        override public function initialize ( particle : Particle ) : void
        {
            for each( var i : Initializer in _initializers )
                i.initialize ( particle );
        }
		
    }
}
