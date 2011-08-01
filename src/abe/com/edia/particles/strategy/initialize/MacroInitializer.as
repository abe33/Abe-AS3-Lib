package abe.com.edia.particles.strategy.initialize
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.edia.particles.strategy.InitializeStrategy;

    /**
     * @author cedric
     */
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
            for each( var a : InitializeStrategy in _initializers )
            	a.system = s;
        }
        
        override public function initialize ( particle : Particle ) : void
        {
            for each( var i : InitializeStrategy in _initializers )
                i.initialize ( particle );
        }
		override protected function getSourceArguments () : String
        {
            return "\n\t"+_initializers.map( function(o:InitializeStrategy,... args):String{ return o.toSource().replace(/\n/g,"\n\t"); } ).join(",\n\t");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return "\n\t"+_initializers.map( function(o:InitializeStrategy,... args):String{ return o.toReflectionSource().replace(/\n/g,"\n\t"); } ).join(",\n\t");
        }	
    }
}
